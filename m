Return-Path: <linux-kernel-owner+w=401wt.eu-S1758768AbZKKAIL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758768AbZKKAIL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 19:08:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758762AbZKKAII
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 19:08:08 -0500
Received: from caffeine.csclub.uwaterloo.ca ([129.97.134.17]:42595 "EHLO
	caffeine.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758755AbZKKAIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 19:08:05 -0500
Date: Wed, 11 Nov 2009 00:08:10 +0000
To: Krzysztof Halasa <khc@pm.waw.pl>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: ATA: Make CS5536 PATA driver use 32-bit BM DMA template
	instead of 16-bit.
Message-ID: <20091111000810.GG15159@caffeine.csclub.uwaterloo.ca>
References: <m3my2u0w6f.fsf@intrepid.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <m3my2u0w6f.fsf@intrepid.localdomain>
User-Agent: Mutt/1.5.18 (2008-05-17)
From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 12:58:16AM +0100, Krzysztof Halasa wrote:
> Tested on IXP425 + CS5536.

Well I guess we will find out if it works on the Geode LX + CS5536 and
loongson + CS5536 sometime.  I don't know why it wouldn't work.

> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/ata/pata_cs5536.c b/drivers/ata/pata_cs5536.c
> index 88a7933..0898213 100644
> --- a/drivers/ata/pata_cs5536.c
> +++ b/drivers/ata/pata_cs5536.c
> @@ -232,7 +232,7 @@ static struct scsi_host_template cs5536_sht = {
>  };
>  
>  static struct ata_port_operations cs5536_port_ops = {
> -	.inherits		= &ata_bmdma_port_ops,
> +	.inherits		= &ata_bmdma32_port_ops,
>  	.cable_detect		= cs5536_cable_detect,
>  	.set_piomode		= cs5536_set_piomode,
>  	.set_dmamode		= cs5536_set_dmamode,

-- 
Len Sorensen
