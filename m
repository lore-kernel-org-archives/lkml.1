Return-Path: <linux-kernel-owner+w=401wt.eu-S1753965AbZBCGgr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753965AbZBCGgr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 01:36:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751953AbZBCGgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 01:36:25 -0500
Received: from rex.securecomputing.com ([203.24.151.4]:47978 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751726AbZBCGgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 01:36:23 -0500
Message-ID: <4987E5E4.3070409@snapgear.com>
Date: Tue, 03 Feb 2009 16:36:20 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Geert Uytterhoeven <geert@linux-m68k.org>
CC: uClinux development list <uclinux-dev@uclinux.org>,
       Sam Ravnborg <sam@ravnborg.org>,
       Linux/m68k <linux-m68k@vger.kernel.org>,
       Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: Re: [uClinux-dev] [PATCH] m68k: Unify arch/m68k/include/asm/unistd.h
References: <Pine.LNX.4.64.0902011114410.30504@anakin> <498599A6.7080202@snapgear.com> <Pine.LNX.4.64.0902022245400.15898@anakin>
In-Reply-To: <Pine.LNX.4.64.0902022245400.15898@anakin>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Geert,

Geert Uytterhoeven wrote:
> On Sun, 1 Feb 2009, Greg Ungerer wrote:
>> Geert Uytterhoeven wrote:
>>       m68k: use mmu scatterlist.h for non-mmu setups as well
> 
> A small cleanup:

Thanks, I'll put that in the git tree as well.

Regards
Greg


>>From bb3640a02d427175006f8d0c49311bf7a2290dd0 Mon Sep 17 00:00:00 2001
> From: Geert Uytterhoeven <geert@linux-m68k.org>
> Date: Mon, 2 Feb 2009 22:14:23 +0100
> Subject: [PATCH] m68k: Use dma_addr_t for scatterlist.dma_address
> 
> dma_addr_t (as was used by m68knommu) is more correct than u32.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
>  arch/m68k/include/asm/scatterlist.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/m68k/include/asm/scatterlist.h b/arch/m68k/include/asm/scatterlist.h
> index d3a7a0e..e27ad90 100644
> --- a/arch/m68k/include/asm/scatterlist.h
> +++ b/arch/m68k/include/asm/scatterlist.h
> @@ -11,7 +11,7 @@ struct scatterlist {
>  	unsigned int offset;
>  	unsigned int length;
>  
> -	__u32 dma_address;	/* A place to hang host-specific addresses at. */
> +	dma_addr_t dma_address;	/* A place to hang host-specific addresses at. */
>  };
>  
>  /* This is bogus and should go away. */


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Principal Engineer        EMAIL:     gerg@snapgear.com
SnapGear, a McAfee Company                  PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
