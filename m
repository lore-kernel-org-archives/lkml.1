Return-Path: <linux-kernel-owner+w=401wt.eu-S1758115AbYABHP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758115AbYABHP4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 02:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756382AbYABHPo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 02:15:44 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42632 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756171AbYABHPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 02:15:43 -0500
Date: Tue, 1 Jan 2008 23:14:31 -0800
From: Greg KH <greg@kroah.com>
To: Andreas Mohr <andi@lisas.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Ingo Molnar <mingo@elte.hu>,
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
Message-ID: <20080102071431.GA32357@kroah.com>
References: <20071231052500.GB4187@kroah.com> <Pine.LNX.4.44L0.0712311237150.7182-100000@iolanthe.rowland.org> <20071231192643.GA25341@kroah.com> <20080102060006.GA27693@kroah.com> <20080102061308.GB30929@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080102061308.GB30929@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2008 at 07:13:08AM +0100, Andreas Mohr wrote:
> Hi,
> 
> On Tue, Jan 01, 2008 at 10:00:06PM -0800, Greg KH wrote:
> > Ok, no, I didn't write that patch, I'm getting very confused here.
> > 
> > In 2.6.24-rc6 there is no usage of debugfs in the ohci driver.
> > 
> > In the -mm tree there is a patch, from Tony Jones, that moves some debug
> > code out of sysfs and into debugfs where it belongs.  It does it for
> > both the ehci and ohci USB host controller drivers, and this is the code
> > that is incorrect if CONFIG_DEBUGFS is not enabled.
> > 
> > So, for the 2.6.24 release, nothing needs to be changed, all is good,
> > and there is no regression.
> > 
> > Right?  Or am I still confused about this whole thing?
> 
> Probably, since I also wasn't sure about this getting added to the
> post-2.6.23 regressions. I'd expect this problem to be -mm only myself,
> but then I didn't actively verify it in code (and I haven't tried -rc6
> proper on that machine yet either, build takes ages ;).
> OK, since I cannot really offer anything other than positive feelings about
> this being non-rc6 breakage, should I try -rc6 proper, too?

Please do, that would be very helpful.

As the code being discussed isn't even in Linus's tree, it's hard to see
how this could be a proposed fix for the regression :)

thanks,

greg k-h
