Return-Path: <linux-kernel-owner+w=401wt.eu-S1755984AbYHSONs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984AbYHSONs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 10:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753198AbYHSONk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 10:13:40 -0400
Received: from winston.telenet-ops.be ([195.130.137.75]:50853 "EHLO
	winston.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752083AbYHSONj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 10:13:39 -0400
Date: Tue, 19 Aug 2008 16:13:33 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Adrian Bunk <bunk@kernel.org>
cc: gerg@uclinux.org, jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
       linux-pci@vger.kernel.org
Subject: Re: [2.6 patch] m68knommu: let PCI depend on BROKEN
In-Reply-To: <20080819134718.GH8852@cs181140183.pp.htv.fi>
Message-ID: <Pine.LNX.4.64.0808191613100.9575@anakin>
References: <20080819134718.GH8852@cs181140183.pp.htv.fi>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Aug 2008, Adrian Bunk wrote:
> There exists blackfin hardware with PCI support, but the support
> currently in the kernel fails to build starting with:
> 
> <--  snip  -->
> 
> ...
>   CC      init/main.o
> In file included from dma-mapping.h:5,
>                  from dma-mapping.h:52,
>                  from dmaengine.h:29,
>                  from skbuff.h:29,
>                  from netlink.h:155,
>                  from genetlink.h:4,
>                  from genetlink.h:4,
>                  from taskstats_kern.h:12,
>                  from main.c:46:
> dma-mapping.h: In function 'dma_supported': ma-mapping.h:24: 
> error: implicit declaration of function 'pci_dma_supported'
> ...
> make[2]: *** [init/main.o] Error 1
> 
> 
> <--  snip  -->
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 3bdc07c86b6fd5fc18b7676a75c3ff907e00e807 
> diff --git a/arch/m68knommu/Kconfig b/arch/m68knommu/Kconfig
> index 2e7515e..77a5bdf 100644
> --- a/arch/m68knommu/Kconfig
> +++ b/arch/m68knommu/Kconfig
> @@ -702,6 +702,7 @@ menu "Bus options (PCI, PCMCIA, EISA, MCA, ISA)"
>  
>  config PCI
>  	bool "PCI support"
> +	depends on BROKEN
>  	help
>  	  Support for PCI bus.

blackfin != m68knommu

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
