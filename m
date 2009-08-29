Return-Path: <linux-kernel-owner+w=401wt.eu-S1752183AbZH2LGj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752183AbZH2LGj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Aug 2009 07:06:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751464AbZH2LGi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 29 Aug 2009 07:06:38 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37088 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751373AbZH2LGi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Aug 2009 07:06:38 -0400
Date: Sat, 29 Aug 2009 13:06:13 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 0/2] [GIT PULL] tracing: minor updates for 2.6.32
Message-ID: <20090829110613.GE6812@elte.hu>
References: <20090828203736.440768383@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090828203736.440768383@goodmis.org>
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

> 
> Ingo,
> 
> Please pull the latest tip/tracing/core tree, which can be found at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> tip/tracing/core
> 
> 
> Steven Rostedt (2):
>       tracing: remove legacy select of MARKERS by context switch tracing
>       tracing: only show tracing_max_latency when latency tracer configured
> 
> ----
>  kernel/trace/Kconfig |    1 -
>  kernel/trace/trace.c |   92 +++++++++++++++++++++++++++-----------------------
>  kernel/trace/trace.h |    2 +
>  3 files changed, 52 insertions(+), 43 deletions(-)

Pulled, thanks a lot Steve!

Note, tracing/core is not in tip:master right now, due to the lockup 
i found during testing - see this thread on lkml:

Subject: Re: [GIT PULL] tracing/syscalls: The next bunch

	Ingo
