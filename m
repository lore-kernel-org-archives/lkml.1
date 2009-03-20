Return-Path: <linux-kernel-owner+w=401wt.eu-S1757356AbZCTJPh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356AbZCTJPh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 05:15:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbZCTJP1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 05:15:27 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32994 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754210AbZCTJP1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 05:15:27 -0400
Date: Fri, 20 Mar 2009 10:15:17 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [PATCH 0/7] [GIT PULL] tip/tracing/ftrace
Message-ID: <20090320091517.GD16021@elte.hu>
References: <20090319200122.512803803@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090319200122.512803803@goodmis.org>
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
> Lai Jiangshan (1):
>       ftrace: protect running nmi (V3)
> 
> Steven Rostedt (6):
>       tracing: give easy way to clear trace buffer
>       function-graph: consolidate prologues for output
>       tracing: make print_(b)printk_msg_only global
>       function-graph: calculate function depth within function graph tracer
>       tracing: remove recording function depth from trace_printk
>       function-graph: show binary events as comments
> 
> ----
>  arch/x86/kernel/ftrace.c             |   63 ++++++----
>  kernel/trace/trace.c                 |   85 ++++++-------
>  kernel/trace/trace.h                 |    6 +-
>  kernel/trace/trace_event_types.h     |    2 -
>  kernel/trace/trace_functions_graph.c |  219 +++++++++++++++++++---------------
>  kernel/trace/trace_mmiotrace.c       |    2 +-
>  kernel/trace/trace_output.c          |   32 +++++
>  kernel/trace/trace_output.h          |    5 +
>  kernel/trace/trace_printk.c          |    8 +-
>  9 files changed, 243 insertions(+), 179 deletions(-)

Pulled, thanks Steve!

	Ingo
