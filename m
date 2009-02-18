Return-Path: <linux-kernel-owner+w=401wt.eu-S1755292AbZBRAKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292AbZBRAKh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Feb 2009 19:10:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752093AbZBRAK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Feb 2009 19:10:29 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:41244 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751756AbZBRAK2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Feb 2009 19:10:28 -0500
Date: Wed, 18 Feb 2009 01:09:52 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <peterz@infradead.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>
Subject: Re: [PATCH 0/6] [git pull] updates for tip/tracing/ftrace
Message-ID: <20090218000952.GD12714@elte.hu>
References: <20090217182048.233060814@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090217182048.233060814@goodmis.org>
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
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (3):
>       ftrace: clean up coding style
>       ftrace: rename _hook to _probe
>       ftrace: show unlimited when traceon or traceoff has no counter
> 
> Wenji Huang (3):
>       tracing: use the more proper parameter
>       tracing: fix the return value of trace selftest
>       tracing: fix typing mistake in hint message and comments
> 
> ----
>  include/linux/ftrace.h            |   12 ++--
>  kernel/trace/ftrace.c             |  102 +++++++++++++++++++------------------
>  kernel/trace/trace.c              |    2 +-
>  kernel/trace/trace_functions.c    |   31 ++++++-----
>  kernel/trace/trace_irqsoff.c      |    2 +-
>  kernel/trace/trace_sched_switch.c |    2 +-
>  kernel/trace/trace_sched_wakeup.c |    2 +-
>  kernel/trace/trace_selftest.c     |   16 +++++-
>  kernel/trace/trace_stat.c         |    2 +-
>  kernel/trace/trace_sysprof.c      |    2 +-
>  10 files changed, 93 insertions(+), 80 deletions(-)

Pulled into tip:tracing/ftrace, thanks Steve!

	Ingo
