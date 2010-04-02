#import "CQWelcomeController.h"

#import "CQColloquyApplication.h"
#import "CQHelpTopicsViewController.h"
#import "CQWelcomeViewController.h"

@implementation CQWelcomeController
- (id) init {
	if (!(self = [super init]))
		return nil;

	self.delegate = self;

	if ([self respondsToSelector:@selector(setModalPresentationStyle:)])
		self.modalPresentationStyle = UIModalPresentationFormSheet;

	_shouldShowConnections = YES;

	return self;
}

- (void) dealloc {
	self.delegate = nil;

	[_rootViewController release];

	[super dealloc];
}

#pragma mark -

@synthesize shouldShowOnlyHelpTopics = _shouldShowOnlyHelpTopics;
@synthesize shouldShowConnections = _shouldShowConnections;

#pragma mark -

- (void) viewDidLoad {
	[super viewDidLoad];

	if (_shouldShowOnlyHelpTopics && !_rootViewController)
		_rootViewController = [[CQHelpTopicsViewController alloc] init];
	else if (!_rootViewController)
		_rootViewController = [[CQWelcomeViewController alloc] init];

	UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(close:)];
	_rootViewController.navigationItem.rightBarButtonItem = doneItem;
	[doneItem release];

	[self pushViewController:_rootViewController animated:NO];
}

- (void) viewWillAppear:(BOOL) animated {
	[super viewWillAppear:animated];

	_previousStatusBarStyle = [UIApplication sharedApplication].statusBarStyle;

	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:animated];
}

- (void) viewWillDisappear:(BOOL) animated {
	[super viewWillDisappear:animated];

	[[UIApplication sharedApplication] setStatusBarStyle:_previousStatusBarStyle animated:animated];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return ![[NSUserDefaults standardUserDefaults] boolForKey:@"CQDisableLandscape"];
}

#pragma mark -

- (void) close:(id) sender {
	if (!_shouldShowOnlyHelpTopics && _shouldShowConnections)
		[[CQColloquyApplication sharedApplication] showConnections:nil];

	[self dismissModalViewControllerAnimated:YES];
}
@end