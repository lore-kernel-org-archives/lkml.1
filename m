Return-Path: <linux-kernel-owner+w=401wt.eu-S1754960AbYECVG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754960AbYECVG5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 17:06:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753012AbYECVGt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 17:06:49 -0400
Received: from www.tglx.de ([62.245.132.106]:48294 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752875AbYECVGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 17:06:48 -0400
Date: Sat, 3 May 2008 23:06:24 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Cyrill Gorcunov <gorcunov@gmail.com>
cc: akpm@linux-foundation.org, hpa@zytor.com, mingo@elte.hu,
       ralf@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 1/4] x86: vdso ELF handling - use SELFMAG instead of
 numeric constant
In-Reply-To: <481c3f58.0c58560a.0fd6.ffff9d33@mx.google.com>
Message-ID: <alpine.LFD.1.10.0805032304150.6003@apollo.tec.linutronix.de>
References: <20080503101800.417039810@gmail.com>> <481c3f58.0c58560a.0fd6.ffff9d33@mx.google.com>
User-Agent: Alpine 1.10 (LFD 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 3 May 2008, Cyrill Gorcunov wrote:
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>
> ---
> 
> Index: linux-2.6.git/arch/x86/vdso/vdso32-setup.c
> ===================================================================
> --- linux-2.6.git.orig/arch/x86/vdso/vdso32-setup.c	2008-05-01 11:07:57.000000000 +0400
> +++ linux-2.6.git/arch/x86/vdso/vdso32-setup.c	2008-05-02 21:25:10.000000000 +0400
> @@ -162,7 +162,7 @@ static __init void relocate_vdso(Elf32_E
>  	Elf32_Shdr *shdr;
>  	int i;
>  
> -	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, 4) != 0 ||
> +	BUG_ON(memcmp(ehdr->e_ident, ELFMAG, SELFMAG) != 0 ||
>  	       !elf_check_arch_ia32(ehdr) ||
>  	       ehdr->e_type != ET_DYN);

Applied. Thanks,

	 tglx
