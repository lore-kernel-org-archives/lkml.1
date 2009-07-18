Return-Path: <linux-kernel-owner+w=401wt.eu-S1754344AbZGRI6s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbZGRI6s (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jul 2009 04:58:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753904AbZGRI6q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Jul 2009 04:58:46 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:44363 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753868AbZGRI6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jul 2009 04:58:45 -0400
Date: Sat, 18 Jul 2009 10:57:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: Re: [GIT PULL] tracing updates for 2.6.32
Message-ID: <20090718085743.GD7479@elte.hu>
References: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1247901421-6389-1-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

> Hi Ingo, Thomas,
> 
> Here are some fixes and enhancements for the 2.6.32 tracing tree.
> 
> Impacts:
> 
> - A spurious warning in the lockless ring buffer had been shutdown
> - Simplifications of various ftrace code areas resulting in more deletions than
>   additions.
> 
> These changes have been based against tip:tracing/core
> 
> Thanks,
> 
> Frederic.
> 
> 
> The following changes since commit e202687927c132b1e1ff36b526b5e78ac33de840:
>   Ingo Molnar (1):
>         Merge branch 'tip/tracing/ring-buffer-3' of git://git.kernel.org/.../rostedt/linux-2.6-trace into tracing/core
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/core
> 
> Lai Jiangshan (1):
>       ring_buffer: Fix warning while ignoring cmpxchg return value
> 
> Xiao Guangrong (3):
>       tracing/function: Simplify __ftrace_replace_code()
>       tracing/trace_stack: Cleanup for trace_lookup_stack()
>       tracing/function: Cleanup for function tracer
> 
>  kernel/trace/ftrace.c          |   89 +++++++++------------------------------
>  kernel/trace/ring_buffer.c     |    9 +++-
>  kernel/trace/trace_functions.c |    4 +-
>  kernel/trace/trace_stack.c     |    9 +----
>  4 files changed, 30 insertions(+), 81 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
