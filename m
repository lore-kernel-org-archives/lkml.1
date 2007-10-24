Return-Path: <linux-kernel-owner+w=401wt.eu-S1757978AbXJXMJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978AbXJXMJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 08:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754541AbXJXMJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 08:09:46 -0400
Received: from brick.kernel.dk ([87.55.233.238]:10984 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752764AbXJXMJq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 08:09:46 -0400
Date: Wed, 24 Oct 2007 14:09:42 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: bryan.wu@analog.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] blackfin: fix sg fallout
Message-ID: <20071024120942.GT14671@kernel.dk>
References: <20071024120732.GB30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071024120732.GB30533@stusta.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24 2007, Adrian Bunk wrote:
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> dc3f9077912fb66aabb61f336f7e2324ec2fa911 
> diff --git a/arch/blackfin/kernel/dma-mapping.c b/arch/blackfin/kernel/dma-mapping.c
> index a16cb03..d6b61d5 100644
> --- a/arch/blackfin/kernel/dma-mapping.c
> +++ b/arch/blackfin/kernel/dma-mapping.c
> @@ -35,6 +35,7 @@
>  #include <linux/device.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/scatterlist.h>
>  #include <asm/cacheflush.h>
>  #include <asm/bfin-global.h>

applied

-- 
Jens Axboe

