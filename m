Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750966Ab0CAIwR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 03:52:17 -0500
Received: from mail.atmel.fr ([81.80.104.162]:33322 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750717Ab0CAIwQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 03:52:16 -0500
Message-ID: <4B8B802A.1090203@atmel.com>
Date: Mon, 01 Mar 2010 09:51:54 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; fr; rv:1.9.1.8) Gecko/20100216 Thunderbird/3.0.2
MIME-Version: 1.0
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
CC: Russell King <rmk+lkml@arm.linux.org.uk>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: includecheck fix for mach-at91/board-sam9m10g45ek.c
References: <1267260450.26906.9.camel@i7.satnam>
In-Reply-To: <1267260450.26906.9.camel@i7.satnam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 27/02/2010 09:47, Jaswinder Singh Rajput :
> 
> Fix the following 'make includecheck' warning:
>   arch/arm/mach-at91/board-sam9m10g45ek.c: mach/hardware.h is included more than once.
> 
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>
> Cc: Russell King <rmk+kernel@arm.linux.org.uk>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
>  arch/arm/mach-at91/board-sam9m10g45ek.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/arm/mach-at91/board-sam9m10g45ek.c b/arch/arm/mach-at91/board-sam9m10g45ek.c
> index 98f9f4b..f2ba9e2 100644
> --- a/arch/arm/mach-at91/board-sam9m10g45ek.c
> +++ b/arch/arm/mach-at91/board-sam9m10g45ek.c
> @@ -36,7 +36,6 @@
>  #include <asm/mach/map.h>
>  #include <asm/mach/irq.h>
>  
> -#include <mach/hardware.h>
>  #include <mach/board.h>
>  #include <mach/gpio.h>
>  #include <mach/at91sam9_smc.h>


-- 
Nicolas Ferre

