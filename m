Return-Path: <linux-kernel-owner+w=401wt.eu-S932592AbYBMWVd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932592AbYBMWVd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:21:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756955AbYBMWVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 17:21:22 -0500
Received: from relay2.sgi.com ([192.48.171.30]:45980 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758363AbYBMWVU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 17:21:20 -0500
Date: Wed, 13 Feb 2008 14:21:19 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Adrian Bunk <bunk@kernel.org>
cc: penberg@cs.helsinki.fi, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] make slub.c:slab_address() static
In-Reply-To: <20080213213032.GH3383@cs181133002.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0802131420590.21486@schroedinger.engr.sgi.com>
References: <20080213213032.GH3383@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Queued-by: Christoph Lameter <clameter@sgi.com>

On Wed, 13 Feb 2008, Adrian Bunk wrote:

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
> 
