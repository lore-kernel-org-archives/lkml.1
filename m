Return-Path: <linux-kernel-owner+w=401wt.eu-S1755528AbZCRGAA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528AbZCRGAA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 02:00:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752849AbZCRF7u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 01:59:50 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:37386 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172AbZCRF7t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 01:59:49 -0400
Date: Wed, 18 Mar 2009 06:59:24 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/5] [GIT PULL] updates for tip/tracing/ftrace
Message-ID: <20090318055924.GA24627@elte.hu>
References: <20090318031423.981603258@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090318031423.981603258@goodmis.org>
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
> Steven Rostedt (4):
>       ring-buffer: add api to allow a tracer to change clock source
>       tracing: add global-clock option to provide cross CPU clock to traces
>       tracing: make sched_switch stop/start light weight
>       tracing: make power tracer start/stop methods lighter weight
> 
> Witold Baryluk (1):
>       tracing: optimization of branch tracer
> 
> ----
>  include/linux/compiler.h          |    6 +--
>  include/linux/ring_buffer.h       |    7 +++-
>  kernel/trace/ring_buffer.c        |   65 +++++++++++++++++++++---------------
>  kernel/trace/trace.c              |   55 +++++++++++++++++++++++++------
>  kernel/trace/trace.h              |    1 +
>  kernel/trace/trace_power.c        |    8 +++-
>  kernel/trace/trace_sched_switch.c |    9 +++--
>  7 files changed, 101 insertions(+), 50 deletions(-)

Pulled, thanks a lot Steve!

	Ingo
