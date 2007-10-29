Return-Path: <linux-kernel-owner+w=401wt.eu-S1757953AbXJ2NIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953AbXJ2NIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 09:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753667AbXJ2NHx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 09:07:53 -0400
Received: from rex.snapgear.com ([203.143.235.140]:48430 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757136AbXJ2NHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 09:07:52 -0400
Message-ID: <4725DB24.8060608@snapgear.com>
Date: Mon, 29 Oct 2007 23:07:48 +1000
From: Greg Ungerer <gerg@snapgear.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Adrian Bunk <bunk@kernel.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] m68knommu: remove duplicate exports
References: <20071029124957.GN7227@stusta.de>
In-Reply-To: <20071029124957.GN7227@stusta.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
> One EXPORT_SYMBOL should be enough for everyone.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Acked-by: Greg Ungerer <gerg@uclinux.org>


> ---
> 
>  arch/m68knommu/kernel/m68k_ksyms.c |   11 -----------
>  1 file changed, 11 deletions(-)
> 
> db7c0d48feac0857d0bc2e79147b63d5f9675077 
> diff --git a/arch/m68knommu/kernel/m68k_ksyms.c b/arch/m68knommu/kernel/m68k_ksyms.c
> index f795062..53fad14 100644
> --- a/arch/m68knommu/kernel/m68k_ksyms.c
> +++ b/arch/m68knommu/kernel/m68k_ksyms.c
> @@ -24,14 +24,6 @@ extern int dump_fpu(struct pt_regs *, elf_fpregset_t *);
>  EXPORT_SYMBOL(__ioremap);
>  EXPORT_SYMBOL(iounmap);
>  EXPORT_SYMBOL(dump_fpu);
> -EXPORT_SYMBOL(strnlen);
> -EXPORT_SYMBOL(strrchr);
> -EXPORT_SYMBOL(strstr);
> -EXPORT_SYMBOL(strchr);
> -EXPORT_SYMBOL(strcat);
> -EXPORT_SYMBOL(strlen);
> -EXPORT_SYMBOL(strcmp);
> -EXPORT_SYMBOL(strncmp);
>  
>  EXPORT_SYMBOL(ip_fast_csum);
>  
> @@ -46,9 +38,6 @@ EXPORT_SYMBOL(csum_partial_copy_nocheck);
>     it's OK to leave it out of version control.  */
>  EXPORT_SYMBOL(memcpy);
>  EXPORT_SYMBOL(memset);
> -EXPORT_SYMBOL(memcmp);
> -EXPORT_SYMBOL(memscan);
> -EXPORT_SYMBOL(memmove);
>  
>  EXPORT_SYMBOL(__down_failed);
>  EXPORT_SYMBOL(__down_failed_interruptible);
> 
> 


-- 
------------------------------------------------------------------------
Greg Ungerer  --  Chief Software Dude       EMAIL:     gerg@snapgear.com
SnapGear -- a Secure Computing Company      PHONE:       +61 7 3435 2888
825 Stanley St,                             FAX:         +61 7 3891 3630
Woolloongabba, QLD, 4102, Australia         WEB: http://www.SnapGear.com
