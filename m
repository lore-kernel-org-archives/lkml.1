Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYJQJoQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYJQJoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2008 05:44:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYJQJn7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Oct 2008 05:43:59 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:53558 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752671AbYJQJn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2008 05:43:59 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Oct 2008 05:43:58 EDT
Date: Fri, 17 Oct 2008 07:37:15 -0200
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: linux-kernel@vger.kernel.org
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, paulus@samba.org
Subject: Re: [PATCH] powerpc: compile kernel for linkstations optimized for size
Message-ID: <20081017093715.GA26103@ime.usp.br>
References: <20081013040703.GA11059@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20081013040703.GA11059@ime.usp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

It's been some days since I sent the patch below. I would appreciate if any
feedback was given.


Thanks, Rogério Brito.

On Oct 13 2008, Rogério Brito wrote:
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

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
