Return-Path: <linux-kernel-owner+w=401wt.eu-S1755331AbZLKJDO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331AbZLKJDO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 04:03:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751596AbZLKJDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 04:03:10 -0500
Received: from mail.atmel.fr ([81.80.104.162]:45442 "EHLO atmel-es2.atmel.fr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753405AbZLKJDI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 04:03:08 -0500
Message-ID: <4B220AC3.3080405@atmel.com>
Date: Fri, 11 Dec 2009 10:02:59 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: H Hartley Sweeten <hartleys@visionengravers.com>
CC: kernel list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] at_hdmac.c: use resource_size()
References: <BD79186B4FD85F4B8E60E381CAEE190901FB0FC1@mi8nycmail19.Mi8.com>
In-Reply-To: <BD79186B4FD85F4B8E60E381CAEE190901FB0FC1@mi8nycmail19.Mi8.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H Hartley Sweeten :
> Use resource_size() for ioremap.
> 
> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>

> ---
> 
> diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
> index c52ac9e..e16057b 100644
> --- a/drivers/dma/at_hdmac.c
> +++ b/drivers/dma/at_hdmac.c
> @@ -1012,7 +1012,7 @@ static int __init at_dma_probe(struct platform_device *pdev)
>  	atdma->dma_common.cap_mask = pdata->cap_mask;
>  	atdma->all_chan_mask = (1 << pdata->nr_channels) - 1;
>  
> -	size = io->end - io->start + 1;
> +	size = resource_size(io);
>  	if (!request_mem_region(io->start, size, pdev->dev.driver->name)) {
>  		err = -EBUSY;
>  		goto err_kfree; 
> 


-- 
Nicolas Ferre

