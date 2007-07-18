Return-Path: <linux-kernel-owner+w=401wt.eu-S1764827AbXGROO4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764827AbXGROO4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 10:14:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755186AbXGROOs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 10:14:48 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1696 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759112AbXGROOr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 10:14:47 -0400
Date: Wed, 18 Jul 2007 16:14:26 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ingo Molnar <mingo@elte.hu>
cc: Peter Zijlstra <peterz@infradead.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       James Bruce <bruce@andrew.cmu.edu>,
       Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
       Andrea Arcangeli <andrea@suse.de>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>,
       Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] CFS: Fix missing digit off in wmult table
In-Reply-To: <20070718134811.GA9227@elte.hu>
Message-ID: <Pine.LNX.4.64.0707181558590.1817@scrub.home>
References: <469B0D9E.3030402@andrew.cmu.edu> <20070716070610.GA10907@elte.hu>
 <Pine.LNX.4.64.0707161213500.1817@scrub.home> <20070716112037.GA6895@elte.hu>
 <Pine.LNX.4.64.0707161331570.1817@scrub.home>
 <alpine.LFD.0.999.0707161045520.20061@woody.linux-foundation.org>
 <1184754430.20032.130.camel@twins> <Pine.LNX.4.64.0707181442340.1817@scrub.home>
 <1184763148.20032.135.camel@twins> <Pine.LNX.4.64.0707181506460.1817@scrub.home>
 <20070718134811.GA9227@elte.hu>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, 18 Jul 2007, Ingo Molnar wrote:

> _changing_ it is an option within reason, and we've done it a couple of 
> times already in the past, and even within CFS (as Peter correctly 
> observed) we've been through a couple of iterations already. And as i 
> mentioned it before, the outer edge of nice levels (+19, by far the most 
> commonly used nice level) was inconsistent to begin with: 3%, 5%, 9% of 
> nice-0, depending on HZ.

Why do you constantly stress level 19? Yes, that one is special, all other 
positive levels were already relatively consistent.

> So changing that to a consistent (and 
> user-requested)

How old is CFS and how many users did it have so far? How many users has 
the old scheduler, which will be exposed to the new one soon?

> 1.5% is a much smaller change than you seem to make it 
> out to be.

The percentage levels are off by a factor of upto _seven_, sorry I fail 
see how you can characterize this as "small".

> So by your standard we could never change the 
> scheduler. (which your ultimate argument might be after all =B-)

Careful, you make assertion about me, for which you have absolutely no 
base, adding a smiley doesn't make this any funnier.

bye, Roman
