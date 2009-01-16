Return-Path: <linux-kernel-owner+w=401wt.eu-S1764377AbZAPLZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764377AbZAPLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2009 06:25:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754217AbZAPLZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Jan 2009 06:25:14 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:60506 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752840AbZAPLZN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2009 06:25:13 -0500
Date: Fri, 16 Jan 2009 12:25:05 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/6] ftrace: more updates to tip
Message-ID: <20090116112505.GD20082@elte.hu>
References: <20090116045342.748642160@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090116045342.748642160@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0047]
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
> Steven Rostedt (6):
>       ftrace: move function tracer functions out of trace.c
>       trace: add gcc printf check to trace_seq_printf
>       trace: clean up format errors in calls to trace_seq_printf
>       ftrace: combine stack trace in function call
>       ftrace: remove static from function tracer functions
>       trace: set max latency variable to zero on default
> 
> ----
>  kernel/trace/kmemtrace.c          |    4 +-
>  kernel/trace/trace.c              |   89 +----------------------------
>  kernel/trace/trace.h              |   10 ---
>  kernel/trace/trace_functions.c    |  115 ++++++++++++++++++++++++++++++++++---
>  kernel/trace/trace_irqsoff.c      |    1 +
>  kernel/trace/trace_mmiotrace.c    |   13 ++--
>  kernel/trace/trace_output.c       |    2 +-
>  kernel/trace/trace_output.h       |    3 +-
>  kernel/trace/trace_sched_wakeup.c |    1 +
>  9 files changed, 122 insertions(+), 116 deletions(-)

Pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
