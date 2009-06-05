Return-Path: <linux-kernel-owner+w=401wt.eu-S1755471AbZFESUO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471AbZFESUO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 14:20:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752813AbZFESUD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 14:20:03 -0400
Received: from mk-filter-2-a-1.mail.uk.tiscali.com ([212.74.100.53]:37974 "EHLO
	mk-filter-2-a-1.mail.uk.tiscali.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752651AbZFESUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 14:20:02 -0400
X-Trace: 210086260/mk-filter-2.mail.uk.tiscali.com/B2C/$b2c-THROTTLED-DYNAMIC/b2c-CUSTOMER-DYNAMIC-IP/80.41.42.194/None/hugh.dickins@tiscali.co.uk
X-SBRS: None
X-RemoteIP: 80.41.42.194
X-IP-MAIL-FROM: hugh.dickins@tiscali.co.uk
X-SMTP-AUTH: 
X-MUA: 
X-IP-BHB: Once
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApMCACj/KEpQKSrC/2dsb2JhbAAI0VaECgU
X-IronPort-AV: E=Sophos;i="4.41,312,1241391600"; 
   d="scan'208";a="210086260"
Date: Fri, 5 Jun 2009 19:03:52 +0100 (BST)
From: Hugh Dickins <hugh.dickins@tiscali.co.uk>
X-X-Sender: hugh@sister.anvils
To: Minchan Kim <minchan.kim@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>
Subject: Re: [PATCH][mmtom] remove annotation of gfp_mask in add_to_swap
In-Reply-To: <1244212237-14128-1-git-send-email-minchan.kim@gmail.com>
Message-ID: <Pine.LNX.4.64.0906051858160.14826@sister.anvils>
References: <1244212237-14128-1-git-send-email-minchan.kim@gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Jun 2009, Minchan Kim wrote:

> Hugh removed add_to_swap's gfp_mask argument.
> (mm: remove gfp_mask from add_to_swap)
> So we have to remove annotation of gfp_mask  of the function.

"annotation"?  Or "DocBook comment"?  Or "DocBook annotation"?

> 
> This patch cleans up add_to_swap function.
> It doesn't affect behavior of function.
> 
> Signed-off-by: Minchan Kim <minchan.kim@gmail.com>
> Cc: Hugh Dickins <hugh.dickins@tiscali.co.uk>

Thanks, yes, my oversight.

Acked-by: Hugh Dickins <hugh.dickins@tiscali.co.uk>

> ---
>  mm/swap_state.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/mm/swap_state.c b/mm/swap_state.c
> index b9ca029..b62e7f5 100644
> --- a/mm/swap_state.c
> +++ b/mm/swap_state.c
> @@ -124,7 +124,6 @@ void __delete_from_swap_cache(struct page *page)
>  /**
>   * add_to_swap - allocate swap space for a page
>   * @page: page we want to move to swap
> - * @gfp_mask: memory allocation flags
>   *
>   * Allocate swap space for the page and add the page to the
>   * swap cache.  Caller needs to hold the page lock. 
> -- 
> 1.5.6.5
