Return-Path: <linux-kernel-owner+w=401wt.eu-S1764898AbYD3Uqg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764898AbYD3Uqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2008 16:46:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933246AbYD3UqW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 Apr 2008 16:46:22 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:55238 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933141AbYD3UqU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2008 16:46:20 -0400
Date: Wed, 30 Apr 2008 23:45:36 +0300
From: Adrian Bunk <bunk@kernel.org>
To: David Howells <dhowells@redhat.com>
Cc: Harvey Harrison <harvey.harrison@gmail.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] fix arch/frv/mm/unaligned.o build error
Message-ID: <20080430204536.GJ29330@cs181133002.pp.htv.fi>
References: <1209514311.24729.34.camel@brick> <20080429235740.GC15987@cs181133002.pp.htv.fi> <20699.1209552001@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20699.1209552001@redhat.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 30, 2008 at 11:40:01AM +0100, David Howells wrote:
> 
> Please use this patch instead.  I believe I sent it to you previously.

You sent it to Harvey (from whom the unaligned patches are) two weeks ago.

Sorry, I didn't search for that old patches before making my patch.

> David
> ---
> [PATCH] FRV: Unbreak misalignment handling changes
> 
> From: David Howells <dhowells@redhat.com>
> 
> Fix a reference in a arch/frv/mm/Makefile to unaligned.c which has now been
> deleted.
> 
> Also revert the change to the guard macro name in include/asm-frv/unaligned.h.
> 
> Signed-off-by: David Howells <dhowells@redhat.com>
> ---
> 
>  arch/frv/mm/Makefile        |    2 +-
>  include/asm-frv/unaligned.h |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> 
> diff --git a/arch/frv/mm/Makefile b/arch/frv/mm/Makefile
> index fb8b1d8..1bca5ab 100644
> --- a/arch/frv/mm/Makefile
> +++ b/arch/frv/mm/Makefile
> @@ -6,4 +6,4 @@ obj-y := init.o kmap.o
>  
>  obj-$(CONFIG_MMU) += \
>  	pgalloc.o highmem.o fault.o extable.o cache-page.o tlb-flush.o tlb-miss.o \
> -	mmu-context.o dma-alloc.o unaligned.o elf-fdpic.o
> +	mmu-context.o dma-alloc.o elf-fdpic.o
> diff --git a/include/asm-frv/unaligned.h b/include/asm-frv/unaligned.h
> index 64ccc73..839a2fb 100644
> --- a/include/asm-frv/unaligned.h
> +++ b/include/asm-frv/unaligned.h
> @@ -9,8 +9,8 @@
>   * 2 of the License, or (at your option) any later version.
>   */
>  
> -#ifndef _ASM_FRV_UNALIGNED_H
> -#define _ASM_FRV_UNALIGNED_H
> +#ifndef _ASM_UNALIGNED_H
> +#define _ASM_UNALIGNED_H
>  
>  #include <linux/unaligned/le_byteshift.h>
>  #include <linux/unaligned/be_byteshift.h>
> @@ -19,4 +19,4 @@
>  #define get_unaligned	__get_unaligned_be
>  #define put_unaligned	__put_unaligned_be
>  
> -#endif /* _ASM_FRV_UNALIGNED_H */
> +#endif /* _ASM_UNALIGNED_H */

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

