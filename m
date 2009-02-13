Return-Path: <linux-kernel-owner+w=401wt.eu-S1760138AbZBMQ12@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760138AbZBMQ12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 11:27:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752872AbZBMQ1U
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 11:27:20 -0500
Received: from gw.goop.org ([64.81.55.164]:57820 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661AbZBMQ1U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 11:27:20 -0500
Message-ID: <49959F66.5090100@goop.org>
Date: Fri, 13 Feb 2009 08:27:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: the arch/x86 maintainers <x86@kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86 headers: remove duplicate pud_large() definition
References: <49935DD8.8010705@goop.org> <20090213120239.GL15679@elte.hu> <20090213121858.GB5483@elte.hu>
In-Reply-To: <20090213121858.GB5483@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>         arch/x86/mach-voyager/voyager_smp.c
>         arch/x86/mm/fault.c
>   

I'm not sure where these two came from.  I certainly didn't touch those 
files; they must have diverged somewhere else along their history.

> and this in kmemcheck:
>
>     Merge branch 'x86/headers' into kmemcheck
>     
>     Conflicts:
>         arch/x86/include/asm/pgtable.h
>     
>     Merged into:
>     
>         arch/x86/include/asm/pgtable_types.h
>     
> Plus the fixlet below.
>
> 	Ingo
>
> ------------------------->
> From 999c7880cc8eeb0cbe6610b8c6d0ab0ec51cd848 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Fri, 13 Feb 2009 13:15:55 +0100
> Subject: [PATCH] x86 headers: remove duplicate pud_large() definition
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/include/asm/pgtable.h |    7 -------
>  1 files changed, 0 insertions(+), 7 deletions(-)
>
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 62024ff..1c097a3 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -387,13 +387,6 @@ static inline unsigned long pages_to_mb(unsigned long npg)
>  #define io_remap_pfn_range(vma, vaddr, pfn, size, prot)	\
>  	remap_pfn_range(vma, vaddr, pfn, size, prot)
>  
> -#if PAGETABLE_LEVELS == 2
> -static inline int pud_large(pud_t pud)
> -{
> -	return 0;
> -}
> -#endif
>   

OK.

    J
