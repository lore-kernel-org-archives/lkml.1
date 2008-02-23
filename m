Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbYBWIRD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbYBWIRD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2008 03:17:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764116AbYBWIJK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 Feb 2008 03:09:10 -0500
Received: from smtp1.linux-foundation.org ([207.189.120.13]:53647 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933054AbYBWIIx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2008 03:08:53 -0500
Date: Sat, 23 Feb 2008 00:05:47 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       netdev@vger.kernel.org, trond.myklebust@fys.uio.no
Subject: Re: [PATCH 04/28] mm: kmem_estimate_pages()
Message-Id: <20080223000547.25c7ba92.akpm@linux-foundation.org>
In-Reply-To: <20080220150305.774294000@chello.nl>
References: <20080220144610.548202000@chello.nl>
	<20080220150305.774294000@chello.nl>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Feb 2008 15:46:14 +0100 Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:

> Provide a method to get the upper bound on the pages needed to allocate
> a given number of objects from a given kmem_cache.
> 
> This lays the foundation for a generic reserve framework as presented in
> a later patch in this series. This framework needs to convert object demand
> (kmalloc() bytes, kmem_cache_alloc() objects) to pages.
> 
> ...
>
>  /*
> + * return the max number of pages required to allocated count
> + * objects from the given cache
> + */
> +unsigned kmem_estimate_pages(struct kmem_cache *s, gfp_t flags, int objects)

You might want to have another go at that comment.

> +/*
> + * return the max number of pages required to allocate @bytes from kmalloc
> + * in an unspecified number of allocation of heterogeneous size.
> + */
> +unsigned kestimate(gfp_t flags, size_t bytes)

And its pal.


