Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZCEJW4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZCEJW4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 04:22:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752357AbZCEJWi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 04:22:38 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:34820 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750976AbZCEJWi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 04:22:38 -0500
Date: Thu, 5 Mar 2009 10:22:23 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Theodore Tso <tytso@mit.edu>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/7] [GIT PULL] for tip/tracing/ftrace
Message-ID: <20090305092223.GC16026@elte.hu>
References: <20090305032532.802709985@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090305032532.802709985@goodmis.org>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace
> 
> 
> Steven Rostedt (7):
>       ring-buffer: fix timestamp in partial ring_buffer_page_read
>       tracing: do not return EFAULT if read copied anything
>       tracing: fix seq read from trace files
>       tracing: add latency output format option
>       tracing: remove extra latency_trace method from trace structure
>       tracing: consolidate print_lat_fmt and print_trace_fmt
>       tracing: have latency tracers set the latency format
> 
> ----
>  kernel/trace/blktrace.c           |    1 -
>  kernel/trace/ring_buffer.c        |    6 ++-
>  kernel/trace/trace.c              |   81 ++++++++++--------------------------
>  kernel/trace/trace.h              |    3 +-
>  kernel/trace/trace_branch.c       |    1 -
>  kernel/trace/trace_irqsoff.c      |    8 ++++
>  kernel/trace/trace_output.c       |   32 --------------
>  kernel/trace/trace_output.h       |    1 -
>  kernel/trace/trace_sched_wakeup.c |    8 ++++
>  9 files changed, 46 insertions(+), 95 deletions(-)

Pulled, thanks Steve!

	Ingo
