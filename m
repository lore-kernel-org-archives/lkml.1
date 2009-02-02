Return-Path: <linux-kernel-owner+w=401wt.eu-S1757947AbZBBSxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757947AbZBBSxa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 13:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753331AbZBBSxU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 13:53:20 -0500
Received: from hera.kernel.org ([140.211.167.34]:57246 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752552AbZBBSxU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 13:53:20 -0500
Subject: Re: [PATCH 01/15] ide: include <asm/ide.h> only when needed
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20090201174916.19144.11318.sendpatchset@localhost.localdomain>
References: <20090201174909.19144.67767.sendpatchset@localhost.localdomain>
	 <20090201174916.19144.11318.sendpatchset@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 03 Feb 2009 00:23:04 +0530
Message-Id: <1233600784.13904.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 (2.24.3-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-02-01 at 18:49 +0100, Bartlomiej Zolnierkiewicz wrote:
> From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> Subject: [PATCH] ide: include <asm/ide.h> only when needed
> 
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
>  drivers/ide/ide-io-std.c |    7 +++++++
>  drivers/ide/tx4938ide.c  |    2 ++
>  drivers/ide/tx4939ide.c  |    2 ++
>  include/linux/ide.h      |    7 -------
>  4 files changed, 11 insertions(+), 7 deletions(-)
> 
> Index: b/include/linux/ide.h
> ===================================================================
> --- a/include/linux/ide.h
> +++ b/include/linux/ide.h
> @@ -193,13 +193,6 @@ static inline void ide_std_init_ports(hw
>  	hw->io_ports.ctl_addr = ctl_addr;
>  }
>  
> -#if defined(CONFIG_ARM) || defined(CONFIG_M68K) || defined(CONFIG_MIPS) || \
> -    defined(CONFIG_PARISC) || defined(CONFIG_PPC) || defined(CONFIG_SPARC)
> -#include <asm/ide.h>
> -#else
> -#include <asm-generic/ide_iops.h>
> -#endif
> -
>  #define MAX_HWIFS	10
>  


What is the point of removing <asm/ide.h> from <linux/ide.h>

--
JSR

