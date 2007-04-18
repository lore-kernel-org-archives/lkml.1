Return-Path: <linux-kernel-owner+w=401wt.eu-S932664AbXDRHJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932664AbXDRHJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2007 03:09:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932753AbXDRHJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Apr 2007 03:09:46 -0400
Received: from waste.org ([66.93.16.53]:53483 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932664AbXDRHJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2007 03:09:46 -0400
Date: Wed, 18 Apr 2007 01:55:34 -0500
From: Matt Mackall <mpm@selenic.com>
To: Nick Piggin <npiggin@suse.de>
Cc: William Lee Irwin III <wli@holomorphy.com>,
       Peter Williams <pwil3058@bigpond.net.au>,
       Mike Galbraith <efault@gmx.de>, Con Kolivas <kernel@kolivas.org>,
       Ingo Molnar <mingo@elte.hu>, ck list <ck@vds.kolivas.org>,
       Bill Huey <billh@gnuppy.monkey.org>, linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070418065534.GT11115@waste.org>
References: <20070417060955.GO8915@holomorphy.com> <20070417061503.GC1057@wotan.suse.de> <20070417062621.GL2986@holomorphy.com> <20070417070155.GF1057@wotan.suse.de> <20070417213954.GE11166@waste.org> <20070418031511.GA18452@wotan.suse.de> <20070418043831.GR11115@waste.org> <20070418050024.GF18452@wotan.suse.de> <20070418055525.GS11115@waste.org> <20070418063711.GH18452@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070418063711.GH18452@wotan.suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2007 at 08:37:11AM +0200, Nick Piggin wrote:
> I don't know how that supports your argument for unfairness,

I never had such an argument. I like fairness.

My argument is that -you- don't have an argument for making fairness a
-requirement-.

> processes are special only because that's how we've always done
> scheduling.  I'm not precluding other groupings for fairness, though.

If you make one form of fairness a -requirement- for all acceptable
algorithms, your -are- precluding most other forms of fairness.

If you refuse to define what "fairness" means when specifying your
requirement, what's the point of requiring it?

> What do you mean optimal? If your criteria is fairness, then of course
> it is optimal. If your criteria is throughput, then it probably isn't.

I don't know what optimal behavior is. And neither do you. It may or
may not be fair. It very likely includes small deviations from fair.

> > [2] It's trivial to construct two or more perfectly reasonable and
> > desirable definitions of fairness that are mutually incompatible.
> 
> Probably not if you use common sense, and in the context of a replacement
> for the 2.6 scheduler.

Ok, trivial example. You cannot allocate equal CPU time to
processes/tasks and simultaneously allocate equal time to thread
groups. Is it common sense that a heavily-threaded app should be able
to get hugely more CPU than a well-written app? No. I don't want Joe's
stupid Java app to make my compile crawl.

On the other hand, if my heavily threaded app is, say, a voicemail
server serving 30 customers, I probably want it to get 30x the CPU of
my gzip job.

-- 
Mathematics is the supreme nostalgia of our time.
