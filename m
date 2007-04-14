Return-Path: <linux-kernel-owner+w=401wt.eu-S1753132AbXDNPSA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753132AbXDNPSA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 11:18:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753430AbXDNPSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 11:18:00 -0400
Received: from ottawa-hs-64-26-128-89.s-ip.magma.ca ([64.26.128.89]:3598 "EHLO
	mail.rtr.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753132AbXDNPSA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 11:18:00 -0400
Message-ID: <4620F0A5.9060707@rtr.ca>
Date: Sat, 14 Apr 2007 11:17:57 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair
 Scheduler [CFS]
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu>
In-Reply-To: <20070414105338.GB19454@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i kept the 50%/50% rule from the old scheduler, but maybe it's a more 
> pristine (and smaller/faster) approach to just not give new children any 
> stats history to begin with. I've implemented an add-on patch that 
> implements this, you can find it at:
> 
>     http://redhat.com/~mingo/cfs-scheduler/sched-fair-fork.patch

I've been running my desktop (single-core Pentium-M w/2GB RAM, Kubuntu Dapper)
with the new CFS for much of this morning now, with the odd switch back to
the stock scheduler for comparison.

Here, CFS really works and feels better than the stock scheduler.

Even with a "make -j2" kernel rebuild happening (no manual renice, either!)
things "just work" about as smoothly as ever.  That's something which RSDL
never achieved for me, though I have not retested RSDL beyond v0.34 or so.

Well done, Ingo!  I *want* this as my default scheduler.

Things seemed slightly less smooth when I had the CPU hogs
and fair-fork extension patches both applied.

I'm going to try again now with just the fair-fork added on.

Cheers

Mark
