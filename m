Return-Path: <linux-kernel-owner+w=401wt.eu-S1756186AbZFXJEQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756186AbZFXJEQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jun 2009 05:04:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752320AbZFXJEE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Jun 2009 05:04:04 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:40521 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853AbZFXJED (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jun 2009 05:04:03 -0400
Date: Wed, 24 Jun 2009 11:03:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Liming Wang <liming.wang@windriver.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/7] tracing: seqfile fixes, take 2
Message-ID: <20090624090358.GA25212@elte.hu>
References: <4A4186C6.9090706@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4186C6.9090706@cn.fujitsu.com>
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


* Li Zefan <lizf@cn.fujitsu.com> wrote:

> While testing syscall tracepoints proposed by Jason, I found some
> entries were missing when reading available_events.
> 
> It turned out there's bug in seqfile handling. The bug is, it's
> wrong to increment @pos in seq start().
> 
> The bug exists in some other places. I also fixed some other different
> bugs.
> 
> All the patches have been reviewed and tested.
> 
> Thanks Liming Wang for the review.
> 
> [PATCH 1/7] tracing/events: don't increment @pos in s_start()
> [PATCH 2/7] tracing_bprintk: don't increment @pos in t_start()
> [PATCH 3/7] trace_stat: don't increment @pos in seq start()
> [PATCH 4/7] tracing: reset iterator in t_start()
> [PATCH 5/7] ftrace: don't increment @pos in g_start()
> [PATCH 6/7] ftrace: don't manipulate @pos in t_start()
> [PATCH 7/7] ftrace: fix t_hash_start()
> ---
>  kernel/trace/ftrace.c       |   52 ++++++++++++++++++++++++-------------------
>  kernel/trace/trace.c        |   18 +++-----------
>  kernel/trace/trace_events.c |   28 ++++++++++++++++++-----
>  kernel/trace/trace_printk.c |   26 +++++----------------
>  kernel/trace/trace_stat.c   |    6 +----
>  5 files changed, 62 insertions(+), 68 deletions(-)

Applied to tip:tracing/urgent, thanks a lot!

	Ingo
