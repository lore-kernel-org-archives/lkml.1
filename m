Return-Path: <linux-kernel-owner+w=401wt.eu-S1752992AbZIZQS7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992AbZIZQS7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 12:18:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752230AbZIZQS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 12:18:58 -0400
Received: from smtp2.ultrahosting.com ([74.213.174.253]:35238 "EHLO
	smtp.ultrahosting.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751952AbZIZQS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 12:18:58 -0400
Date: Sat, 26 Sep 2009 12:14:31 -0400 (EDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@gentwo.org
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>, Ingo Molnar <mingo@elte.hu>,
       linux-mm@kvack.org, x86 maintainers <x86@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: SLUB: Remove unused CONFIG FAST_CMPXCHG_LOCAL
In-Reply-To: <1253981501.4568.61.camel@ht.satnam>
Message-ID: <alpine.DEB.1.10.0909261214040.16276@gentwo.org>
References: <1253981501.4568.61.camel@ht.satnam>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Leftover stuff from a reverted patch.

Acked-by: Christoph Lameter <cl@linux-foundation.org>

On Sat, 26 Sep 2009, Jaswinder Singh Rajput wrote:

>
> Remove unused CONFIG FAST_CMPXCHG_LOCAL from Kconfig and defconfigs
>
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Christoph Lameter <cl@linux-foundation.org>
> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
> Cc: Matt Mackall <mpm@selenic.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/Kconfig                  |    4 ----
>  arch/x86/configs/i386_defconfig   |    1 -
>  arch/x86/configs/x86_64_defconfig |    1 -
>  3 files changed, 0 insertions(+), 6 deletions(-)
>
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 9369879..27ebee4 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -86,10 +86,6 @@ config STACKTRACE_SUPPORT
>  config HAVE_LATENCYTOP_SUPPORT
>  	def_bool y
>
> -config FAST_CMPXCHG_LOCAL
> -	bool
> -	default y
> -
>  config MMU
>  	def_bool y
>
> diff --git a/arch/x86/configs/i386_defconfig b/arch/x86/configs/i386_defconfig
> index d28fad1..fdf15d3 100644
> --- a/arch/x86/configs/i386_defconfig
> +++ b/arch/x86/configs/i386_defconfig
> @@ -17,7 +17,6 @@ CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>  CONFIG_LOCKDEP_SUPPORT=y
>  CONFIG_STACKTRACE_SUPPORT=y
>  CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> -CONFIG_FAST_CMPXCHG_LOCAL=y
>  CONFIG_MMU=y
>  CONFIG_ZONE_DMA=y
>  CONFIG_GENERIC_ISA_DMA=y
> diff --git a/arch/x86/configs/x86_64_defconfig b/arch/x86/configs/x86_64_defconfig
> index 6c86acd..b75aec8 100644
> --- a/arch/x86/configs/x86_64_defconfig
> +++ b/arch/x86/configs/x86_64_defconfig
> @@ -17,7 +17,6 @@ CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
>  CONFIG_LOCKDEP_SUPPORT=y
>  CONFIG_STACKTRACE_SUPPORT=y
>  CONFIG_HAVE_LATENCYTOP_SUPPORT=y
> -CONFIG_FAST_CMPXCHG_LOCAL=y
>  CONFIG_MMU=y
>  CONFIG_ZONE_DMA=y
>  CONFIG_GENERIC_ISA_DMA=y
>
