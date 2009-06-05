Return-Path: <linux-kernel-owner+w=401wt.eu-S1755112AbZFEHgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112AbZFEHgn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jun 2009 03:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752502AbZFEHgf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Jun 2009 03:36:35 -0400
Received: from krynn.se.axis.com ([193.13.178.10]:47985 "EHLO
	krynn.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751328AbZFEHgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jun 2009 03:36:33 -0400
Date: Fri, 5 Jun 2009 09:22:57 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
       Mike Frysinger <vapier@gentoo.org>, Richard Henderson <rth@twiddle.net>,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
       Bryan Wu <cooloney@kernel.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Hirokazu Takata <takata@linux-m32r.org>,
       Luck Tony <tony.luck@intel.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Ralf Baechle <ralf@linux-mips.org>, David Howells <dhowells@redhat.com>,
       Kyle McMartin <kyle@mcmartin.ca>,
       Martin Schwidefsky <schwidefsky@de.ibm.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "David S. Miller" <davem@davemloft.net>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2] kmap_types: convert most arches to a single header
	file
Message-ID: <20090605072257.GW27807@axis.com>
References: <4A280BB0.4030805@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A280BB0.4030805@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 04, 2009 at 08:00:16PM +0200, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> Subject: kmap_types: make most arches use generic header file
> 
> Convert most arches (*except frv*) to use asm-generic/kmap_types.h.
> Each arch still has its own kmap_types.h for customization if
> needed (like frv).
> 
> KM_FENCE is now controlled by CONFIG_HIGHMEM.
> 
> Built on x86_64, i386, mips, sparc32, sparc64,
> alpha, powerpc64, ia64, and m68k.
> 
> Note: Removed KM_PTE2 from generic kmap_types.h file; it was defined
> but not used by avr32.

For the CRIS parts:

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: <linux-arch@vger.kernel.org>
> Acked-by: Mike Frysinger <vapier@gentoo.org>
> Cc: Richard Henderson <rth@twiddle.net>
> Cc: Ivan Kokshaysky <ink@jurassic.park.msu.ru>
> Cc: Bryan Wu <cooloney@kernel.org>
> Cc: Mikael Starvik <starvik@axis.com>
> Cc: Hirokazu Takata <takata@linux-m32r.org>
> Cc: "Luck Tony" <tony.luck@intel.com>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Kyle McMartin <kyle@mcmartin.ca>
> Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: "H. Peter Anvin" <hpa@zytor.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/alpha/include/asm/kmap_types.h      |   26 -------------------------
>  arch/arm/include/asm/kmap_types.h        |   21 --------------------
>  arch/arm/mm/cache-feroceon-l2.c          |    2 -
>  arch/arm/mm/cache-xsc3l2.c               |    2 -
>  arch/avr32/include/asm/kmap_types.h      |   26 -------------------------
>  arch/blackfin/include/asm/kmap_types.h   |   17 ----------------
>  arch/cris/include/asm/kmap_types.h       |   17 ----------------
>  arch/h8300/include/asm/kmap_types.h      |   17 ----------------
>  arch/ia64/include/asm/kmap_types.h       |   26 -------------------------
>  arch/m32r/include/asm/kmap_types.h       |   25 ------------------------
>  arch/m68k/include/asm/kmap_types.h       |   17 ----------------
>  arch/microblaze/include/asm/kmap_types.h |   25 ------------------------
>  arch/mips/include/asm/kmap_types.h       |   26 -------------------------
>  arch/mn10300/include/asm/kmap_types.h    |   27 --------------------------
>  arch/parisc/include/asm/kmap_types.h     |   26 -------------------------
>  arch/powerpc/include/asm/kmap_types.h    |   26 -------------------------
>  arch/powerpc/mm/dma-noncoherent.c        |    4 +--
>  arch/powerpc/mm/mem.c                    |    4 +--
>  arch/s390/include/asm/kmap_types.h       |   17 ----------------
>  arch/sh/include/asm/kmap_types.h         |   26 -------------------------
>  arch/sparc/include/asm/kmap_types.h      |   17 ----------------
>  arch/um/include/asm/kmap_types.h         |   25 ------------------------
>  arch/x86/include/asm/kmap_types.h        |   25 ------------------------
>  arch/xtensa/include/asm/kmap_types.h     |   27 --------------------------
>  include/asm-generic/kmap_types.h         |   32 +++++++++++++++++++++++++++++++
>  25 files changed, 58 insertions(+), 445 deletions(-)
> 
> --- lnx-2630-rc8-kmaptypes.orig/arch/alpha/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/alpha/include/asm/kmap_types.h
> @@ -3,30 +3,6 @@
> 
>  /* Dummy header just to define km_type. */
> 
> -
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/arm/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/arm/include/asm/kmap_types.h
> @@ -1,25 +1,6 @@
>  #ifndef __ARM_KMAP_TYPES_H
>  #define __ARM_KMAP_TYPES_H
> 
> -/*
> - * This is the "bare minimum".  AIO seems to require this.
> - */
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_L2_CACHE,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/arm/mm/cache-feroceon-l2.c
> +++ lnx-2630-rc8-kmaptypes/arch/arm/mm/cache-feroceon-l2.c
> @@ -50,7 +50,7 @@ static inline unsigned long l2_start_va(
>          * memory mapping.  This is protected with the disabling of
>          * interrupts by the caller.
>          */
> -       unsigned long idx = KM_L2_CACHE + KM_TYPE_NR * smp_processor_id();
> +       unsigned long idx = KM_SYNC_ICACHE + KM_TYPE_NR * smp_processor_id();
>         unsigned long vaddr = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>         set_pte_ext(TOP_PTE(vaddr), pfn_pte(paddr >> PAGE_SHIFT, PAGE_KERNEL), 0);
>         local_flush_tlb_kernel_page(vaddr);
> --- lnx-2630-rc8-kmaptypes.orig/arch/arm/mm/cache-xsc3l2.c
> +++ lnx-2630-rc8-kmaptypes/arch/arm/mm/cache-xsc3l2.c
> @@ -95,7 +95,7 @@ static inline unsigned long l2_map_va(un
>                  */
>                 unsigned long idx;
>                 raw_local_irq_restore(flags);
> -               idx = KM_L2_CACHE + KM_TYPE_NR * smp_processor_id();
> +               idx = KM_SYNC_ICACHE + KM_TYPE_NR * smp_processor_id();
>                 va = __fix_to_virt(FIX_KMAP_BEGIN + idx);
>                 raw_local_irq_restore(flags | PSR_I_BIT);
>                 set_pte_ext(TOP_PTE(va), pfn_pte(pa >> PAGE_SHIFT, PAGE_KERNEL), 0);
> --- lnx-2630-rc8-kmaptypes.orig/arch/avr32/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/avr32/include/asm/kmap_types.h
> @@ -1,30 +1,6 @@
>  #ifndef __ASM_AVR32_KMAP_TYPES_H
>  #define __ASM_AVR32_KMAP_TYPES_H
> 
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_PTE2,
> -D(10)  KM_IRQ0,
> -D(11)  KM_IRQ1,
> -D(12)  KM_SOFTIRQ0,
> -D(13)  KM_SOFTIRQ1,
> -D(14)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* __ASM_AVR32_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/blackfin/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/blackfin/include/asm/kmap_types.h
> @@ -1,21 +1,6 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/cris/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/cris/include/asm/kmap_types.h
> @@ -5,21 +5,6 @@
>   * is actually used on cris.
>   */
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/h8300/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/h8300/include/asm/kmap_types.h
> @@ -1,21 +1,6 @@
>  #ifndef _ASM_H8300_KMAP_TYPES_H
>  #define _ASM_H8300_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/ia64/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/ia64/include/asm/kmap_types.h
> @@ -1,30 +1,6 @@
>  #ifndef _ASM_IA64_KMAP_TYPES_H
>  #define _ASM_IA64_KMAP_TYPES_H
> 
> -
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* _ASM_IA64_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/m32r/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/m32r/include/asm/kmap_types.h
> @@ -1,29 +1,6 @@
>  #ifndef __M32R_KMAP_TYPES_H
>  #define __M32R_KMAP_TYPES_H
> 
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* __M32R_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/m68k/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/m68k/include/asm/kmap_types.h
> @@ -1,21 +1,6 @@
>  #ifndef __ASM_M68K_KMAP_TYPES_H
>  #define __ASM_M68K_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* __ASM_M68K_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/microblaze/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/microblaze/include/asm/kmap_types.h
> @@ -1,29 +1,6 @@
> -/*
> - * Copyright (C) 2006 Atmark Techno, Inc.
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License. See the file "COPYING" in the main directory of this archive
> - * for more details.
> - */
> -
>  #ifndef _ASM_MICROBLAZE_KMAP_TYPES_H
>  #define _ASM_MICROBLAZE_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR,
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* _ASM_MICROBLAZE_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/mips/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/mips/include/asm/kmap_types.h
> @@ -1,30 +1,6 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
> 
> -
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/mn10300/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/mn10300/include/asm/kmap_types.h
> @@ -1,31 +1,6 @@
> -/* MN10300 kmap_atomic() slot IDs
> - *
> - * Copyright (C) 2007 Red Hat, Inc. All Rights Reserved.
> - * Written by David Howells (dhowells@redhat.com)
> - *
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public Licence
> - * as published by the Free Software Foundation; either version
> - * 2 of the Licence, or (at your option) any later version.
> - */
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* _ASM_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/parisc/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/parisc/include/asm/kmap_types.h
> @@ -1,30 +1,6 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
> 
> -
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/powerpc/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/powerpc/include/asm/kmap_types.h
> @@ -3,31 +3,7 @@
> 
>  #ifdef __KERNEL__
> 
> -/*
> - * This program is free software; you can redistribute it and/or
> - * modify it under the terms of the GNU General Public License
> - * as published by the Free Software Foundation; either version
> - * 2 of the License, or (at your option) any later version.
> - */
> -
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_PPC_SYNC_PAGE,
> -       KM_PPC_SYNC_ICACHE,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* __KERNEL__ */
>  #endif /* _ASM_POWERPC_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/powerpc/mm/dma-noncoherent.c
> +++ lnx-2630-rc8-kmaptypes/arch/powerpc/mm/dma-noncoherent.c
> @@ -364,11 +364,11 @@ static inline void __dma_sync_page_highm
> 
>         do {
>                 start = (unsigned long)kmap_atomic(page + seg_nr,
> -                               KM_PPC_SYNC_PAGE) + seg_offset;
> +                               KM_SYNC_DCACHE) + seg_offset;
> 
>                 /* Sync this buffer segment */
>                 __dma_sync((void *)start, seg_size, direction);
> -               kunmap_atomic((void *)start, KM_PPC_SYNC_PAGE);
> +               kunmap_atomic((void *)start, KM_SYNC_DACHE);
>                 seg_nr++;
> 
>                 /* Calculate next buffer segment size */
> --- lnx-2630-rc8-kmaptypes.orig/arch/powerpc/mm/mem.c
> +++ lnx-2630-rc8-kmaptypes/arch/powerpc/mm/mem.c
> @@ -418,9 +418,9 @@ EXPORT_SYMBOL(flush_dcache_page);
>  void flush_dcache_icache_page(struct page *page)
>  {
>  #ifdef CONFIG_BOOKE
> -       void *start = kmap_atomic(page, KM_PPC_SYNC_ICACHE);
> +       void *start = kmap_atomic(page, KM_SYNC_ICACHE);
>         __flush_dcache_icache(start);
> -       kunmap_atomic(start, KM_PPC_SYNC_ICACHE);
> +       kunmap_atomic(start, KM_SYNC_ICACHE);
>  #elif defined(CONFIG_8xx) || defined(CONFIG_PPC64)
>         /* On 8xx there is no need to kmap since highmem is not supported */
>         __flush_dcache_icache(page_address(page));
> --- lnx-2630-rc8-kmaptypes.orig/arch/s390/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/s390/include/asm/kmap_types.h
> @@ -2,22 +2,7 @@
>  #ifndef _ASM_KMAP_TYPES_H
>  #define _ASM_KMAP_TYPES_H
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
>  #endif /* __KERNEL__ */
> --- lnx-2630-rc8-kmaptypes.orig/arch/sh/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/sh/include/asm/kmap_types.h
> @@ -3,30 +3,6 @@
> 
>  /* Dummy header just to define km_type. */
> 
> -
> -#ifdef CONFIG_DEBUG_HIGHMEM
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/sparc/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/sparc/include/asm/kmap_types.h
> @@ -5,21 +5,6 @@
>   * is actually used on sparc.  -DaveM
>   */
> 
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/um/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/um/include/asm/kmap_types.h
> @@ -1,29 +1,6 @@
> -/*
> - * Copyright (C) 2002 Jeff Dike (jdike@karaya.com)
> - * Licensed under the GPL
> - */
> -
>  #ifndef __UM_KMAP_TYPES_H
>  #define __UM_KMAP_TYPES_H
> 
> -/* No more #include "asm/arch/kmap_types.h" ! */
> -
> -enum km_type {
> -       KM_BOUNCE_READ,
> -       KM_SKB_SUNRPC_DATA,
> -       KM_SKB_DATA_SOFTIRQ,
> -       KM_USER0,
> -       KM_USER1,
> -       KM_UML_USERCOPY,        /* UML specific, for copy_*_user - used in do_op_one_page */
> -       KM_BIO_SRC_IRQ,
> -       KM_BIO_DST_IRQ,
> -       KM_PTE0,
> -       KM_PTE1,
> -       KM_IRQ0,
> -       KM_IRQ1,
> -       KM_SOFTIRQ0,
> -       KM_SOFTIRQ1,
> -       KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif
> --- lnx-2630-rc8-kmaptypes.orig/arch/x86/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/x86/include/asm/kmap_types.h
> @@ -1,29 +1,6 @@
>  #ifndef _ASM_X86_KMAP_TYPES_H
>  #define _ASM_X86_KMAP_TYPES_H
> 
> -#if defined(CONFIG_X86_32) && defined(CONFIG_DEBUG_HIGHMEM)
> -# define D(n) __KM_FENCE_##n ,
> -#else
> -# define D(n)
> -#endif
> -
> -enum km_type {
> -D(0)   KM_BOUNCE_READ,
> -D(1)   KM_SKB_SUNRPC_DATA,
> -D(2)   KM_SKB_DATA_SOFTIRQ,
> -D(3)   KM_USER0,
> -D(4)   KM_USER1,
> -D(5)   KM_BIO_SRC_IRQ,
> -D(6)   KM_BIO_DST_IRQ,
> -D(7)   KM_PTE0,
> -D(8)   KM_PTE1,
> -D(9)   KM_IRQ0,
> -D(10)  KM_IRQ1,
> -D(11)  KM_SOFTIRQ0,
> -D(12)  KM_SOFTIRQ1,
> -D(13)  KM_TYPE_NR
> -};
> -
> -#undef D
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* _ASM_X86_KMAP_TYPES_H */
> --- lnx-2630-rc8-kmaptypes.orig/arch/xtensa/include/asm/kmap_types.h
> +++ lnx-2630-rc8-kmaptypes/arch/xtensa/include/asm/kmap_types.h
> @@ -1,31 +1,6 @@
> -/*
> - * include/asm-xtensa/kmap_types.h
> - *
> - * This file is subject to the terms and conditions of the GNU General Public
> - * License.  See the file "COPYING" in the main directory of this archive
> - * for more details.
> - *
> - * Copyright (C) 2001 - 2005 Tensilica Inc.
> - */
> -
>  #ifndef _XTENSA_KMAP_TYPES_H
>  #define _XTENSA_KMAP_TYPES_H
> 
> -enum km_type {
> -  KM_BOUNCE_READ,
> -  KM_SKB_SUNRPC_DATA,
> -  KM_SKB_DATA_SOFTIRQ,
> -  KM_USER0,
> -  KM_USER1,
> -  KM_BIO_SRC_IRQ,
> -  KM_BIO_DST_IRQ,
> -  KM_PTE0,
> -  KM_PTE1,
> -  KM_IRQ0,
> -  KM_IRQ1,
> -  KM_SOFTIRQ0,
> -  KM_SOFTIRQ1,
> -  KM_TYPE_NR
> -};
> +#include <asm-generic/kmap_types.h>
> 
>  #endif /* _XTENSA_KMAP_TYPES_H */
> --- /dev/null
> +++ lnx-2630-rc8-kmaptypes/include/asm-generic/kmap_types.h
> @@ -0,0 +1,32 @@
> +#ifndef _ASM_GENERIC_KMAP_TYPES_H
> +#define _ASM_GENERIC_KMAP_TYPES_H
> +
> +#ifdef CONFIG_DEBUG_HIGHMEM
> +# define D(n) __KM_FENCE_##n ,
> +#else
> +# define D(n)
> +#endif
> +
> +enum km_type {
> +D(0)   KM_BOUNCE_READ,
> +D(1)   KM_SKB_SUNRPC_DATA,
> +D(2)   KM_SKB_DATA_SOFTIRQ,
> +D(3)   KM_USER0,
> +D(4)   KM_USER1,
> +D(5)   KM_BIO_SRC_IRQ,
> +D(6)   KM_BIO_DST_IRQ,
> +D(7)   KM_PTE0,
> +D(8)   KM_PTE1,
> +D(9)   KM_IRQ0,
> +D(10)  KM_IRQ1,
> +D(11)  KM_SOFTIRQ0,
> +D(12)  KM_SOFTIRQ1,
> +D(13)  KM_SYNC_ICACHE,
> +D(14)  KM_SYNC_DCACHE,
> +D(15)  KM_UML_USERCOPY, /* UML specific, for copy_*_user - used in do_op_one_page */
> +D(16)  KM_TYPE_NR
> +};
> +
> +#undef D
> +
> +#endif

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
