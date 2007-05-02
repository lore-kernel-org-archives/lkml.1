Return-Path: <linux-kernel-owner+w=401wt.eu-S1766950AbXEBUMN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1766950AbXEBUMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 16:12:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1766949AbXEBUMN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 16:12:13 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:38249 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1766946AbXEBUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 16:12:11 -0400
Date: Wed, 2 May 2007 13:12:10 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Pekka J Enberg <penberg@cs.helsinki.fi>
cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slub: remove duplicate VM_BUG_ON
In-Reply-To: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI>
Message-ID: <Pine.LNX.4.64.0705021311440.1978@schroedinger.engr.sgi.com>
References: <Pine.LNX.4.64.0705022307310.16215@sbz-30.cs.Helsinki.FI>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Patch is already in mm. Could you download all the patches after that 
before testing? There was quite a number.

On Wed, 2 May 2007, Pekka J Enberg wrote:

> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This patch removes a duplicate VM_BUG_ON from add_full().
> 
> Cc: Christoph Lameter <clameter@sgi.com>
> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
> ---
>  mm/slub.c |    2 --
>  1 file changed, 2 deletions(-)
> 
> Index: 26-mm/mm/slub.c
> ===================================================================
> --- 26-mm.orig/mm/slub.c	2007-05-02 23:00:58.000000000 +0300
> +++ 26-mm/mm/slub.c	2007-05-02 23:01:15.000000000 +0300
> @@ -633,8 +633,6 @@ static void add_full(struct kmem_cache *
>  
>  	VM_BUG_ON(!irqs_disabled());
>  
> -	VM_BUG_ON(!irqs_disabled());
> -
>  	if (!(s->flags & SLAB_STORE_USER))
>  		return;
>  
> 
