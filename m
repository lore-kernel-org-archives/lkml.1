Return-Path: <linux-kernel-owner+w=401wt.eu-S1755998AbZBKJK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998AbZBKJK0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Feb 2009 04:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbZBKJKM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Feb 2009 04:10:12 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:53147 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753823AbZBKJKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Feb 2009 04:10:11 -0500
Date: Wed, 11 Feb 2009 10:10:02 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/7] git pull request for tip/tracing/ftace
Message-ID: <20090211091002.GH21105@elte.hu>
References: <20090210173504.973802731@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090210173504.973802731@goodmis.org>
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
> The following is based off of tip/tracing/ftrace.
> 
> -- Steve
> 
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/tracing/ftrace
> 
> 
> Lai Jiangshan (2):
>       ring_buffer: fix typing mistake
>       ring_buffer: fix ring_buffer_read_page()
> 
> Steven Rostedt (1):
>       tracing, x86: fix constraint for parent variable
> 
> Tobias Klauser (1):
>       tracing: storage class should be before const qualifier
> 
> Wenji Huang (3):
>       tracing: remove unneeded variable
>       tracing: provide correct return value after outputting the event
>       tracing: fix typos in comments
> 
> ----
>  arch/x86/kernel/ftrace.c             |    9 +++---
>  include/linux/ring_buffer.h          |    2 +-
>  kernel/trace/ring_buffer.c           |   46 +++++++++++++++++++--------------
>  kernel/trace/trace.c                 |    2 +-
>  kernel/trace/trace_branch.c          |    4 +--
>  kernel/trace/trace_functions_graph.c |   14 +++++-----
>  kernel/trace/trace_hw_branches.c     |    2 +-
>  kernel/trace/trace_sysprof.c         |    2 +-
>  8 files changed, 42 insertions(+), 39 deletions(-)

Pulled into tip:tracing/ftrace, thanks Steve!

Note, i cherry-picked this fix into tip:tracing/urgent:

  9666578: tracing, x86: fix constraint for parent variable

As in theory GCC can miscompile the function-return-tracer, right?

	Ingo
