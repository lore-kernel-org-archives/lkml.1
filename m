Return-Path: <linux-kernel-owner+w=401wt.eu-S1755537AbZF1OxQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537AbZF1OxQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jun 2009 10:53:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752207AbZF1OxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 28 Jun 2009 10:53:02 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61514 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751966AbZF1OxB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jun 2009 10:53:01 -0400
Message-ID: <4A4783B7.8090706@cn.fujitsu.com>
Date: Sun, 28 Jun 2009 23:52:39 +0900
From: Miao Xie <miaox@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.22 (Windows/20090605)
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [patch] mm: remove obsoleted alloc_pages cpuset comment
References: <alpine.DEB.2.00.0906251346540.6083@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.0906251346540.6083@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When a cpuset's nodemask is updated, all attached tasks have their cached
> task->mems_allowed updated by a heap instead of requiring an explicit
> call to cpuset_update_task_memory_state(), which has since been removed
> in 58568d2a8215cb6f55caf2332017d7bdff954e1c.
> 
> Remove the obsoleted comment from the page allocator.

Sorry. It's my mistake. Thanks for your fix.

Acked-by: Miao Xie <miaox@cn.fujitsu.com>

> 
> Cc: Paul Menage <menage@google.com>
> Cc: Miao Xie <miaox@cn.fujitsu.com>
> Signed-off-by: David Rientjes <rientjes@google.com>
> ---
>  mm/page_alloc.c |    4 ----
>  1 files changed, 0 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 5d714f8..8670fb7 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -1620,10 +1620,6 @@ __alloc_pages_direct_reclaim(gfp_t gfp_mask, unsigned int order,
>  
>  	/* We now go into synchronous reclaim */
>  	cpuset_memory_pressure_bump();
> -
> -	/*
> -	 * The task's cpuset might have expanded its set of allowable nodes
> -	 */
>  	p->flags |= PF_MEMALLOC;
>  	lockdep_set_current_reclaim_state(gfp_mask);
>  	reclaim_state.reclaimed_slab = 0;
> 
> 
> 


