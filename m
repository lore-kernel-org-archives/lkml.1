Return-Path: <linux-kernel-owner+w=401wt.eu-S1763529AbYESVmd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763529AbYESVmd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2008 17:42:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755516AbYESVmX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 May 2008 17:42:23 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:38576 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755440AbYESVmW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2008 17:42:22 -0400
Message-ID: <4831F43C.4060302@garzik.org>
Date: Mon, 19 May 2008 17:42:20 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
CC: linux <linux-kernel@vger.kernel.org>, hskinnemoen@atmel.com,
       gregerts@stud.ntnu.no
Subject: Re: [PATCH 1/1] avr32/pata: avoid unnecessary memset (updated after
 comments)
References: <20080513191732.5B0B31C0008D@mwinf2713.orange.fr>
In-Reply-To: <20080513191732.5B0B31C0008D@mwinf2713.orange.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christophe Jaillet wrote:
> From: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> 
> Hi, here is a patch against linux/drivers/ata/pata_at32.c which :
> 	
> 1) Remove an explicit memset(.., 0, ...) to a variable allocated with
> kzalloc (i.e. 'info').
> 
> 
> Note: this patch is based on 'linux-2.6.25.tar.bz2'
> 
> Signed-off-by: Christophe Jaillet <christophe.jaillet@wanadoo.fr>
> Acked-by: Haavard Skinnemoen <haavard.skinnemoen@atmel.com>
> 
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

applied


