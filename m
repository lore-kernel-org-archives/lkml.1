Return-Path: <linux-kernel-owner+w=401wt.eu-S1756698AbXJ2OBd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756698AbXJ2OBd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2007 10:01:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753191AbXJ2OB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Oct 2007 10:01:26 -0400
Received: from www.tglx.de ([62.245.132.106]:46725 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880AbXJ2OBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2007 10:01:25 -0400
Date: Mon, 29 Oct 2007 15:01:09 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Bunk <bunk@kernel.org>
cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] x86: merge EARLY_PRINTK options
In-Reply-To: <20071029124936.GL7227@stusta.de>
Message-ID: <alpine.LFD.0.9999.0710291500510.3186@localhost.localdomain>
References: <20071029124936.GL7227@stusta.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Oct 2007, Adrian Bunk wrote:

> This patch merges the x86_64 EARLY_PRINTK option into the i386 one.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>

Applied, thanks

	 tglx
 
> ---
> 
>  arch/x86/Kconfig.debug  |    3 +--
>  arch/x86/Kconfig.x86_64 |    4 ----
>  2 files changed, 1 insertion(+), 6 deletions(-)
> 
> 9ac736d36f60cbfe4343f51b0f776e2068ceebe4 
> diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
> index a2fa37d..3de185a 100644
> --- a/arch/x86/Kconfig.debug
> +++ b/arch/x86/Kconfig.debug
> @@ -6,9 +6,8 @@ config TRACE_IRQFLAGS_SUPPORT
>  source "lib/Kconfig.debug"
>  
>  config EARLY_PRINTK
> -	bool "Early printk" if EMBEDDED && DEBUG_KERNEL
> +	bool "Early printk" if EMBEDDED && DEBUG_KERNEL && X86_32
>  	default y
> -	depends on X86_32
>  	help
>  	  Write kernel log output directly into the VGA buffer or to a serial
>  	  port.
> diff --git a/arch/x86/Kconfig.x86_64 b/arch/x86/Kconfig.x86_64
> index e2542e5..04b8095 100644
> --- a/arch/x86/Kconfig.x86_64
> +++ b/arch/x86/Kconfig.x86_64
> @@ -97,10 +97,6 @@ config X86_CMPXCHG
>  	bool
>  	default y
>  
> -config EARLY_PRINTK
> -	bool
> -	default y
> -
>  config GENERIC_ISA_DMA
>  	bool
>  	default y
> 
