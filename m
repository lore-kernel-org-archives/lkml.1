Return-Path: <linux-kernel-owner+w=401wt.eu-S1756648AbZCJV4W@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756648AbZCJV4W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Mar 2009 17:56:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755365AbZCJV4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Mar 2009 17:56:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33033 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755270AbZCJV4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Mar 2009 17:56:11 -0400
Date: Tue, 10 Mar 2009 22:55:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Mathieu Desnoyers <compudj@krystal.dyndns.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Martin J. Bligh" <mbligh@mbligh.org>,
       "Frank Ch. Eigler" <fche@redhat.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Larry Woodman <lwoodman@redhat.com>, Jason Baron <jbaron@redhat.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Masami Hiramatsu <mhiramat@redhat.com>,
       Christoph Hellwig <hch@infradead.org>,
       Jiaying Zhang <jiayingz@google.com>
Subject: Re: [PATCH 0/7] [GIT PULL] clean ups to tip/tracing/ftrace
Message-ID: <20090310215518.GB21085@elte.hu>
References: <20090310210408.419131392@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090310210408.419131392@goodmis.org>
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
> Steven Rostedt (7):
>       tracing: fix printk format specifier
>       tracing: do not allow modifying the ftrace events via the event files
>       tracing: add back the available_events file
>       tracing: flip the TP_printk and TP_fast_assign in the TRACE_EVENT macro
>       tracing: document TRACE_EVENT macro in tracepoint.h
>       tracing: update comments to match event code macros
>       tracing: remove funky whitespace in the trace code
> 
> ----
>  include/linux/tracepoint.h           |  105 +++++++++++++++++++++++++++++++++-
>  include/trace/irq_event_types.h      |    8 +-
>  include/trace/sched_event_types.h    |  102 ++++++++++++++++----------------
>  kernel/trace/blktrace.c              |   10 ++--
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace_branch.c          |    2 +-
>  kernel/trace/trace_events.c          |   45 +++++++++++---
>  kernel/trace/trace_events_stage_1.h  |    8 ++-
>  kernel/trace/trace_events_stage_2.h  |   13 ++--
>  kernel/trace/trace_events_stage_3.h  |   98 ++++++++++++++++----------------
>  kernel/trace/trace_export.c          |    2 +-
>  kernel/trace/trace_functions_graph.c |    6 +-
>  kernel/trace/trace_output.c          |   14 ++--
>  kernel/trace/trace_workqueue.c       |    6 +-
>  14 files changed, 275 insertions(+), 146 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
