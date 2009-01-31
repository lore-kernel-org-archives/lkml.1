Return-Path: <linux-kernel-owner+w=401wt.eu-S1754405AbZAaNuN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754405AbZAaNuN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Jan 2009 08:50:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752155AbZAaNt7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Jan 2009 08:49:59 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:36672 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750953AbZAaNt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Jan 2009 08:49:58 -0500
Date: Sat, 31 Jan 2009 14:49:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, Mike Travis <travis@sgi.com>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] sched_rt: don't use first_cpu on cpumask created with
	cpumask_and.
Message-ID: <20090131134947.GA23973@elte.hu>
References: <200901312321.25344.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200901312321.25344.rusty@rustcorp.com.au>
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


* Rusty Russell <rusty@rustcorp.com.au> wrote:

> Ingo, please apply to tip/urgent.
> 
> cpumask_and() only initializes nr_cpu_ids bits, so the (deprecated)
> first_cpu() might find one of those uninitialized bits if nr_cpu_ids
> is less than NR_CPUS (as it can be for CONFIG_CPUMASK_OFFSTACK).
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
> ---
>  kernel/sched_rt.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Applied to tip/sched/urgent, thanks Rusty!

Also, Git sorted out the same-content merge with this commit in cpus4096 
just fine:

  d38b223: cpumask: reduce stack usage in find_lowest_rq

(this commit is where you backported it from i suspect?)

	Ingo
