Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab0BWPDc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 10:03:32 -0500
Received: from mailgw10.se.ericsson.net ([193.180.251.61]:50816 "EHLO
	mailgw10.se.ericsson.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0BWPD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 10:03:29 -0500
X-AuditID: c1b4fb3d-b7c72ae00000040e-01-4b83ee3fc938
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH] ARM: misplaced parentheses?
Date: Tue, 23 Feb 2010 16:03:27 +0100
Message-ID: <A6D19A13FE030A409EC4362C172E091F0E935FDB@eseldmw101.eemea.ericsson.se>
In-Reply-To: <4B7F2AA8.3010302@gmail.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] ARM: misplaced parentheses?
Thread-Index: AcqxwVZh9a+r/qJVTzKWlbBkzaNfIwC18i2A
References: <4B7F2AA8.3010302@gmail.com>
From: "Linus Walleij" <linus.walleij@stericsson.com>
To: "Roel Kluin" <roel.kluin@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "LKML" <linux-kernel@vger.kernel.org>
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
X-OriginalArrivalTime: 23 Feb 2010 15:03:26.0750 (UTC) FILETIME=[5A1063E0:01CAB499]
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Roel]

> The parentheses appear misplaced.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Correct?
> 
> diff --git a/arch/arm/mach-u300/gpio.c b/arch/arm/mach-u300/gpio.c
> index 0b35826..5f61fd4 100644
> --- a/arch/arm/mach-u300/gpio.c
> +++ b/arch/arm/mach-u300/gpio.c
> @@ -546,7 +546,7 @@ static void gpio_set_initial_values(void)
>  	for (i = 0; i < U300_GPIO_MAX; i++) {
>  		val = 0;
>  		for (j = 0; j < 8; j++)
> -			val |= 
> (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP)) << j;
> +			val |= 
> (u32)((u300_gpio_config[i][j].pull_up == DISABLE_PULL_UP) << j);
>  		local_irq_save(flags);
>  		writel(val, virtbase + U300_GPIO_PXPER + i * 
> U300_GPIO_PORTX_SPACING);
>  		local_irq_restore(flags);

Acked-by: Linus Walleij <linus.walleij@stericsson.com>

BTW this should go in through Russells patch tracker, can you
put it there?
http://www.arm.linux.org.uk/developer/patches/

Linus Walleij
