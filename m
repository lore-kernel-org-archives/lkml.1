Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935552Ab0BZIVc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 03:21:32 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54980 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935522Ab0BZIVb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 03:21:31 -0500
Date: Fri, 26 Feb 2010 09:21:18 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7][GIT PULL] tracing: updates
Message-ID: <20100226082118.GB15885@elte.hu>
References: <20100225194355.707261669@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100225194355.707261669@goodmis.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Jeff Mahoney (1):
>       tracing: Fix ftrace_event_call alignment for use with gcc 4.5
> 
> Li Zefan (1):
>       tracing: Remove CONFIG_TRACE_POWER from kernel config
> 
> Steven Rostedt (1):
>       ftrace: Remove memory barriers from NMI code when not needed
> 
> Wenji Huang (4):
>       tracing: Fix typo in prof_sysexit_enable()
>       tracing: Fix typo of info text in trace_kprobe.c
>       tracing: Remove unnecessary variable in print_graph_return
>       tracing: Simplify memory recycle of trace_define_field
> 
> ----
>  arch/x86/kernel/ftrace.c             |   26 ++++++++++++++++++++++++++
>  include/linux/syscalls.h             |    6 ++++--
>  include/trace/ftrace.h               |    3 ++-
>  kernel/trace/Kconfig                 |    9 ---------
>  kernel/trace/trace.h                 |    3 ++-
>  kernel/trace/trace_events.c          |    4 +---
>  kernel/trace/trace_functions_graph.c |    1 -
>  kernel/trace/trace_kprobe.c          |    4 ++--
>  kernel/trace/trace_syscalls.c        |    2 +-
>  9 files changed, 38 insertions(+), 20 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
