Return-Path: <linux-kernel-owner+w=401wt.eu-S1758219AbXJKI0l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758219AbXJKI0l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2007 04:26:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756275AbXJKI0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Oct 2007 04:26:34 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:51623 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755418AbXJKI0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2007 04:26:33 -0400
Date: Thu, 11 Oct 2007 01:26:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RESEND] i386 and x86_64: randomize brk()
Message-Id: <20071011012628.7c5ebe12.akpm@linux-foundation.org>
In-Reply-To: <20071011011800.0c051792.akpm@linux-foundation.org>
References: <Pine.LNX.4.64.0709111416390.7343@jikos.suse.cz>
	<20071011011800.0c051792.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Oct 2007 01:18:00 -0700 Andrew Morton <akpm@linux-foundation.org> wrote:

> Anyway, I'm presently running with this loveliness:
> 
> 
> --- a/include/asm-ia64/elf.h~i386-and-x86_64-randomize-brk-2-fix
> +++ a/include/asm-ia64/elf.h
> @@ -249,8 +249,10 @@ do {									\
>  
>  #endif /* __KERNEL__ */
>  
> +#endif /* _ASM_IA64_ELF_H */
> +
> +#ifndef IA64_IS_WEIRD
>  static inline void arch_randomize_brk(void)
>  {
>  }
> -
> -#endif /* _ASM_IA64_ELF_H */
> +#endif

err, with the obvious `#define IA64_IS_WEIRD' in there..
