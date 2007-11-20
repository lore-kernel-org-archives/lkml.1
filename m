Return-Path: <linux-kernel-owner+w=401wt.eu-S1756261AbXKTEiP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756261AbXKTEiP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2007 23:38:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752269AbXKTEiA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Nov 2007 23:38:00 -0500
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:47831 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751983AbXKTEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2007 23:37:59 -0500
Date: Tue, 20 Nov 2007 05:37:42 +0100
From: Adrian Bunk <bunk@kernel.org>
To: Willy Tarreau <w@1wt.eu>
Cc: Nick Piggin <nickpiggin@yahoo.com.au>, Mark Lord <lkml@rtr.ca>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@osdl.org>, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: CONFIG_IRQBALANCE for 64-bit x86 ?
Message-ID: <20071120043742.GE6164@stusta.de>
References: <47425EA5.7000607@rtr.ca> <200711201517.16171.nickpiggin@yahoo.com.au> <20071120042929.GD15227@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20071120042929.GD15227@1wt.eu>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 05:29:29AM +0100, Willy Tarreau wrote:
> On Tue, Nov 20, 2007 at 03:17:15PM +1100, Nick Piggin wrote:
> > On Tuesday 20 November 2007 15:12, Mark Lord wrote:
> > > On 32-bit x86, we have CONFIG_IRQBALANCE available,
> > > but not on 64-bit x86.  Why not?
> > >
> > > I ask, because this feature seems almost essential to obtaining
> > > reasonable latencies during heavy I/O with fast devices.
> > >
> > > My 32-bit Core2Duo MythTV box drops audio frames without it,
> > > but works perfectly *with* IRQBALANCE.
> > >
> > > My QuadCore box works very well in 32-bit mode with IRQBALANCE,
> > > but responsiveness sucks bigtime when run in 64-bit mode (no IRQBALANCE)
> > > during periods of multiple heavy I/O streams (USB flash drives).
> > >
> > > That's with both the 32 and 64 bit versions of Kubuntu Gutsy,
> > > so the software uses pretty much identical versions either way.
> > >
> > > As near as I can tell, when IRQBALANCE is not configured,
> > > all I/O device interrupts go to CPU#0.
> > >
> > > I don't think our CPU scheduler takes that into account when assigning
> > > tasks to CPUs, so anything sent to CPU0 runs with very high latencies.
> > >
> > > Or something like that.
> > >
> > > Why no IRQ_BALANCE in 64-bit mode ?
> > 
> > For that matter, I'd like to know why it has been decided that the
> > best place for IRQ balancing is in userspace. It should be in kernel
> > IMO, and it would probably allow better power saving, performance,
> > fairness, etc. if it were to be integrated with the task balancer as
> > well.
> 
> Agreed. When userspace has something to do with the way IRQs are
> delivered, it's going to smell as bad as micro-kernels...

The next step to a micro-kernel would then be hardware drivers and file 
systems in userspace?  ;-)

> Willy

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

