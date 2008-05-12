Return-Path: <linux-kernel-owner+w=401wt.eu-S1757187AbYELWp0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757187AbYELWp0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 18:45:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755463AbYELWpO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 18:45:14 -0400
Received: from smtpeu1.atmel.com ([195.65.72.27]:36271 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754725AbYELWpN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 18:45:13 -0400
Message-ID: <4828C86C.7010007@atmel.com>
Date: Tue, 13 May 2008 00:45:00 +0200
From: =?UTF-8?B?SMKMYWF2YXJkIFNraW5uZW1vZW4=?= 
	<haavard.skinnemoen@atmel.com>
User-Agent: Thunderbird 2.0.0.14 (Macintosh/20080421)
MIME-Version: 1.0
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
CC: linux <linux-kernel@vger.kernel.org>,
       Kristoffer Nyborg Gregertsen <gregerts@stud.ntnu.no>,
       Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 1/1] avr32/pata: avoid unnecessary memset
References: <20080512211529.1B7D97000089@mwinf2801.orange.fr>
In-Reply-To: <20080512211529.1B7D97000089@mwinf2801.orange.fr>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 12 May 2008 22:45:04.0029 (UTC) FILETIME=[D198C4D0:01C8B481]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Jaillet wrote:
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/dma/iop-adma.c which :

Hmm...no, it's for drivers/ata/pata_at32.c.

> 1) Remove an explicit memset(.., 0, ...) to a variable allocated with
> kzalloc (i.e. 'info').
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>

Other than that, it looks good to me. Could you please fix the patch 
description, add

Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>

and send it to Jeff?

Thanks a lot!

Haavard

> ---
> 
> --- linux/drivers/ata/pata_at32.c	2008-04-17 04:49:44.000000000 +0200
> +++ linux/drivers/ata/pata_at32.c.cj	2008-05-12 23:07:10.000000000 +0200
> @@ -329,8 +329,6 @@ static int __init pata_at32_probe(struct
>  	if (!info)
>  		return -ENOMEM;
>  
> -	memset(info, 0, sizeof(struct at32_ide_info));
> -
>  	info->irq = irq;
>  	info->cs  = board->cs;
>  
> 
> 

