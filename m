Return-Path: <linux-kernel-owner+w=401wt.eu-S1758223AbZCYHZp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758223AbZCYHZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Mar 2009 03:25:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757321AbZCYHZf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Mar 2009 03:25:35 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46823 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757228AbZCYHZe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Mar 2009 03:25:34 -0400
Date: Wed, 25 Mar 2009 08:25:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Pekka Enberg <penberg@cs.helsinki.fi>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Roland McGrath <roland@redhat.com>,
       Nick Piggin <nickpiggin@yahoo.com.au>
Subject: Re: [PATCH 0/5] [PATCH][GIT PULL] remove unnecessary (un)likelys
Message-ID: <20090325072501.GC25833@elte.hu>
References: <20090325051920.406564281@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090325051920.406564281@goodmis.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
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

> ----
>  arch/x86/kernel/ptrace.c |    4 ++--
>  kernel/sched.c           |    4 ++--
>  kernel/sched_rt.c        |    2 +-
>  mm/rmap.c                |    8 ++++----
>  mm/slab.c                |    2 +-
>  mm/slob.c                |    2 +-
>  mm/slub.c                |    2 +-
>  7 files changed, 12 insertions(+), 12 deletions(-)

I commented on the ptrace one - i think we should take that one out 
or at least wait for more info.

The MM ones look correct. Maybe your kfree observation will be 
debated - but i think it's probably right that we should not special 
annotate kfree(NULL) anymore in any direction. But it's ultimately 
up to the MM folks. (I've Cc:-ed Pekka too)

The rmap and the scheduler ones definitely look correct. When you 
rebase, please include the profiler output to 3/5 too.

Thanks,

	Ingo
