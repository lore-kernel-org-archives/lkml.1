Return-Path: <linux-kernel-owner+w=401wt.eu-S1757813AbZCMDf6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813AbZCMDf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 23:35:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752785AbZCMDfu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 23:35:50 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35358 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643AbZCMDft (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 23:35:49 -0400
Date: Fri, 13 Mar 2009 04:35:32 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: [PATCH 00/16] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090313033532.GC11355@elte.hu>
References: <20090313023704.971438367@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090313023704.971438367@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Frederic Weisbecker (1):
>       tracing/core: bring back raw trace_printk for dynamic formats strings
> 
> Jason Baron (2):
>       tracing: tracepoints for softirq entry/exit - add softirq-to-name array
>       tracing: tracepoints for softirq entry/exit - tracepoints
> 
> KOSAKI Motohiro (1):
>       tracing: Don't use tracing_record_cmdline() in workqueue tracer fix
> 
> Steven Rostedt (12):
>       tracing: fix comments about trace buffer resizing
>       tracing: protect ring_buffer_expanded with trace_types_lock
>       ring-buffer: use CONFIG_HOTPLUG_CPU not CONFIG_HOTPLUG
>       ring-buffer: remove unneeded get_online_cpus
>       tracing: show that buffer size is not expanded
>       tracing: make bprint event use the proper event id
>       tracing: have event_trace_printk use static tracer
>       tracing: export trace formats to user space
>       tracing: fix stack tracer header
>       tracing: explain why stack tracer is empty
>       tracing: show event name in trace for TRACE_EVENT created events
>       ring-buffer: document reader page design
> 
> ----
>  include/linux/interrupt.h            |    5 +
>  include/linux/kernel.h               |   40 ++++++---
>  include/trace/irq_event_types.h      |   12 +++
>  kernel/softirq.c                     |   16 +++-
>  kernel/trace/ring_buffer.c           |  168 +++++++++++++++++----------------
>  kernel/trace/trace.c                 |  121 ++++++++++++++++++++++--
>  kernel/trace/trace.h                 |   30 ++++++-
>  kernel/trace/trace_event_types.h     |   11 ++-
>  kernel/trace/trace_events.c          |   10 --
>  kernel/trace/trace_events_stage_2.h  |    2 +-
>  kernel/trace/trace_functions_graph.c |    6 +-
>  kernel/trace/trace_mmiotrace.c       |    7 +-
>  kernel/trace/trace_output.c          |   57 ++++++++++-
>  kernel/trace/trace_printk.c          |  150 ++++++++++++++++++++++++++++--
>  kernel/trace/trace_stack.c           |   19 ++++-
>  kernel/trace/trace_workqueue.c       |   20 +++-
>  16 files changed, 523 insertions(+), 151 deletions(-)

Pulled, thanks Steve!

	Ingo
