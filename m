Return-Path: <linux-kernel-owner+w=401wt.eu-S1764716AbZLQNXG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764716AbZLQNXG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 08:23:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759833AbZLQNW7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 08:22:59 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:34440 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759720AbZLQNW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 08:22:58 -0500
Date: Thu, 17 Dec 2009 08:22:56 -0500
From: Kyle McMartin <kyle@mcmartin.ca>
To: kyle@mcmartin.ca
Cc: torvalds@linux-foundation.org, linux-parisc@vger.kernel.org,
       linux-kernel@vger.kernel.org, James.Bottomley@suse.de,
       hch@infradead.org, linux-arch@vger.kernel.org
Subject: Re: [git patches] xfs and block fixes for virtually indexed arches
Message-ID: <20091217132256.GO28962@bombadil.infradead.org>
References: <20091216043618.GB9104@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091216043618.GB9104@hera.kernel.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, any word on these? I'd really love to get jejb and hch off
my back. :)

cheers, Kyle

On Wed, Dec 16, 2009 at 04:36:18AM +0000, Kyle McMartin wrote:
> As discussed on linux-arch@ recently, these fixes are necessary for
> XFS to work on virtually indexed architectures since otherwise vmalloc'd
> pages are not properly flushed from the cache.
> 
> Thanks!
>  Kyle
> 
> The following changes since commit 8bea8672edfca7ec5f661cafb218f1205863b343:
>   Stephen Rothwell (1):
>         mfd: compile fix for twl4030 renaming
> 
> are available in the git repository at:
> 
>   hera.kernel.org:/pub/scm/linux/kernel/git/kyle/parisc-2.6.git coherence
> 
> James Bottomley (6):
>       mm: add coherence API for DMA to vmalloc/vmap areas
>       parisc: add mm API for DMA to vmalloc/vmap areas
>       arm: add mm API for DMA to vmalloc/vmap areas
>       sh: add mm API for DMA to vmalloc/vmap areas
>       block: permit I/O to vmalloc/vmap kernel pages
>       xfs: fix xfs to work with Virtually Indexed architectures
> 
>  Documentation/cachetlb.txt           |   24 ++++++++++++++++++++++++
>  arch/arm/include/asm/cacheflush.h    |   10 ++++++++++
>  arch/parisc/include/asm/cacheflush.h |    8 ++++++++
>  arch/sh/include/asm/cacheflush.h     |    8 ++++++++
>  fs/bio.c                             |   20 ++++++++++++++++++--
>  fs/xfs/linux-2.6/xfs_buf.c           |   20 ++++++++++++++++++++
>  include/linux/highmem.h              |    6 ++++++
>  7 files changed, 94 insertions(+), 2 deletions(-)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-parisc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
