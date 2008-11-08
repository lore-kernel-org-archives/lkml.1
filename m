Return-Path: <linux-kernel-owner+w=401wt.eu-S1754074AbYKHImw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074AbYKHImw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2008 03:42:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752617AbYKHImp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 8 Nov 2008 03:42:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:42289 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbYKHImp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2008 03:42:45 -0500
Date: Sat, 8 Nov 2008 09:42:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 00/10] ftrace: various updates
Message-ID: <20081108084226.GA18215@elte.hu>
References: <20081108034605.289816911@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081108034605.289816911@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00,DNS_FROM_SECURITYSAGE autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
	0.0 DNS_FROM_SECURITYSAGE  RBL: Envelope sender in
	blackholes.securitysage.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Matt Fleming (1):
>       ftrace: Align __mcount_loc sections
> 
> Steven Rostedt (9):
>       ftrace: fix set_ftrace_filter
>       ftrace: fix boot trace sched startup
>       ftrace: fix sched_switch API
>       ftrace: irqsoff tracer incorrect reset
>       ftrace: enable trace_printk by default
>       ftrace: remove ctrl_update method
>       ftrace: remove trace array ctrl
>       ftrace: force pass of preemptoff selftest
>       ftrace: display start of CPU buffer in trace output
> 
> ----
>  kernel/trace/ftrace.c             |    3 +
>  kernel/trace/trace.c              |   43 +++++++++++--------
>  kernel/trace/trace.h              |    8 ++-
>  kernel/trace/trace_boot.c         |   22 ++++------
>  kernel/trace/trace_functions.c    |   15 +------
>  kernel/trace/trace_irqsoff.c      |   19 +--------
>  kernel/trace/trace_mmiotrace.c    |   22 ++++------
>  kernel/trace/trace_nop.c          |   16 +------
>  kernel/trace/trace_sched_switch.c |   77 ++++++++++++++++++++++++----------
>  kernel/trace/trace_sched_wakeup.c |   21 ++--------
>  kernel/trace/trace_selftest.c     |   82 +++++++++++++++++++++++-------------
>  kernel/trace/trace_sysprof.c      |   16 +------
>  scripts/recordmcount.pl           |    4 ++
>  13 files changed, 172 insertions(+), 176 deletions(-)

pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
