Return-Path: <linux-kernel-owner+w=401wt.eu-S1753686AbXDOUTT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbXDOUTT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 16:19:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753698AbXDOUTT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 16:19:19 -0400
Received: from waste.org ([66.93.16.53]:52077 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753681AbXDOUTS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 16:19:18 -0400
Date: Sun, 15 Apr 2007 15:05:35 -0500
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
Message-ID: <20070415200535.GC11166@waste.org>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <20070415150536.GA6623@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070415150536.GA6623@elte.hu>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 05:05:36PM +0200, Ingo Molnar wrote:
> so the rejection was on these grounds, and i still very much stand by 
> that position here and today: i didnt want to see the Linux scheduler 
> landscape balkanized and i saw no technological reasons for the 
> complication that external modularization brings.

But "balkanization" is a good thing. "Monoculture" is a bad thing.

Look at what happened with I/O scheduling. Opening things up to some
new ideas by making it possible to select your I/O scheduler took us
from 10 years of stagnation to healthy, competitive development, which
gave us a substantially better I/O scheduler.

Look at what's happening right now with TCP congestion algorithms.
We've had decades of tweaking Reno slightly now turned into a vibrant
research area with lots of radical alternatives. A winner will
eventually emerge and it will probably look quite a bit different than
Reno.

Similar things have gone on since the beginning with filesystems on
Linux. Being able to easily compare filesystems head to head has been
immensely valuable in improving our 'core' Linux filesystems.

And what we've had up to now is a scheduler monoculture. Until Andrew
put RSDL in -mm, if people wanted to experiment with other schedulers,
they had to go well off the beaten path to do it. So all the people
who've been hopelessy frustrated with the mainline scheduler go off to
the -ck ghetto, or worse, stick with 2.4.

Whether your motivations have been protectionist or merely
shortsighted, you've stomped pretty heavily on alternative scheduler
development by completely rejecting the whole plugsched concept. If
we'd opened up mainline to a variety of schedulers _3 years ago_, we'd
probably have gotten to where we are today much sooner.

Hopefully, the next time Rik suggests pluggable page replacement
algorithms, folks will actually seriously consider it.

-- 
Mathematics is the supreme nostalgia of our time.
