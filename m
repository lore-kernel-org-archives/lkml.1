Return-Path: <linux-kernel-owner+w=401wt.eu-S1760025AbZATMFf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760025AbZATMFf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 07:05:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754440AbZATMF0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 07:05:26 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:47381 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754189AbZATMFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 07:05:25 -0500
Date: Tue, 20 Jan 2009 13:05:12 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 0/8] ftrace: updates to tip
Message-ID: <20090120120512.GA7790@elte.hu>
References: <20090120001542.687427797@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090120001542.687427797@goodmis.org>
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
> The one patch I did here, will need to go to stable as well. I'll write
> up a patch against stable, and as soon as it gets into Linus's tree,
> it should also be pulled into stable as well. Without the patch, some
> archs will not be able to perform any tracing. There is an alignment
> issue that will cause the ring buffer to fail to commit any transactions.
> 
> -- Steve
> 
> 
> The following patches are in:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
> 
>     branch: tip/devel
> 
> 
> Lai Jiangshan (1):
>       trace_workqueue: use percpu data for workqueue stat
> 
> Markus Metzger (6):
>       x86, ftrace, hw-branch-tracer: support hotplug cpus
>       x86, ftrace, hw-branch-tracer: dump trace on oops
>       x86, ftrace, hw-branch-tracer: reset trace buffer on close
>       x86, ftrace, hw-branch-tracer: change trace format
>       x86, ftrace, hw-branch-tracer: documentation
>       x86, ds, bts: cleanup DS configuration
> 
> Steven Rostedt (1):
>       ring-buffer: fix alignment problem
> 
> ----
>  Documentation/ftrace.txt         |   74 ++++++++++++++++
>  arch/x86/kernel/ds.c             |   31 ++++---
>  arch/x86/kernel/dumpstack.c      |    6 ++
>  include/linux/ftrace.h           |   13 +++
>  kernel/trace/ring_buffer.c       |    2 +-
>  kernel/trace/trace.h             |    1 -
>  kernel/trace/trace_hw_branches.c |  173 +++++++++++++++++++++++++++++++-------
>  kernel/trace/trace_workqueue.c   |   64 +++++++--------
>  8 files changed, 281 insertions(+), 83 deletions(-)

Pulled into tip/tracing/ftrace, thanks Steve!

	Ingo
