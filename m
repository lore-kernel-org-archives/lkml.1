Return-Path: <linux-kernel-owner+w=401wt.eu-S1756878AbXJXMKK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878AbXJXMKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:10:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757976AbXJXMJy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:09:54 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10987 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757947AbXJXMJx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:09:53 -0400
Date: Wed, 24 Oct 2007 14:09:50 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: chris@zankel.net, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] xtensa: fix sg fallout
Message-ID: <20071024120950.GU14671@kernel.dk>
References: <20071024120755.GC30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024120755.GC30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Adrian Bunk wrote:
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> d1794cb192dcd1212c9bc2f3f78f5ca4860bf6ce 
> diff --git a/include/asm-xtensa/dma-mapping.h b/include/asm-xtensa/dma-mapping.h
> index 8bd9d2c..791e1c9 100644
> --- a/include/asm-xtensa/dma-mapping.h
> +++ b/include/asm-xtensa/dma-mapping.h
> @@ -11,7 +11,7 @@
>  #ifndef _XTENSA_DMA_MAPPING_H
>  #define _XTENSA_DMA_MAPPING_H
>  
> -#include <asm/scatterlist.h>
> +#include <linux/scatterlist.h>
>  #include <asm/cache.h>
>  #include <asm/io.h>
>  #include <linux/mm.h>
> 

already merged

-- 
Jens Axboe

