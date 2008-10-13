Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYJMSDZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYJMSDZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 14:03:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755346AbYJMSDP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 14:03:15 -0400
Received: from mail.gmx.net ([213.165.64.20]:36342 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755329AbYJMSDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 14:03:14 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1/uHaEXVSPuHVRkp/pc/zHFmOMlVmaIHtETL6Vz1Z
	+pZjhnYUAsj0rO
Date: Mon, 13 Oct 2008 20:03:25 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] powerpc: compile kernel for linkstations optimized for
 size
In-Reply-To: <20081013040703.GA11059@ime.usp.br>
Message-ID: <Pine.LNX.4.64.0810131959140.9041@axis700.grange>
References: <20081013040703.GA11059@ime.usp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.48
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Oct 2008, Rogério Brito wrote:

> From: Rogério Brito <rbrito@ime.usp.br>
> 
> Since Linkstations and Kuroboxes often have *very* little memory (as
> they are embedded systems), it is desirable to get their kernels
> compiled optimized for size.
> 
> Signed-off-by: Rogério Brito <rbrito@ime.usp.br>
> 
> ---
> 
> I have been using kernels optimized for size on my Kurobox (standard)
> for many different releases and I have experienced no problem with this
> option enabled. Thus, this patch.

The comment for this option says: "watch out for broken compilers," if 
this doesn't hold any more, it should be remove, if it still holds, I 
wouldn't turn this on by default, as I don't think we can test all 
possible (cross- or native-) compilers users might want to use. In any 
case this is one of options that users can select themselves, if it suits 
them. Also I don't think your CC list is correct, you wanted to send this 
to the powerpc list and one of powerpc / subarch maintainer.

Thanks
Guennadi

> 
> --- linux/arch/powerpc/configs/linkstation_defconfig.old	2008-10-13 00:33:00.000000000 -0300
> +++ linux/arch/powerpc/configs/linkstation_defconfig	2008-10-13 00:38:58.000000000 -0300
> @@ -90,7 +90,7 @@ CONFIG_NAMESPACES=y
>  # CONFIG_PID_NS is not set
>  CONFIG_BLK_DEV_INITRD=y
>  CONFIG_INITRAMFS_SOURCE=""
> -# CONFIG_CC_OPTIMIZE_FOR_SIZE is not set
> +CONFIG_CC_OPTIMIZE_FOR_SIZE=y
>  CONFIG_SYSCTL=y
>  # CONFIG_EMBEDDED is not set
>  CONFIG_SYSCTL_SYSCALL=y
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
