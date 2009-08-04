Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbZHDL65@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbZHDL65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 07:58:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753516AbZHDL64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 07:58:56 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:38919 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753448AbZHDL64 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 07:58:56 -0400
Date: Tue, 4 Aug 2009 13:58:51 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/2] tracing/function_graph fixes for 2.6.31
Message-ID: <20090804115851.GB29545@elte.hu>
References: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1248818134-5231-1-git-send-email-fweisbec@gmail.com>
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

> Ingo, Thomas,
> 
> Those are two fixes for the function graph tracer for .31
> 
> The first one fixes a possible race condition between a function 
> graph trace reader and ring buffer writers, leading to a mixup 
> inside an event entry, or worst.
> 
> The second one fixes some issues in the output of the function 
> graph tracer while using splice on the trace_pipe file or 
> ftrace_dump().
> 
> Both fixes should also be backported on .30 for the -stable 
> branch.
> 
> Thanks,
> Frederic.
> 
> The following changes since commit 4733fd328f14280900435d9dbae1487d110a4d56:
>   Benjamin Herrenschmidt (1):
>         mm: Remove duplicate definitions in MIPS and SH
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git tracing/fixes
> 
> Lai Jiangshan (2):
>       tracing: Fix invalid function_graph entry
>       tracing: Fix missing function_graph events when we splice_read from trace_pipe
> 
>  kernel/trace/trace.c                 |   10 +++++++---
>  kernel/trace/trace_functions_graph.c |   11 +++++++++--
>  2 files changed, 16 insertions(+), 5 deletions(-)

Pulled, thanks a lot Frederic!

	Ingo
