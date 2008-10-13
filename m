Return-Path: <linux-kernel-owner+w=401wt.eu-S1757085AbYJMSFQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757085AbYJMSFQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:05:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755750AbYJMSE6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:04:58 -0400
Received: from mail.gmx.net ([213.165.64.20]:56582 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755551AbYJMSE5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:04:57 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX18CWZkg3cwCUYMqTPZB+6T6guRLnJT5uIuRhSKkl2
	bDwzTHr1YU2qU2
Date: Mon, 13 Oct 2008 20:05:09 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc: enable heap randomization for linkstations
In-Reply-To: <20081013045116.GA11637@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0810132003350.9041@axis700.grange>
References: <20081013040703.GA11059@ime.usp.br> <20081013045116.GA11637@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Rogério Brito wrote:

> The current defconfig for Linkstation/Kuroboxes has the "Disable Heap
> Randomization" option enabled.
> 
> Since some of these machines are facing the internet, it helps to have
> heap randomization enabled. This patch enables it.

Same as the previous patch - this is one of options, that users select 
according to their needs. If any specific distribution enables this option 
by default in their kernels, they can do this too, don't think this is 
critical enough to patch the defconfig.

Thanks
Guennadi

> 
> 
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> 
> ---
> 
> --- linux/arch/powerpc/configs/linkstation_defconfig.old	2008-10-13 00:33:00.000000000 -0300
> +++ linux/arch/powerpc/configs/linkstation_defconfig	2008-10-13 01:11:28.000000000 -0300
> @@ -1,7 +1,7 @@
>  #
>  # Automatically generated make config: don't edit
> -# Linux kernel version: 2.6.27-rc4
> -# Thu Aug 21 00:52:05 2008
> +# Linux kernel version: 2.6.27
> +# Mon Oct 13 01:11:21 2008
>  #
>  # CONFIG_PPC64 is not set
>  
> @@ -101,7 +101,7 @@ CONFIG_HOTPLUG=y
>  CONFIG_PRINTK=y
>  CONFIG_BUG=y
>  CONFIG_ELF_CORE=y
> -CONFIG_COMPAT_BRK=y
> +# CONFIG_COMPAT_BRK is not set
>  CONFIG_BASE_FULL=y
>  CONFIG_FUTEX=y
>  CONFIG_ANON_INODES=y
> @@ -1211,7 +1211,6 @@ CONFIG_USB_STORAGE=m
>  # CONFIG_USB_STORAGE_ALAUDA is not set
>  # CONFIG_USB_STORAGE_ONETOUCH is not set
>  # CONFIG_USB_STORAGE_KARMA is not set
> -# CONFIG_USB_STORAGE_SIERRA is not set
>  # CONFIG_USB_STORAGE_CYPRESS_ATACB is not set
>  # CONFIG_USB_LIBUSUAL is not set
>  
> 
> -- 
> Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
> http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
> Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@ozlabs.org
> https://ozlabs.org/mailman/listinfo/linuxppc-dev
> 

---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
