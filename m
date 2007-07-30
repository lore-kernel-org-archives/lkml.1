Return-Path: <linux-kernel-owner+w=401wt.eu-S1765548AbXG3K3A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765548AbXG3K3A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2007 06:29:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbXG3K2x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jul 2007 06:28:53 -0400
Received: from calculon.skynet.ie ([193.1.99.88]:56736 "EHLO
	calculon.skynet.ie" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbXG3K2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2007 06:28:52 -0400
Date: Mon, 30 Jul 2007 11:28:50 +0100
To: Adrian Bunk <bunk@stusta.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] mm/page_alloc.c: make code static
Message-ID: <20070730102850.GA13683@skynet.ie>
References: <20070729145802.GT16817@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20070729145802.GT16817@stusta.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: mel@skynet.ie (Mel Gorman)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On (29/07/07 16:58), Adrian Bunk didst pronounce:
> This patch makes needlessly global code static.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> 

Seems fair.

Acked-by: Mel Gorman <mel@csn.ul.ie>

> ---
> 
>  mm/page_alloc.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1/mm/page_alloc.c.old	2007-07-26 15:09:24.000000000 +0200
> +++ linux-2.6.23-rc1-mm1/mm/page_alloc.c	2007-07-26 15:11:16.000000000 +0200
> @@ -142,7 +142,7 @@
>    static unsigned long __meminitdata node_boundary_end_pfn[MAX_NUMNODES];
>  #endif /* CONFIG_MEMORY_HOTPLUG_RESERVE */
>    unsigned long __initdata required_kernelcore;
> -  unsigned long __initdata required_movablecore;
> +  static unsigned long __initdata required_movablecore;
>    unsigned long __meminitdata zone_movable_pfn[MAX_NUMNODES];
>  
>    /* movable_zone is the "real" zone pages in ZONE_MOVABLE are taken from */
> @@ -3686,7 +3686,7 @@
>  	return max_pfn;
>  }
>  
> -unsigned long __init early_calculate_totalpages(void)
> +static unsigned long __init early_calculate_totalpages(void)
>  {
>  	int i;
>  	unsigned long totalpages = 0;

-- 
-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
