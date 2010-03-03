Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab0CCLRK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Mar 2010 06:17:10 -0500
Received: from av7-1-sn3.vrr.skanova.net ([81.228.9.181]:44975 "EHLO
	av7-1-sn3.vrr.skanova.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab0CCLRJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Mar 2010 06:17:09 -0500
X-Greylist: delayed 1965 seconds by postgrey-1.27 at vger.kernel.org; Wed, 03 Mar 2010 06:17:09 EST
Message-ID: <4B8E3D83.3080809@pelagicore.com>
Date: Wed, 03 Mar 2010 11:44:19 +0100
From: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
Organization: Pelagicore AB
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100121 Iceowl/1.0b1 Icedove/3.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] timbgpio: Fix build.
References: <20100303.015929.79253256.davem@davemloft.net>
In-Reply-To: <20100303.015929.79253256.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2010 10:59 AM, David Miller wrote:
>
> Use of get_irq_chip_data() et al. requires including
> linux/irq.h
>
> Signed-off-by: David S. Miller<davem@davemloft.net>

Acked-by: Richard Röjfors <richard.rojfors@pelagicore.com>

>
> diff --git a/drivers/gpio/timbgpio.c b/drivers/gpio/timbgpio.c
> index a4d344b..d941f45 100644
> --- a/drivers/gpio/timbgpio.c
> +++ b/drivers/gpio/timbgpio.c
> @@ -23,6 +23,7 @@
>   #include<linux/module.h>
>   #include<linux/gpio.h>
>   #include<linux/platform_device.h>
> +#include<linux/irq.h>
>   #include<linux/io.h>
>   #include<linux/timb_gpio.h>
>   #include<linux/interrupt.h>
