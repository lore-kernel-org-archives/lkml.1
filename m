Return-Path: <linux-kernel-owner+w=401wt.eu-S1752694AbXDOI6g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694AbXDOI6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2007 04:58:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752424AbXDOI6g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Apr 2007 04:58:36 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:47630 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463AbXDOI6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2007 04:58:35 -0400
Date: Sun, 15 Apr 2007 10:58:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Mike Galbraith <efault@gmx.de>
Cc: Willy Tarreau <w@1wt.eu>, Nick Piggin <npiggin@suse.de>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Con Kolivas <kernel@kolivas.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070415085825.GE24886@elte.hu>
References: <20070413202100.GA9957@elte.hu> <20070414020424.GB14544@wotan.suse.de> <20070414063254.GB14875@elte.hu> <20070414064334.GA19463@elte.hu> <20070414080833.GL943@1wt.eu> <20070414083625.GM943@1wt.eu> <20070414105338.GB19454@elte.hu> <20070414130101.GA2538@1wt.eu> <1176623688.30350.23.camel@Homer.simpson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1176623688.30350.23.camel@Homer.simpson.net>
User-Agent: Mutt/1.4.2.2i
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.0.3
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


* Mike Galbraith <efault@gmx.de> wrote:

> On Sat, 2007-04-14 at 15:01 +0200, Willy Tarreau wrote:
> 
> > Well, I'll stop heating the room for now as I get out of ideas about 
> > how to defeat it. I'm convinced. I'm impatient to read about Mike's 
> > feedback with his workload which behaves strangely on RSDL. If it 
> > works OK here, it will be the proof that heuristics should not be 
> > needed.
> 
> You mean the X + mp3 player + audio visualization test?  X+Gforce 
> visualization have problems getting half of my box in the presence of 
> two other heavy cpu using tasks.  Behavior is _much_ better than 
> RSDL/SD, but the synchronous nature of X/client seems to be a problem.
> 
> With this scheduler, renicing X/client does cure it, whereas with SD 
> it did not help one bit. [...]

thanks for testing it! I was quite worried about your setup - two tasks 
using up 50%/50% of CPU time, pitted against a kernel rebuild workload 
seems to be a hard workload to get right.

> [...] (I know a trivial way to cure that, and this framework makes 
> that possible without dorking up fairness as a general policy.)

great! Please send patches so i can add them (once you are happy with 
the solution) - i think your workload isnt special in any way and could 
hit other people too.

	Ingo
