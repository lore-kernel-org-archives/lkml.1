Return-Path: <linux-kernel-owner+w=401wt.eu-S1758708AbYGRQ6U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758708AbYGRQ6U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 12:58:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755799AbYGRQ6N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 12:58:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:45342 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752421AbYGRQ6M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 12:58:12 -0400
Date: Fri, 18 Jul 2008 18:57:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] ftrace: only trace preempt off with preempt tracer
Message-ID: <20080718165755.GG6875@elte.hu>
References: <Pine.LNX.4.58.0807150952080.8218@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0807150952080.8218@gandalf.stny.rr.com>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> When PREEMPT_TRACER and IRQSOFF_TRACER are both configured and irqsoff 
> tracer is running, the preempt_off sections might also be traced.
> 
> Thanks to Andrew Morton for pointing out my mistake of spin_lock 
> disabling interrupts while he was reviewing ftrace.txt. Seems that my 
> example I used actually hit this bug.

applied to tip/tracing/urgent - thanks Steve.

	Ingo
