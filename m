Return-Path: <linux-kernel-owner+w=401wt.eu-S1756402AbZERJKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756402AbZERJKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 May 2009 05:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbZERJKL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 May 2009 05:10:11 -0400
Received: from mga03.intel.com ([143.182.124.21]:36952 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756104AbZERJKJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 May 2009 05:10:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.41,208,1241420400"; 
   d="scan'208";a="143967002"
Date: Mon, 18 May 2009 17:09:50 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Rik van Riel <riel@redhat.com>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH 4/4] zone_reclaim_mode is always 0 by default
Message-ID: <20090518090950.GA10439@localhost>
References: <20090513120155.5879.A69D9226@jp.fujitsu.com> <20090513120729.5885.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090513120729.5885.A69D9226@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 12:08:12PM +0900, KOSAKI Motohiro wrote:
> Index: b/mm/page_alloc.c
> ===================================================================
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -2494,13 +2494,6 @@ static void build_zonelists(pg_data_t *p
>  		int distance = node_distance(local_node, node);
>  
>  		/*
> -		 * If another node is sufficiently far away then it is better
> -		 * to reclaim pages in a zone before going off node.
> -		 */
> -		if (distance > RECLAIM_DISTANCE)
> -			zone_reclaim_mode = 1;
> -

Also remove the RECLAIM_DISTANCE definitions in
include/linux/topology.h and arch/ia64/include/asm/topology.h?
