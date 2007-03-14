Return-Path: <linux-kernel-owner+w=401wt.eu-S932367AbXCNTr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367AbXCNTr3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2007 15:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932501AbXCNTr3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Mar 2007 15:47:29 -0400
Received: from hoefnix.telenet-ops.be ([195.130.132.54]:48331 "EHLO
	hoefnix.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932367AbXCNTr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2007 15:47:28 -0400
Date: Wed, 14 Mar 2007 20:46:06 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: torvalds@linux-foundation.org,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 17/17] m68k dma-mapping: gfp_t annotations
In-Reply-To: <E1HRPey-0003d4-2p@ZenIV.linux.org.uk>
Message-ID: <Pine.LNX.4.64.0703142045530.5429@anakin>
References: <E1HRPey-0003d4-2p@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Mar 2007, Al Viro wrote:
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> ---
>  include/asm-m68k/dma-mapping.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/include/asm-m68k/dma-mapping.h b/include/asm-m68k/dma-mapping.h
> index 00259ed..a26cdeb 100644
> --- a/include/asm-m68k/dma-mapping.h
> +++ b/include/asm-m68k/dma-mapping.h
> @@ -32,7 +32,7 @@ extern void dma_free_coherent(struct device *, size_t,
>  			      void *, dma_addr_t);
>  
>  static inline void *dma_alloc_noncoherent(struct device *dev, size_t size,
> -					  dma_addr_t *handle, int flag)
> +					  dma_addr_t *handle, gfp_t flag)
>  {
>  	return dma_alloc_coherent(dev, size, handle, flag);
>  }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
