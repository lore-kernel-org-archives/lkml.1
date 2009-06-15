Return-Path: <linux-kernel-owner+w=401wt.eu-S1758261AbZFOP4h@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758261AbZFOP4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 11:56:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755081AbZFOP43
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 11:56:29 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:34955 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336AbZFOP42 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 11:56:28 -0400
Date: Mon, 15 Jun 2009 17:56:24 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] [GIT PULL] updates for 2.6.31
Message-ID: <20090615155624.GB19529@elte.hu>
References: <20090615154226.058101204@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615154226.058101204@goodmis.org>
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


* Steven Rostedt <rostedt@goodmis.org> wrote:

> Hi Ingo,
> 
> This patch series are fixes that should get into 2.6.31 (maybe some of
> them even into stable?).
> 
> Please pull the latest tracing/ftrace tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tracing/ftrace
> 
> 
> Li Zefan (4):
>       tracing: fix a typo in tracing_cpumask_write()
>       tracing: replace a GFP_ATOMIC with GFP_KERNEL allocation
>       tracing/filters: operand can be negative
>       tracing/filters: strloc should be unsigned short
> 
> Rusty Russell (1):
>       cpumask: use new operators in kernel/trace
> 
> Steven Rostedt (1):
>       ring-buffer: prevent adding write in discarded area
> 
> Wu Zhangjin (1):
>       tracing: fix undeclared 'PAGE_SIZE' in include/linux/trace_seq.h
> 
> ----
>  include/linux/trace_seq.h          |    2 +
>  kernel/trace/kmemtrace.c           |    2 +-
>  kernel/trace/ring_buffer.c         |   72 +++++++++++++++++++++++++++++-------
>  kernel/trace/trace.c               |    8 ++--
>  kernel/trace/trace_events_filter.c |    9 +++-
>  5 files changed, 72 insertions(+), 21 deletions(-)

Pulled into tracing/urgent - thanks Steve!

	Ingo
