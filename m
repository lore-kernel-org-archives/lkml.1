Return-Path: <linux-kernel-owner+w=401wt.eu-S1757754AbZBENhu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757754AbZBENhu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Feb 2009 08:37:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756358AbZBENhk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Feb 2009 08:37:40 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47647 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755099AbZBENhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Feb 2009 08:37:39 -0500
Date: Thu, 5 Feb 2009 14:37:20 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/3] ftrace: updates for tip
Message-ID: <20090205133720.GB19907@elte.hu>
References: <20090205061335.917484162@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090205061335.917484162@goodmis.org>
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
> Arnaldo was nice enough to do something that was on my todo list
> for quite some time.
> 
> I also included the change you asked for.
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Arnaldo Carvalho de Melo (2):
>       trace_branch: Remove unused function
>       trace: Remove unused trace_array_cpu parameter
> 
> Steven Rostedt (1):
>       trace: code style clean up
> 
> ----
>  block/blktrace.c                  |    2 +-
>  kernel/trace/trace.c              |   76 ++++++++++++++++---------------------
>  kernel/trace/trace.h              |    4 --
>  kernel/trace/trace_branch.c       |   17 --------
>  kernel/trace/trace_functions.c    |    8 ++--
>  kernel/trace/trace_irqsoff.c      |   10 ++--
>  kernel/trace/trace_sched_switch.c |    4 +-
>  kernel/trace/trace_sched_wakeup.c |   12 ++---
>  8 files changed, 50 insertions(+), 83 deletions(-)

Applied to tip:tracing/ftrace, thanks guys!

	Ingo
