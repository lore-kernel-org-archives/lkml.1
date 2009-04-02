Return-Path: <linux-kernel-owner+w=401wt.eu-S1761767AbZDBR5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761767AbZDBR5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Apr 2009 13:57:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759193AbZDBR5L
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Apr 2009 13:57:11 -0400
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:39180 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755643AbZDBR5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Apr 2009 13:57:10 -0400
Date: Thu, 2 Apr 2009 23:26:24 +0530
From: Gautham R Shenoy <ego@in.ibm.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>,
       akpm <akpm@linux-foundation.org>, mingo@elte.hu
Subject: Re: [PATCH] sched: fix errors in struct & function comments
Message-ID: <20090402175624.GB22030@in.ibm.com>
Reply-To: ego@in.ibm.com
References: <20090328215247.daaad3f3.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090328215247.daaad3f3.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 28, 2009 at 09:52:47PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix kernel-doc errors in sched.c:  the structs don't have
> kernel-doc notation and the short function description needs to
> be one line only.

Sorry, that's my fault.

Didn't know about the kernel-doc notation for structs.
Thanks Randy for fixing this.

> 
> Error(kernel/sched.c:3197): cannot understand prototype: 'struct sd_lb_stats '
> Error(kernel/sched.c:3228): cannot understand prototype: 'struct sg_lb_stats '
> Error(kernel/sched.c:3375): duplicate section name 'Description'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> cc: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched.c |   15 ++++++++-------
>  1 file changed, 8 insertions(+), 7 deletions(-)
> 
> --- linux-2.6.29-git4.orig/kernel/sched.c
> +++ linux-2.6.29-git4/kernel/sched.c
> @@ -3190,7 +3190,7 @@ static int move_one_task(struct rq *this
>  	return 0;
>  }
>  /********** Helpers for find_busiest_group ************************/
> -/**
> +/*
>   * sd_lb_stats - Structure to store the statistics of a sched_domain
>   * 		during load balancing.
>   */
> @@ -3222,7 +3222,7 @@ struct sd_lb_stats {
>  #endif
>  };
> 
> -/**
> +/*
>   * sg_lb_stats - stats of a sched_group required for load_balancing
>   */
>  struct sg_lb_stats {
> @@ -3360,16 +3360,17 @@ static inline void update_sd_power_savin
>  }
> 
>  /**
> - * check_power_save_busiest_group - Check if we have potential to perform
> - *	some power-savings balance. If yes, set the busiest group to be
> - *	the least loaded group in the sched_domain, so that it's CPUs can
> - *	be put to idle.
> - *
> + * check_power_save_busiest_group - see if there is potential for some power-savings balance
>   * @sds: Variable containing the statistics of the sched_domain
>   *	under consideration.
>   * @this_cpu: Cpu at which we're currently performing load-balancing.
>   * @imbalance: Variable to store the imbalance.
>   *
> + * Description:
> + * Check if we have potential to perform some power-savings balance.
> + * If yes, set the busiest group to be the least loaded group in the
> + * sched_domain, so that it's CPUs can be put to idle.
> + *
>   * Returns 1 if there is potential to perform power-savings balance.
>   * Else returns 0.
>   */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Thanks and Regards
gautham
