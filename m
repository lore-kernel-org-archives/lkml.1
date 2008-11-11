Return-Path: <linux-kernel-owner+w=401wt.eu-S1755470AbYKKIlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470AbYKKIlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2008 03:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754349AbYKKIlJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Nov 2008 03:41:09 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:54012 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982AbYKKIlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2008 03:41:09 -0500
Date: Tue, 11 Nov 2008 09:41:04 +0100
From: Pavel Machek <pavel@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: Make NUMA on 32-bit depend on BROKEN
Message-ID: <20081111084104.GA19994@atrey.karlin.mff.cuni.cz>
References: <200811102152.47901.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200811102152.47901.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: x86: Make NUMA on 32-bit depend on BROKEN
> 
> While investigating the failure of hibernation on 32-bit x86 with
> CONFIG_NUMA set, as described in this message
> http://marc.info/?l=linux-kernel&m=122634118116226&w=4
> I asked some people for help and I was told that it wasn't really
> worth the effort, because CONFIG_NUMA was generally broken on 32-bit
> x86 systems and it shouldn't be used in such configs.  For this
> reason, make CONFIG_NUMA depend on BROKEN instead of EXPERIMENTAL on
> x86-32.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> Cc: Andi Kleen <andi@firstfloor.org>
> Cc: Pavel Machek <pavel@suse.cz>

ACK.

> Cc: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/x86/Kconfig
> ===================================================================
> --- linux-2.6.orig/arch/x86/Kconfig
> +++ linux-2.6/arch/x86/Kconfig
> @@ -957,7 +957,7 @@ config ARCH_PHYS_ADDR_T_64BIT
>  config NUMA
>  	bool "Numa Memory Allocation and Scheduler Support (EXPERIMENTAL)"
>  	depends on SMP
> -	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && EXPERIMENTAL)
> +	depends on X86_64 || (X86_32 && HIGHMEM64G && (X86_NUMAQ || X86_BIGSMP || X86_SUMMIT && ACPI) && BROKEN)
>  	default n if X86_PC
>  	default y if (X86_NUMAQ || X86_SUMMIT || X86_BIGSMP)
>  	help

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
