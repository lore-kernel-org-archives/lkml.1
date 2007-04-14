Return-Path: <linux-kernel-owner+w=401wt.eu-S932279AbXDNMcJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932279AbXDNMcJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 08:32:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932310AbXDNMcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 08:32:09 -0400
Received: from yumi.tdiedrich.de ([85.10.210.183]:3764 "EHLO yumi.tdiedrich.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932279AbXDNMcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 08:32:08 -0400
Date: Sat, 14 Apr 2007 14:31:54 +0200
From: Tobias Diedrich <ranma+kernel@tdiedrich.de>
To: Adrian Bunk <bunk@stusta.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, pavel@suse.cz,
       linux-pm@lists.osdl.org, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Linux 2.6.21-rc6
Message-ID: <20070414123154.GA2863@melchior.yamamaya.is-a-geek.org>
Mail-Followup-To: Tobias Diedrich <ranma+kernel@tdiedrich.de>,
	Adrian Bunk <bunk@stusta.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	pavel@suse.cz, linux-pm@lists.osdl.org,
	"Rafael J. Wysocki" <rjw@sisk.pl>
References: <Pine.LNX.4.64.0704051944230.6730@woody.linux-foundation.org> <20070413212954.GA2545@melchior.yamamaya.is-a-geek.org> <20070413235017.GR5907@stusta.de> <20070414120900.GA3001@melchior.yamamaya.is-a-geek.org> <20070414122447.GA2827@melchior.yamamaya.is-a-geek.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20070414122447.GA2827@melchior.yamamaya.is-a-geek.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tobias Diedrich wrote:
> > ed746e3b18f4df18afa3763155972c5835f284c5 is first bad commit
> > commit ed746e3b18f4df18afa3763155972c5835f284c5
> > Author: Rafael J. Wysocki <rjw@sisk.pl>
> > Date:   Sat Feb 10 01:43:32 2007 -0800
> > 
> >     [PATCH] swsusp: Change code ordering in disk.c
> >     
> >     Change the ordering of code in kernel/power/disk.c so that device_suspend() is
> >     called before disable_nonboot_cpus() and platform_finish() is called after
> >     enable_nonboot_cpus() and before device_resume(), as indicated by the recent
> >     discussion on Linux-PM (cf.
> >     http://lists.osdl.org/pipermail/linux-pm/2006-November/004164.html).
> >     
> >     The changes here only affect the built-in swsusp.
> >     
> >     [alexey.y.starikovskiy@linux.intel.com: fix LED blinking during image load]
> >     Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> >     Acked-by: Pavel Machek <pavel@ucw.cz>
> >     Cc: Greg KH <greg@kroah.com>
> >     Cc: Nigel Cunningham <nigel@suspend2.net>
> >     Cc: Patrick Mochel <mochel@digitalimplant.org>
> >     Cc: Alexey Starikovskiy <alexey.y.starikovskiy@linux.intel.com>
> >     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > :040000 040000 7eca5b3a8f9606bc4f2ff41192ec8c9d4ca90d18 8313b674e1d1bdf6849350af06d28a89b3bb3054 M      kernel
> > 
> > 
> > Now, the remaining test is to try reverting this commit from -rc6. :)
> 
> Doesn't apply cleanly against -rc6, but fixes the problem when
> reverted from -rc1.

Now, this was already reported in
http://lkml.org/lkml/2007/3/16/126
and I even flagged that message in my local folder, but apparently forgot
to follow up on it... *sigh*

-- 
Tobias						PGP: http://9ac7e0bc.uguu.de
このメールは十割再利用されたビットで作られています。
