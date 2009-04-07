Return-Path: <linux-kernel-owner+w=401wt.eu-S1753584AbZDGL40@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbZDGL40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 07:56:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751290AbZDGL4R
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 07:56:17 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42337 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751287AbZDGL4Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 07:56:16 -0400
Date: Tue, 7 Apr 2009 13:56:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/10] [GIT PULL] for tip/tracing/core
Message-ID: <20090407115603.GB11641@elte.hu>
References: <20090406163706.097842409@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090406163706.097842409@goodmis.org>
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

> Ingo,
> 
> These are the same patches I sent out earlier, but I rebased them 
> to tip/tracing/core. I also changed my S-o-B to be 
> rostedt@goodmis.org since I prefer email going to that address 
> instead.
> 
> -- Steve
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Frederic Weisbecker (2):
>       tracing/ftrace: fix missing include string.h
>       tracing/ftrace: factorize the tracing files creation
> 
> Huang Weiyi (1):
>       tracing, x86: remove duplicated #include
> 
> Lai Jiangshan (1):
>       tracing: fix incorrect return type of ns2usecs() V2
> 
> Li Zefan (1):
>       tracing: use macros to denote usec and nsec per second
> 
> Steven Rostedt (3):
>       tracing: remove CALLER_ADDR2 from wakeup tracer
>       function-graph: add proper initialization for init task
>       function-graph: use int instead of atomic for ftrace_graph_active
> 
> Zhaolei (2):
>       ftrace: Add check of sched_stopped for probe_sched_wakeup
>       ftrace: Clean up enable logic for sched_switch
> 
> ----
>  arch/x86/kernel/ftrace.c           |    1 -
>  include/linux/ftrace.h             |    8 ++-
>  include/linux/init_task.h          |    2 +
>  kernel/trace/ftrace.c              |   53 ++++--------
>  kernel/trace/ring_buffer.c         |    7 +-
>  kernel/trace/trace.c               |  163 ++++++++++++++----------------------
>  kernel/trace/trace.h               |    8 ++-
>  kernel/trace/trace_boot.c          |    5 +-
>  kernel/trace/trace_event_profile.c |    3 +-
>  kernel/trace/trace_mmiotrace.c     |    6 +-
>  kernel/trace/trace_output.c        |    2 +-
>  kernel/trace/trace_printk.c        |    6 +-
>  kernel/trace/trace_sched_switch.c  |   11 ++-
>  kernel/trace/trace_sched_wakeup.c  |    8 ++-
>  kernel/trace/trace_stack.c         |   13 +--
>  kernel/trace/trace_sysprof.c       |    6 +-
>  16 files changed, 128 insertions(+), 174 deletions(-)

Pulled, thanks Steve!

	Ingo
