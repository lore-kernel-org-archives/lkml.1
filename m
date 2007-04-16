Return-Path: <linux-kernel-owner+w=401wt.eu-S932185AbXDPGRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932185AbXDPGRv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2007 02:17:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932184AbXDPGRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Apr 2007 02:17:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35954 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932179AbXDPGRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2007 02:17:50 -0400
Date: Mon, 16 Apr 2007 08:17:28 +0200
From: Nick Piggin <npiggin@suse.de>
To: Bill Huey <billh@gnuppy.monkey.org>
Cc: Arjan van de Ven <arjan@infradead.org>, Mike Galbraith <efault@gmx.de>,
       Con Kolivas <kernel@kolivas.org>, Ingo Molnar <mingo@elte.hu>,
       ck list <ck@vds.kolivas.org>, Peter Williams <pwil3058@bigpond.net.au>,
       linux-kernel@vger.kernel.org,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [Announce] [patch] Modular Scheduler Core and Completely Fair Scheduler [CFS]
Message-ID: <20070416061728.GB2659@wotan.suse.de>
References: <20070413202100.GA9957@elte.hu> <200704151327.13589.kernel@kolivas.org> <1176619384.6222.70.camel@Homer.simpson.net> <20070415083616.GA29878@gnuppy.monkey.org> <1176654307.3945.50.camel@laptopd505.fenrus.org> <20070416053629.GA6337@gnuppy.monkey.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070416053629.GA6337@gnuppy.monkey.org>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 15, 2007 at 10:36:29PM -0700, Bill Huey wrote:
> On Sun, Apr 15, 2007 at 09:25:07AM -0700, Arjan van de Ven wrote:
> > Now this doesn't mean that people shouldn't be nice to each other, not
> > cooperate or steal credits, but I don't get the impression that that is
> > happening here. Ingo is taking part in the discussion with a counter
> > proposal for discussion *on the mailing list*. What more do you want??
> 
> Con should have been CCed from the first moment this was put into motion
> to limit the perception of exclusion. That was mistake number one and big
> time failures to understand this dynamic. After it was Con's idea. Why
> the hell he was excluded from Ingo's development process is baffling to
> me and him (most likely).

Ingo's scheduler is completely different to any I've seen proposed
for Linux. And after he did an initial implementation, he did post
it to everyone.

Maybe something he said offended someone, but the process followed
is exactly how Linux kernel development works (ie. if you think you
can do better, then write the code). Sometimes you can give suggestions,
but other times if you come up with a different idea then it is
better just to do it yourself.

Con's code is still out there. If it is better than Ingo's then it
should win out. Nobody has a monopoly on schedulers or ideas or
posting patches.


> He put int a lot of effort into SDL and his experiences with scheduling
> should still be seriously considered in this development process even if
> he doesn't write a single line of code from this moment on.
> 
> What should have happened is that our very busy associate at RH by the
> name of Ingo Molnar should have leverage more of Con's and Bill's work
> and use them as a proxy for his own ideas. They would have loved to have
> contributed more and our very busy Ingo Molnar would have gotten a lot
> of his work and ideas implemented without him even opening a single
> source file for editting. They would have happily done this work for
> Ingo. Ingo could have been used for something else more important like
> making KVM less of a freaking ugly hack and we all would have benefitted
> from this.
> 
> He could have been working on SystemTap so that you stop losing accounts
> to Sun and Solaris 10's Dtrace. He could have been working with Riel to
> fix your butt ugly page scanning problem causing horrible contention via
> the Clock/Pro algorithm, etc... He could have been fixing the ugly futex
> rwsem mapping problem that's killing -rt and anything that uses Posix
> threads. He could have created a userspace thread control block (TCB)
> with Mr. Drepper so that we can turn off preemption in userspace
> (userspace per CPU local storage) and implement a very quick non-kernel
> crossing implementation of priority ceilings (userspace check for priority
> and flags at preempt_schedule() in the TCB) so that our -rt Posix API
> doesn't suck donkey shit... Need I say more ?

Well that's some pretty strong criticism of Linux and of someone who
does a great deal to improve things... Let's stick to the topic of
schedulers in this thread and try keeping it constructive.

