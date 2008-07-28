Return-Path: <linux-kernel-owner+w=401wt.eu-S1760249AbYG1SIf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760249AbYG1SIf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 14:08:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754006AbYG1SIH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 14:08:07 -0400
Received: from smtp117.sbc.mail.sp1.yahoo.com ([69.147.64.90]:41854 "HELO
	smtp117.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754902AbYG1SIE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 14:08:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=vLZUxpE79fOYyEB6QtDv+b+pbiHoDXZUfpftxLgXSdNgmZ8SJd8NCHlK9c6xA4txdMtT4ItqZZ+FB6sJ3W7V7OcFGDp+7i84J3GJK5LEkQGbgN7T5+OogCfGggWaQ4aVziGQFBli5TEyn54OyNJlLnMS8dncA4HxD304AirZ+sU=  ;
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Atsushi Nemoto <anemo@mba.ocn.ne.jp>
Subject: Re: [PATCH] gpio: Fix build on CONFIG_GPIO_SYSFS=n
Date: Mon, 28 Jul 2008 11:03:54 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
References: <20080729.001612.79297475.anemo@mba.ocn.ne.jp>
In-Reply-To: <20080729.001612.79297475.anemo@mba.ocn.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200807281103.55129.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 July 2008, Atsushi Nemoto wrote:
> If CONFIG_GENERIC_GPIO=y && CONFIG_GPIO_SYSFS=n, gpio_export() in
> asm-generic/gpio.h refers -ENOSYS and causes build error.
> 
> Signed-off-by: Atsushi Nemoto <anemo@mba.ocn.ne.jp>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>


> ---
> diff --git a/include/asm-generic/gpio.h b/include/asm-generic/gpio.h
> index c764a8f..0f99ad3 100644
> --- a/include/asm-generic/gpio.h
> +++ b/include/asm-generic/gpio.h
> @@ -2,6 +2,7 @@
>  #define _ASM_GENERIC_GPIO_H
>  
>  #include <linux/types.h>
> +#include <linux/errno.h>
>  
>  #ifdef CONFIG_GPIOLIB
>  
> 


