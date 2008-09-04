Return-Path: <linux-kernel-owner+w=401wt.eu-S1757766AbYIDKQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757766AbYIDKQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 06:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752377AbYIDKQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 06:16:26 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751961AbYIDKQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 06:16:25 -0400
Date: Thu, 4 Sep 2008 12:16:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] ftrace: sched_switch: show the wakee's cpu
Message-ID: <20080904101602.GC25428@elte.hu>
References: <20080903214249.661170580@goodmis.org> <1220516656.8609.201.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1220516656.8609.201.camel@twins>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> Subject: ftrace: sched_switch: show the wakee's cpu
> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date: Tue Sep 02 21:12:13 CEST 2008
> 
> While profiling the smp behaviour of the scheduler it was needed to 
> know to which cpu a task got woken.

applied this and the other patches in this thread to tip/tracing/ftrace:

 0d32728: ftrace: sched_switch: show the wakee's cpu
 33fbc35: ftrace: make ftrace_printk usable with the other tracers
 32b6a7b: ftrace: print continue index fix
 3340e7e: ftrace: binary and not logical for continue test

thanks!

	Ingo
