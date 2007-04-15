Return-Path: <linux-kernel-owner+w=401wt.eu-S1753987AbXDOVqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753987AbXDOVqS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 17:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753985AbXDOVqR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 17:46:17 -0400
Received: from waste.org ([66.93.16.53]:42652 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987AbXDOVpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 17:45:44 -0400
Date: Sun, 15 Apr 2007 16:31:54 -0500
From: Matt Mackall <mpm@selenic.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Con Kolivas <kernel@kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415213153.GW11115@waste.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415204824.GA25813@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
> 
> * Matt Mackall <mpm@selenic.com> wrote:
> 
> > Look at what happened with I/O scheduling. Opening things up to some 
> > new ideas by making it possible to select your I/O scheduler took us 
> > from 10 years of stagnation to healthy, competitive development, which 
> > gave us a substantially better I/O scheduler.
> 
> actually, 2-3 years ago we already had IO schedulers, and my opinion 
> against plugsched back then (also shared by Nick and Linus) was very 
> much considering them. There are at least 4 reasons why I/O schedulers 
> are different from CPU schedulers:

...

> 3) I/O schedulers are pretty damn clean code, and plugsched, at least
>    the last version i saw of it, didnt come even close.

That's irrelevant. Plugsched was an attempt to get alternative
schedulers exposure in mainline. I know, because I remember
encouraging Bill to pursue it. Not only did you veto plugsched (which
may have been a perfectly reasonable thing to do), but you also vetoed
the whole concept of multiple schedulers in the tree too. "We don't
want to balkanize the scheduling landscape".

And that latter part is what I'm claiming has set us back for years.
It's not a technical argument but a strategic one. And it's just not a
good strategy.
 
> 4) the good thing that happened to I/O, after years of stagnation isnt
>    I/O schedulers. The good thing that happened to I/O is called Jens
>    Axboe. If you care about the I/O subystem then print that name out 
>    and hang it on the wall. That and only that is what mattered.

Disagree. Things didn't actually get interesting until Nick showed up
with AS and got it in-tree to demonstrate the huge amount of room we
had for improvement. It took several iterations of AS and CFQ (with a
couple complete rewrites) before CFQ began to look like the winner.
The resulting time-sliced CFQ was fairly heavily influenced by the
ideas in AS.

Similarly, things in scheduler land had been pretty damn boring until
Con finally got Andrew to take one of his schedulers for a spin.

> nor was the non-modularity of some piece of code ever an impediment to 
> competition. May i remind you of the pretty competitive SLAB allocator 
> landscape, resulting in things like the SLOB allocator, written by 
> yourself? ;-)

Thankfully no one came out and said "we don't want to balkanize the
allocator landscape" when I submitted it or I probably would have just
dropped it, rather than painfully dragging it along out of tree for
years. I'm not nearly the glutton for punishment that Con is. :-P

-- 
Mathematics is the supreme nostalgia of our time.
