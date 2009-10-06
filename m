Return-Path: <linux-kernel-owner+w=401wt.eu-S1757101AbZJFQmf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757101AbZJFQmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 12:42:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756849AbZJFQme
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 12:42:34 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:30453 "EHLO
	rgminet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756749AbZJFQmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 12:42:33 -0400
Date: Tue, 6 Oct 2009 09:32:11 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix htmldocs sched.c
Message-Id: <20091006093211.476982d0.randy.dunlap@oracle.com>
In-Reply-To: <1253799530.10654.7.camel@ht.satnam>
References: <1253799530.10654.7.camel@ht.satnam>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4ACB72FB.0025:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Sep 2009 19:08:50 +0530 Jaswinder Singh Rajput wrote:

> 
> fix the following htmldocs warnings:
> 
>   Warning(kernel/sched.c:685): No description found for parameter 'cpu'
>   Warning(kernel/sched.c:3676): No description found for parameter 'sd'
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Randy Dunlap <randy.dunlap@oracle.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  kernel/sched.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/sched.c b/kernel/sched.c
> index 2f76e06..f0d1375 100644
> --- a/kernel/sched.c
> +++ b/kernel/sched.c
> @@ -676,6 +676,7 @@ inline void update_rq_clock(struct rq *rq)
>  
>  /**
>   * runqueue_is_locked
> + * @cpu: the processor in question.
>   *
>   * Returns true if the current cpu runqueue is locked.
>   * This interface allows printk to be called with the runqueue lock
> @@ -3658,6 +3659,7 @@ static void update_group_power(struct sched_domain *sd, int cpu)
>  
>  /**
>   * update_sg_lb_stats - Update sched_group's statistics for load balancing.
> + * @sd: The sched_domain whose statistics are to be updated.
>   * @group: sched_group whose statistics are to be updated.
>   * @this_cpu: Cpu for which load balance is currently performed.
>   * @idle: Idle status of this_cpu
> -- 


---
~Randy
