Return-Path: <linux-kernel-owner+w=401wt.eu-S1759899AbYGKN6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759899AbYGKN6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 09:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760035AbYGKNvR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 09:51:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:60792 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760653AbYGKNvP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 09:51:15 -0400
Date: Fri, 11 Jul 2008 15:50:57 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] ftrace: updates
Message-ID: <20080711135057.GC32159@elte.hu>
References: <20080711005808.316194101@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080711005808.316194101@goodmis.org>
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

> Working on the ftrace.txt file proved to show some bugs with ftrace. 
> These are a list of patches that I have accumulated for ftrace that 
> solve those bugs (as well as other things).

applied them to tip/tracing/ftrace:

 Steven Rostedt (8):
      ftrace: move sched_switch enable after markers
      ftrace: define function trace nop
      ftrace: trace schedule
      ftrace: check proper config for preempt type
      ftrace: start wakeup tracing after setting function tracer
      ftrace: use current CPU for function startup
      ftrace: add ftrace_kill_atomic
      ftrace: separate out the function enabled variable

thanks Steven!

	Ingo
