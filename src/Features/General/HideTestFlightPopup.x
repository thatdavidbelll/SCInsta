#import "../../Utils.h"

// Sideloaded installs have a "sandboxReceipt", which makes Instagram think it is a TestFlight beta
// and show the "It's time to update Instagram Beta" screen (adapted from efibalogh/sparkle-ig)
%hook NSBundle
- (NSURL *)appStoreReceiptURL {
    NSURL *url = %orig;

    if (self == NSBundle.mainBundle && [url.lastPathComponent isEqualToString:@"sandboxReceipt"]) {
        return [[url URLByDeletingLastPathComponent] URLByAppendingPathComponent:@"receipt"];
    }

    return url;
}
%end

// Fallback for when the update screen is still triggered by previously cached state
// Demangled name: IGCoreRootTestFlightNagPlugin.TestFlightUpdateNudgeViewController
%hook _TtC29IGCoreRootTestFlightNagPlugin35TestFlightUpdateNudgeViewController
- (void)viewDidAppear:(BOOL)animated {
    %orig;

    NSLog(@"[SCInsta] Dismissing TestFlight update screen");

    [(UIViewController *)self dismissViewControllerAnimated:NO completion:nil];
}
%end
