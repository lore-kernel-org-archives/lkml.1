Return-Path: <linux-kernel-owner+w=401wt.eu-S1754085AbXDOXjo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbXDOXjo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 19:39:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbXDOXjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 19:39:44 -0400
Received: from holomorphy.com ([66.93.40.71]:58704 "EHLO holomorphy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085AbXDOXjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 19:39:44 -0400
Date: Sun, 15 Apr 2007 16:39:09 -0700
From: William Lee Irwin III <wli@holomorphy.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Matt Mackall <mpm@selenic.com>, Con Kolivas <kernel@kolivas.org>,
       Peter Williams <pwil3058@bigpond.net.au>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Nick Piggin <npiggin@suse.de>, Mike Galbraith <efault@gmx.de>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415233909.GE2986@holomorphy.com>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu> <20070415200535.GC11166@waste.org> <20070415204824.GA25813@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415204824.GA25813@elte.hu>
Organization: The Domain of Holomorphy
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
> 2) plugsched did not allow on the fly selection of schedulers, nor did
>    it allow a per CPU selection of schedulers. IO schedulers you can 
>    change per disk, on the fly, making them much more useful in
>    practice. Also, IO schedulers (while definitely not being slow!) are 
>    alot less performance sensitive than CPU schedulers.

One of the reasons I never posted my own code is that it never met its
own design goals, which absolutely included switching on the fly. I
think Peter Williams may have done something about that. It was my hope
to be able to do insmod sched_foo.ko until it became clear that the
effort it was intended to assist wasn't going to get even the limited
hardware access required, at which point I largely stopped working on
it.


On Sun, Apr 15, 2007 at 10:48:24PM +0200, Ingo Molnar wrote:
> 3) I/O schedulers are pretty damn clean code, and plugsched, at least
>    the last version i saw of it, didnt come even close.

I'm not sure what happened there. It wasn't a big enough patch to take
hits in this area due to getting overwhelmed by the programming burden
like some other efforts of mine. Maybe things started getting ugly once
on-the-fly switching entered the picture. My guess is that Peter Williams
will have to chime in here, since things have diverged enough from my
one-time contribution 4 years ago.


-- wli
