Return-Path: <linux-kernel-owner+w=401wt.eu-S1764683AbYDYR4R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764683AbYDYR4R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 13:56:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762194AbYDYR4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 13:56:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:36109 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762048AbYDYR4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 13:56:05 -0400
Subject: Re: [PATCH] sched: make rt_sched_class, idle_sched_class static
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Harvey Harrison <harvey.harrison@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1209145993.20088.16.camel@brick>
References: <1209145993.20088.16.camel@brick>
Content-Type: text/plain
Date: Fri, 25 Apr 2008 19:55:31 +0200
Message-Id: <1209146131.1956.8.camel@lappy>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-04-25 at 10:53 -0700, Harvey Harrison wrote:
> The C files are included directly in sched.c, so they are
> effectively static.
> 
> Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

> ---
>  kernel/sched_idletask.c                          |    2 +-
>  kernel/sched_rt.c                                |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/sched_idletask.c b/kernel/sched_idletask.c
> index 2bcafa3..3a4f92d 100644
> --- a/kernel/sched_idletask.c
> +++ b/kernel/sched_idletask.c
> @@ -99,7 +99,7 @@ static void prio_changed_idle(struct rq *rq, struct task_struct *p,
>  /*
>   * Simple, special scheduling class for the per-CPU idle tasks:
>   */
> -const struct sched_class idle_sched_class = {
> +static const struct sched_class idle_sched_class = {
>  	/* .next is NULL */
>  	/* no enqueue/yield_task for idle tasks */
>  
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index c2730a5..dcd6495 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -1309,7 +1309,7 @@ static void set_curr_task_rt(struct rq *rq)
>  	p->se.exec_start = rq->clock;
>  }
>  
> -const struct sched_class rt_sched_class = {
> +static const struct sched_class rt_sched_class = {
>  	.next			= &fair_sched_class,
>  	.enqueue_task		= enqueue_task_rt,
>  	.dequeue_task		= dequeue_task_rt,

