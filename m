Return-Path: <linux-kernel-owner+w=401wt.eu-S1760322AbZFBIbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760322AbZFBIbH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 04:31:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759719AbZFBIay
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 04:30:54 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:43407 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759572AbZFBIax (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 04:30:53 -0400
Date: Tue, 2 Jun 2009 10:30:43 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 00/10] [GIT PULL] tracing: various updates
Message-ID: <20090602083043.GC12411@elte.hu>
References: <20090602044315.439593107@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090602044315.439593107@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
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
> Please pull the latest tip/tracing/ftrace-2 tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/ftrace-2
> 
> 
> Li Zefan (3):
>       tracing/events: fix a typo in __string() format output
>       tracing/events: put TP_fast_assign into braces
>       tracing/events: introduce __dynamic_array()
> 
> Steven Rostedt (6):
>       ftrace: add kernel command line function filtering
>       tracing: fix config options to not show when automatically selected
>       tracing: combine the default tracers into one config
>       tracing: remove redundant SOFTIRQ from softirq event traces
>       tracing: make trace pipe recognize latency format flag
>       ftrace: do not profile functions when disabled
> 
> Steven Whitehouse (1):
>       tracing: add exports to use __print_symbolic and __print_flags from a module
> 
> ----
>  Documentation/kernel-parameters.txt |   17 ++++-
>  include/linux/ftrace_event.h        |    2 +-
>  include/trace/events/irq.h          |   24 +++---
>  include/trace/ftrace.h              |  126 +++++++++++++++++++++++++----------
>  kernel/trace/Kconfig                |   60 ++++++++--------
>  kernel/trace/ftrace.c               |   50 +++++++++++++-
>  kernel/trace/trace.c                |    3 +
>  kernel/trace/trace_events_filter.c  |    6 +-
>  kernel/trace/trace_output.c         |    3 +
>  9 files changed, 205 insertions(+), 86 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
