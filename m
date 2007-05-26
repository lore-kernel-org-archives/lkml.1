Return-Path: <linux-kernel-owner+w=401wt.eu-S1755911AbXEZAGm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755911AbXEZAGm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2007 20:06:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752783AbXEZAGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 May 2007 20:06:34 -0400
Received: from aun.it.uu.se ([130.238.12.36]:45839 "EHLO aun.it.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752707AbXEZAGe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2007 20:06:34 -0400
Date: Sat, 26 May 2007 02:06:16 +0200 (MEST)
Message-Id: <200705260006.l4Q06GsK020585@harpo.it.uu.se>
From: Mikael Pettersson <mikpe@it.uu.se>
To: akpm@linux-foundation.org, jeff@garzik.org, torvalds@linux-foundation.org
Subject: Re: [git patches] libata fixes
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, mikpe@it.uu.se
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2007 18:03:07 -0400, Jeff Garzik wrote:
>Jeff Garzik (4):
>      [libata] sata_promise: fix flags typo
...
>--- a/drivers/ata/sata_promise.c
>+++ b/drivers/ata/sata_promise.c
>@@ -297,7 +297,7 @@ static const struct ata_port_info pdc_port_info[] = {
> 
> 	/* board_2057x_pata */
> 	{
>-		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS,
>+		.flags		= PDC_COMMON_FLAGS | ATA_FLAG_SLAVE_POSS |
> 				  PDC_FLAG_GEN_II,
> 		.pio_mask	= 0x1f, /* pio0-4 */
> 		.mwdma_mask	= 0x07, /* mwdma0-2 */

Acked-by: Mikael Pettersson <mikpe@it.uu.se>

Good catch. This typo would have prevented pdc_host_intr()
from detecting GEN_II-specific errors on the PATA port.
