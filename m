Return-Path: <linux-kernel-owner+w=401wt.eu-S1753478AbZHBTec@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478AbZHBTec (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Aug 2009 15:34:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753394AbZHBTeb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Aug 2009 15:34:31 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46654 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753392AbZHBTeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Aug 2009 15:34:31 -0400
Date: Sun, 2 Aug 2009 21:34:17 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing: Various cleanups for 2.6.32
Message-ID: <20090802193416.GA24486@elte.hu>
References: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248887609-5147-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
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


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> Hi Thomas, Ingo,
> 
> These patches are the result of various cleanups in the tracing
> subsystem: algorithms simpifications, and various trace.c to tracer
> files moving.
> 
> Thanks,
> Frederic.
> 
> The following changes since commit d34a4debef933061924ee17c2ede33f5c44925fb:
>   jolsa@redhat.com (1):
>         tracing: Remove .globl in the scripts/recordmcount.pl doc
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core
> 
> Frederic Weisbecker (5):
>       tracing/function-graph-tracer: Drop the useless nmi protection
>       tracing/function-tracer: Move trace_function() in the function tracer file
>       tracing/core: Make the stack entry helpers global
>       tracing: Move sched event insertion helpers in the sched switch tracer file
>       tracing/function-graph-tracer: Move graph event insertion helpers in the graph tracer file
> 
> Lai Jiangshan (1):
>       tracing: Simplify print_graph_cpu()
> 
>  arch/x86/kernel/ftrace.c             |    4 -
>  kernel/trace/trace.c                 |  217 ++--------------------------------
>  kernel/trace/trace.h                 |   30 ++++-
>  kernel/trace/trace_functions.c       |   25 ++++
>  kernel/trace/trace_functions_graph.c |  152 +++++++++++++++++++-----
>  kernel/trace/trace_sched_switch.c    |   57 +++++++++
>  kernel/trace/trace_selftest.c        |    1 +
>  7 files changed, 242 insertions(+), 244 deletions(-)

Pulled into tip:tracing/core, thanks a lot!

	Ingo
