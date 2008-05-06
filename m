Return-Path: <linux-kernel-owner+w=401wt.eu-S933511AbYEFWoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933511AbYEFWoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 18:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754956AbYEFWn4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 18:43:56 -0400
Received: from xenotime.net ([66.160.160.81]:55650 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753973AbYEFWnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 18:43:55 -0400
Date: Tue, 6 May 2008 15:43:47 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Russell King <rmk+lkml@arm.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, Philipp Zabel <philipp.zabel@gmail.com>
Subject: Re: drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No
 such file or directory
In-Reply-To: <200805070037.59263.rjw@sisk.pl>
Message-ID: <Pine.LNX.4.64.0805061543070.17702@shark.he.net>
References: <20080422074124.GA12187@elte.hu> <20080422083722.GA3609@flint.arm.linux.org.uk>
 <200805070037.59263.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 May 2008, Rafael J. Wysocki wrote:

> On Tuesday, 22 of April 2008, Russell King wrote:
> > On Tue, Apr 22, 2008 at 09:41:24AM +0200, Ingo Molnar wrote:
> > > 
> > > make allyesconfig (on 64-bit x86) build fails on latest -git with the 
> > > following message:
> > > 
> > > drivers/mfd/htc-pasic3.c:22:31: error: asm/arch/pxa-regs.h: No such file or directory
> > > 
> > > i suspect this driver was not supposed to be buildable on non-ARM-PXA? 
> > > The patch below should fix this.
> > 
> > Known issue.  Thanks.
> 
> Has it been fixed in the mainline?

Yes:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=328d8a012583f0c25f8db25a2e5e63b521201542

-- 
~Randy
