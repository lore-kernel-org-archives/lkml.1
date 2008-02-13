Return-Path: <linux-kernel-owner+w=401wt.eu-S934407AbYBMV55@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934407AbYBMV55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 16:57:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763422AbYBMVfp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:35:45 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:46208 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765559AbYBMVfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:35:43 -0500
Message-ID: <47B3626C.2080604@cs.helsinki.fi>
Date: Wed, 13 Feb 2008 23:34:36 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.9 (Macintosh/20071031)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: clameter@sgi.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make slub.c:slab_address() static
References: <20080213213032.GH3383@cs181133002.pp.htv.fi>
In-Reply-To: <20080213213032.GH3383@cs181133002.pp.htv.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> slab_address() can become static.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> fdd710f00d8bed8413c160685bc5229ec15b4d9f diff --git a/mm/slub.c b/mm/slub.c
> index e2989ae..af83daf 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -308,7 +308,7 @@ static inline int is_end(void *addr)
>  	return (unsigned long)addr & PAGE_MAPPING_ANON;
>  }
>  
> -void *slab_address(struct page *page)
> +static void *slab_address(struct page *page)
>  {
>  	return page->end - PAGE_MAPPING_ANON;
>  }
> 

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
