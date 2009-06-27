Return-Path: <linux-kernel-owner+w=401wt.eu-S1755399AbZF0F2j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755399AbZF0F2j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jun 2009 01:28:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZF0F2b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jun 2009 01:28:31 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:55216 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751847AbZF0F2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jun 2009 01:28:30 -0400
Date: Sat, 27 Jun 2009 07:21:14 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: "Leo (Hao) Chen" <leochen@broadcom.com>
Cc: "linux-arm-kernel@lists.arm.linux.org.uk" 
	<linux-arm-kernel@lists.arm.linux.org.uk>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v1 1/6][ARM]  new ARM SoC support: BCMRing
Message-ID: <20090627052114.GE8587@game.jcrosoft.org>
References: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C2@SJEXCHCCR02.corp.ad.broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8628FE4E7912BF47A96AE7DD7BAC0AADCB25AE17C2@SJEXCHCCR02.corp.ad.broadcom.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 12536051039499168659
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:26 Fri 26 Jun     , Leo (Hao) Chen wrote:
> Hi,
> 
> As a newcomer to the kernel community, this is our first attempt to submit code to Linux kernel for a new Broadcom SoC (BCMRing) support.  The patches can be applied to the latest mainline git tree.
> 
> This batch of submission contains only the core arch code and mtd nand driver. We use AMBA serial driver.
> It boots to busybox with serial console.
> 
> The following is the first patch, adding Kconfig option and modify the Makefile in arch/arm directory.
> 
> Let me know if any questions.
> 
> Thanks,
> 
this normaly go ina 0/6 e-mail
> >From 432df145d3d3d0c6d5d122259b472657d715e55c Mon Sep 17 00:00:00 2001
> From: Leo Chen <leochen@broadcom.com>
> Date: Fri, 26 Jun 2009 15:45:10 -0700
> Subject: [PATCH 1/6] add bcmring Kconfig option and modify the Makefile
> 
> ---
>  arch/arm/Kconfig  |   14 ++++++++++++++
>  arch/arm/Makefile |    1 +
>  2 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> index aef63c8..c6d2b19 100644
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@ -637,6 +637,18 @@ config ARCH_OMAP
>  	help
>  	  Support for TI's OMAP platform (OMAP1 and OMAP2).
>  
> +config ARCH_BCMRING
> +	bool "Broadcom BCMRING"
> +	depends on MMU
> +	select CPU_V6
> +	select ARM_AMBA
> +	select COMMON_CLKDEV
> +	select GENERIC_TIME
> +	select GENERIC_CLOCKEVENTS
> +	select ARCH_WANT_OPTIONAL_GPIOLIB
> +	help
> +	  Support for Broadcom's BCMRing platform.
> +
>  endchoice
>  
>  source "arch/arm/mach-clps711x/Kconfig"
> @@ -730,6 +742,8 @@ source "arch/arm/mach-u300/Kconfig"
>  
>  source "arch/arm/mach-w90x900/Kconfig"
>  
> +source "arch/arm/mach-bcmring/Kconfig"
> +
>  # Definitions to make life easier
>  config ARCH_ACORN
>  	bool
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index c877d6d..f1a96f5 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -112,6 +112,7 @@ endif
>  # by CONFIG_* macro name.
>  machine-$(CONFIG_ARCH_AAEC2000)		:= aaec2000
>  machine-$(CONFIG_ARCH_AT91)		:= at91
> +machine-$(CONFIG_ARCH_BCMRING)    := bcmring
whitespace please tab for indent

Best Regards,
J.
