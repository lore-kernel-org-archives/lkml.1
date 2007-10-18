Return-Path: <linux-kernel-owner+w=401wt.eu-S1764558AbXJRQms@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764558AbXJRQms (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 12:42:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbXJRQml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 12:42:41 -0400
Received: from www.tglx.de ([62.245.132.106]:59427 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373AbXJRQmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 12:42:40 -0400
Date: Thu, 18 Oct 2007 18:42:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Adrian Knoth <adi@drcomp.erfurt.thur.de>
cc: zippel@linux-m68.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Kconfig: Missing line breaks in arch/x86_64/Kconfig
In-Reply-To: <20071018145857.GI2154@ltw.loris.tv>
Message-ID: <alpine.LFD.0.9999.0710181841590.20161@localhost.localdomain>
References: <20071018145857.GI2154@ltw.loris.tv>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2007, Adrian Knoth wrote:
> From: Adrian Knoth <adi@drcomp.erfurt.thur.de>
> 
> The helptext for IA32_EMULATION in arch/x86_64/Kconfig is wider than 80
> chars, thus failing to be displayed in 80x24 screens.
> 
> This patch re-breaks lines.
> 
> 
> Signed-off-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
> ---
> 
> 
> --- linux-2.6.23.1/arch/x86_64/Kconfig	2007-10-15 22:36:02.000000000 +0200
> +++ /home/adi/Kconfig-new	2007-10-18 12:17:42.000000000 +0200
> @@ -742,9 +742,9 @@
>  config IA32_EMULATION
>  	bool "IA32 Emulation"
>  	help
> -	  Include code to run 32-bit programs under a 64-bit kernel. You should likely
> -	  turn this on, unless you're 100% sure that you don't have any 32-bit programs
> -	  left.
> +	  Include code to run 32-bit programs under a 64-bit kernel. You should
> +	  likely turn this on, unless you're 100% sure that you don't have any
> +	  32-bit programs left.
>  
>  config IA32_AOUT
>         tristate "IA32 a.out support"

Thanks, applied.

	tglx
