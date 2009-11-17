Return-Path: <linux-kernel-owner+w=401wt.eu-S1754277AbZKQDSB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277AbZKQDSB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 22:18:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754164AbZKQDSA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 22:18:00 -0500
Received: from srv5.dvmed.net ([207.36.208.214]:50945 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754162AbZKQDR6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 22:17:58 -0500
Message-ID: <4B0215EA.9080800@pobox.com>
Date: Mon, 16 Nov 2009 22:18:02 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: linux-ide@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: ATA: Make CS5536 PATA driver use 32-bit BM DMA template instead
 of 16-bit.
References: <m3my2u0w6f.fsf@intrepid.localdomain>
In-Reply-To: <m3my2u0w6f.fsf@intrepid.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 06:58 PM, Krzysztof Halasa wrote:
> Tested on IXP425 + CS5536.
>
> Signed-off-by: Krzysztof Hałasa<khc@pm.waw.pl>
>
> diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
> index 88a7933..0898213 100644
> --- a/drivers/ata/pata_cs5536.c
> +++ b/drivers/ata/pata_cs5536.c
> @@ -232,7 +232,7 @@ static struct scsi_host_template cs5536_sht = {
>   };
>
>   static struct ata_port_operations cs5536_port_ops = {
> -	.inherits		=&ata_bmdma_port_ops,
> +	.inherits		=&ata_bmdma32_port_ops,
>   	.cable_detect		= cs5536_cable_detect,
>   	.set_piomode		= cs5536_set_piomode,
>   	.set_dmamode		= cs5536_set_dmamode,

applied


