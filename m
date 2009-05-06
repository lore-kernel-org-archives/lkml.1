Return-Path: <linux-kernel-owner+w=401wt.eu-S1757490AbZEFI3K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490AbZEFI3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 04:29:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752259AbZEFI2y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 04:28:54 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37537 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751619AbZEFI2x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 04:28:53 -0400
Date: Wed, 6 May 2009 10:28:34 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/11] [GIT PULL] tracing/ring-buffer: various updates
Message-ID: <20090506082834.GC28675@elte.hu>
References: <20090506042101.231470089@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090506042101.231470089@goodmis.org>
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
> I rebased again (using ftrace-2 now) and made some minor clean
> ups to the patches, as well as added several new ones.
> 
> The last patch of the series adds a benchmark/tester for the 
> ring buffer. It creates a producer and consumer and measures the time
> and number of entries recorded. It prints out the results via
> pr_info every 10 seconds.
> 
> Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-2
> 
> 
> Steven Rostedt (10):
>       ring-buffer: export symbols
>       ring-buffer: add counters for commit overrun and nmi dropped entries
>       tracing: export stats of ring buffers to userspace
>       ring-buffer: convert cpu buffer entries to local_t
>       ring-buffer: record page entries in buffer page descriptor
>       ring-buffer: have read page swap increment counter with page entries
>       ring-buffer: disable writers when resetting buffers
>       tracing: use proper export symbol for tracing api
>       ring-buffer: move big if statement down
>       ring-buffer: add benchmark and tester
> 
> Tim Abbott (1):
>       ftrace: use .sched.text, not .text.sched in recordmcount.pl
> 
> ----
>  include/linux/ring_buffer.h          |    2 +
>  kernel/trace/Kconfig                 |   16 ++
>  kernel/trace/Makefile                |    1 +
>  kernel/trace/ring_buffer.c           |  339 ++++++++++++++++--------------
>  kernel/trace/ring_buffer_benchmark.c |  379 ++++++++++++++++++++++++++++++++++
>  kernel/trace/trace.c                 |   48 ++++-
>  scripts/recordmcount.pl              |    6 +-
>  7 files changed, 628 insertions(+), 163 deletions(-)

Pulled, thanks Steve!

	Ingo
