Return-Path: <linux-kernel-owner+w=401wt.eu-S1757923AbXJYV45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757923AbXJYV45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2007 17:56:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752972AbXJYV4u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Oct 2007 17:56:50 -0400
Received: from tim.rpsys.net ([194.106.48.114]:50634 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbXJYV4t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2007 17:56:49 -0400
Subject: Re: [Bugme-new] [Bug 9217] New: CONFIG_CMDLINE doesn't pass to
	kernel
From: Richard Purdie <rpurdie@rpsys.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: buytenh@wantstofly.org, svs1957@gmail.com, bgat@billgatliff.com,
       linux-kernel@vger.kernel.org, bugme-daemon@bugzilla.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk, rmk@arm.linux.org.uk
In-Reply-To: <20071025130250.cd759e90.akpm@linux-foundation.org>
References: <bug-9217-10286@http.bugzilla.kernel.org/>
	 <20071024195717.0de6a248.akpm@linux-foundation.org>
	 <47200F05.2050305@billgatliff.com>
	 <20071025122303.GB7543@xi.wantstofly.org>
	 <1193319816.6167.45.camel@localhost.localdomain>
	 <20071025130250.cd759e90.akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 25 Oct 2007 22:54:52 +0100
Message-Id: <1193349292.17244.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2007-10-25 at 13:02 -0700, Andrew Morton wrote:
> On Thu, 25 Oct 2007 14:43:36 +0100
> Richard Purdie <rpurdie@rpsys.net> wrote: 
> > Could the original bug reporter please report what commandline the
> > kernel actually uses please? In theory it can only be either:
> > 
> > * the one being compiled in with CONFIG_CMDLINE
> > * the one hardcoded into the bootloader
> > 
> > but I'd be surprised it boots at all with the latter!
> 
> It was in the inital report, at
> http://bugzilla.kernel.org/show_bug.cgi?id=9217 :

No it wasn't, I'd looked.

> : I try to upgrade kernel from 2.6.22.9 to 2.6.23.
> : 2.6.22.9 works correct. Kernel 2.6.23 doesn't use  CONFIG_CMDLINE and doesn't
> : pass bootparams:
> : CONFIG_CMDLINE="console=ttyS0,115200n8 console=tty1 noinitrd
> : root=/dev/mmcblk0p1 rootfstype=ext3 rw rootdelay=5"
> : But kernel still try to mount /dev/mtdblock2 using jffs2.
> : Steps to reproduce:
> : Compile kernel with CONFIG_CMDLINE and try to boot.

This is the commandline they wanted to use, not the one that was
actually used. The one that was used should appear on the console, on
the serial console if they have the lead or in dmesg when the device
boots. We know it probably contained root=/dev/mtdblock2 but thats it.

I'd like to confirm which commandline is appearing since if we know
which one it is we might stand a chance of knowing where it came from,
until then this is just a guessing game.

Cheers,

Richard

