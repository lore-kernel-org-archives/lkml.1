Return-Path: <linux-kernel-owner+w=401wt.eu-S965164AbXDNT4g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965164AbXDNT4g (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 15:56:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965533AbXDNT4g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 15:56:36 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:2511 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965164AbXDNT4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 15:56:35 -0400
Date: Sat, 14 Apr 2007 21:56:11 +0200
From: Tobias Diedrich <ranma@tdiedrich.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414195611.GC806@yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma@tdiedrich.de>,
	"Rafael J. Wysocki" <rjw@sisk.pl>, Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	Maxim Levitsky <maximlevitsky@gmail.com>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070414123154.GA2863@melchior.yamamaya.is-a-geek.org> <20070414130045.GE3691@stusta.de> <200704142028.04694.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200704142028.04694.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> On Saturday, 14 April 2007 15:00, Adrian Bunk wrote:
> > On Sat, Apr 14, 2007 at 02:31:54PM +0200, Tobias Diedrich wrote:
> > > Tobias Diedrich wrote:
> > > > > ed746e3b18f4df18afa3763155972c5835f284c5 is first bad commit
> > > > > commit ed746e3b18f4df18afa3763155972c5835f284c5
> > > > > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > > > > Date:   Sat Feb 10 01:43:32 2007 -0800
> > > > > 
> > > > >     [PATCH] swsusp: Change code ordering in disk.c
> > > > >     
> > > > >     Change the ordering of code in kernel/power/disk.c so that device_suspend() is
> > > > >     called before disable_nonboot_cpus() and platform_finish() is called after
> > > > >     enable_nonboot_cpus() and before device_resume(), as indicated by the recent
> > > > >     discussion on Linux-PM (cf.
> > > > >     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
> > > > >     
> > > > >     The changes here only affect the built-in swsusp.
> > > > >     
> > > > >     [alexey.y.starikovskiy@linux.intel.com: fix LED blinking during image load]
> > > > >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> > > > >     Acked-by: Pavel Machek <pavel@ucw.cz>
> > > > >     Cc: Greg KH <greg@kroah.com>
> > > > >     Cc: Nigel Cunningham <nigel@suspend2.net>
> > > > >     Cc: Patrick Mochel <mochel@digitalimplant.org>
> > > > >     Cc: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
> > > > >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> > > > >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > > > > 
> > > > > :040000 040000 7eca5b3a8f9606bc4f2ff41192ec8c9d4ca90d18 8313b674e1d1bdf6849350af06d28a89b3bb3054 M      kernel
> > > > > 
> > > > > 
> > > > > Now, the remaining test is to try reverting this commit from -rc6. :)
> > > > 
> > > > Doesn't apply cleanly against -rc6, but fixes the problem when
> > > > reverted from -rc1.
> > > 
> > > Now, this was already reported in
> > > http://lkml.org/lkml/2007/3/16/126
> > > and I even flagged that message in my local folder, but apparently forgot
> > > to follow up on it... *sigh*
> > 
> > Unless I misunderstood something, all of the problems Maxim described in 
> > this email are fixed for him in -rc6.
> > 
> > But it's quite possible that you are running into a different issue 
> > exposed by this commit.
> 
> Yes, it's likely.
> 
> Tobias, I'm unable to reproduce the problem with your .config, but my hardware
> is certainly different.  Which suspend mode do you use?  If that's "platform",
> can you try to use "shutdown" or "reboot" and see if that helps?

Sure.
shutdown/reboot works fine, only platform is broken.

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
