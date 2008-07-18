Return-Path: <linux-kernel-owner+w=401wt.eu-S1756418AbYGRLsN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418AbYGRLsN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 07:48:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751314AbYGRLr7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 07:47:59 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38918 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbYGRLr6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 07:47:58 -0400
Date: Fri, 18 Jul 2008 13:47:44 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: 4d3702b6 (post-v2.6.26): WARNING: at kernel/lockdep.c:2731
	check_flags (ftrace)
Message-ID: <20080718114744.GF6875@elte.hu>
References: <19f34abd0807151855k22dc80d5tf3629da2e52ee6de@mail.gmail.com> <Pine.LNX.4.58.0807160010490.25043@gandalf.stny.rr.com> <19f34abd0807160232u635891fai2450f29e71c801b6@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0807160232u635891fai2450f29e71c801b6@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Vegard Nossum <vegard.nossum@gmail.com> wrote:

> On Wed, Jul 16, 2008 at 6:13 AM, Steven Rostedt <rostedt@goodmis.org> wrote:
> > Things get weird between lockdep and ftrace because ftrace can be called
> > within lockdep internal code (via the mcount pointer) and lockdep can be
> > called with ftrace (via spin_locks).
> >
> > Can you try this patch out and see if it fixes your problem. I only
> > compiled tested it.
> >
> > Note: I'll be traveling for the next couple of weeks, so I will be on and
> > off with email.
> >
> > Signed-off-by: Steven Rostedt <srostedt@redhat.com>
> > ---
> >  kernel/trace/trace_sched_wakeup.c |   27 ++++++++++++++++-----------
> >  1 file changed, 16 insertions(+), 11 deletions(-)
> 
> Works for me! :-)
> 
> There's no warning during self-tests. But then again, I didn't try 
> tracing anything else either.

applied to tip/tracing/urgent - thanks!

	Ingo
