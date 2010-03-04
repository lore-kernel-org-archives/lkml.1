Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0CDEGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 23:06:40 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54241 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755079Ab0CDEGe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 23:06:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: wzt.wzt@gmail.com
Subject: Re: [PATCH] mm: Fix some coding styles on mm/ tree
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, akpm@linux-foundation.org
In-Reply-To: <20100304110916.GA3197@localhost.localdomain>
References: <20100304110916.GA3197@localhost.localdomain>
Message-Id: <20100304130509.D653.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu,  4 Mar 2010 13:06:31 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index c26986c..fbe2793 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -1327,9 +1327,9 @@ static void shrink_active_list(unsigned long nr_pages, struct zone *zone,
>  	 * zone->pages_scanned is used for detect zone's oom
>  	 * mem_cgroup remembers nr_scan by itself.
>  	 */
> -	if (scanning_global_lru(sc)) {
> +	if (scanning_global_lru(sc))
>  		zone->pages_scanned += pgscanned;
> -	}
> +
>  	reclaim_stat->recent_scanned[file] += nr_taken;
>  
>  	__count_zone_vm_events(PGREFILL, zone, pgscanned);

Probably this part is my fault. 

Thanks! Zhitong.



