Return-Path: <linux-kernel-owner+w=401wt.eu-S1758770AbYABP4z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758770AbYABP4z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 10:56:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754510AbYABP4p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 10:56:45 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:44656 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754173AbYABP4n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 10:56:43 -0500
Date: Wed, 2 Jan 2008 10:56:43 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Greg KH <greg@kroah.com>
cc: Andreas Mohr <andi@lisas.de>, Ingo Molnar <mingo@elte.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Pavel Machek <pavel@ucw.cz>,
       kernel list <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, Pavel Emelyanov <xemul@openvz.org>,
       "Denis V. Lunev" <den@openvz.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [usb regression] Re: [PATCH 2.6.24-rc3] Fix /proc/net breakage
In-Reply-To: <20080102060006.GA27693@kroah.com>
Message-ID: <Pine.LNX.4.44L0.0801021052470.4861-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jan 2008, Greg KH wrote:

> On Mon, Dec 31, 2007 at 11:26:43AM -0800, Greg KH wrote:
> > On Mon, Dec 31, 2007 at 12:49:52PM -0500, Alan Stern wrote:
> > > On Sun, 30 Dec 2007, Greg KH wrote:
> > > 
> > > > > It looks like Greg misused the debugfs API -- which is ironic, because
> > > > > he wrote debugfs in the first place!  :-)

> Ok, no, I didn't write that patch, I'm getting very confused here.
> 
> In 2.6.24-rc6 there is no usage of debugfs in the ohci driver.
> 
> In the -mm tree there is a patch, from Tony Jones, that moves some debug
> code out of sysfs and into debugfs where it belongs.  It does it for
> both the ehci and ohci USB host controller drivers, and this is the code
> that is incorrect if CONFIG_DEBUGFS is not enabled.

My mistake; I got the impression you had written that new code rather
than Tony.  BTW, I don't recall ever seeing Tony's patch announced on
linux-usb or linux-usb-devel.  Did I simply miss it?

> So, for the 2.6.24 release, nothing needs to be changed, all is good,
> and there is no regression.
> 
> Right?  Or am I still confused about this whole thing?

Correct.  The problem exists only in -mm and your development tree.

> I will go fix up Tony's patches in the -mm tree that do not handle the
> error return values from debugfs properly, but that is not such a rush,
> as Tony is on vacation for a few weeks, and those patches are going to
> be going in only after 2.6.24 is out.

The fix I posted earlier in this thread should simply be merged into 
Tony's patches.

Alan Stern

