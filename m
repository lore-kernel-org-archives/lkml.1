Return-Path: <linux-kernel-owner+w=401wt.eu-S1754895AbYFYHrE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895AbYFYHrE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 03:47:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYFYHqv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 03:46:51 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56694 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753064AbYFYHqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 03:46:50 -0400
Date: Wed, 25 Jun 2008 08:46:02 +0100
From: Russell King <rmk+lkml@arm.linux.org.uk>
To: Adrian Bunk <bunk@kernel.org>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       cooloney@kernel.org, dev-etrax@axis.com, dhowells@redhat.com,
       gerg@uclinux.org, yasutake.koichi@jp.panasonic.com,
       linux-parisc@vger.kernel.org, paulus@samba.org, linuxppc-dev@ozlabs.org,
       linux-sh@vger.kernel.org, chris@zankel.net, linux-mips@linux-mips.org,
       ysato@users.sourceforge.jp, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [2.6 patch] asm/ptrace.h userspace headers cleanup
Message-ID: <20080625074602.GA14791@flint.arm.linux.org.uk>
References: <20080623174809.GE4756@cs181140183.pp.htv.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080623174809.GE4756@cs181140183.pp.htv.fi>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 08:48:09PM +0300, Adrian Bunk wrote:
> diff --git a/include/asm-arm/ptrace.h b/include/asm-arm/ptrace.h
> index 7aaa206..8382b75 100644
> --- a/include/asm-arm/ptrace.h
> +++ b/include/asm-arm/ptrace.h
> @@ -139,8 +139,6 @@ static inline int valid_user_regs(struct pt_regs *regs)
>  	return 0;
>  }
>  
> -#endif	/* __KERNEL__ */
> -
>  #define pc_pointer(v) \
>  	((v) & ~PCMASK)
>  
> @@ -153,10 +151,10 @@ extern unsigned long profile_pc(struct pt_regs *regs);
>  #define profile_pc(regs) instruction_pointer(regs)
>  #endif
>  
> -#ifdef __KERNEL__
>  #define predicate(x)		((x) & 0xf0000000)
>  #define PREDICATE_ALWAYS	0xe0000000
> -#endif
> +
> +#endif /* __KERNEL__ */
>  
>  #endif /* __ASSEMBLY__ */
>  

Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
