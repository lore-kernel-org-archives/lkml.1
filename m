Return-Path: <linux-kernel-owner+w=401wt.eu-S1764477AbXJRP4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764477AbXJRP4T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 11:56:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756759AbXJRP4D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 11:56:03 -0400
Received: from pasmtpb.tele.dk ([80.160.77.98]:39294 "EHLO pasmtpB.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbXJRP4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 11:56:01 -0400
Date: Thu, 18 Oct 2007 17:57:32 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adrian Knoth <adi@drcomp.erfurt.thur.de>,
       Thomas Gleixner <tglx@linutronix.de>
Cc: zippel@linux-m68.org, linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Kconfig: Missing line breaks in arch/x86_64/Kconfig
Message-ID: <20071018155732.GB20698@uranus.ravnborg.org>
References: <20071018145857.GI2154@ltw.loris.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20071018145857.GI2154@ltw.loris.tv>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas.

Another one for your tree I think.

	sam

On Thu, Oct 18, 2007 at 04:58:58PM +0200, Adrian Knoth wrote:
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
> 
> 
> 
> -- 
> mail: adi@thur.de  	http://adi.thur.de	PGP/GPG: key via keyserver
> 
> Nur wer die Arbeit kennt, weiß was ich meide
> -
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
