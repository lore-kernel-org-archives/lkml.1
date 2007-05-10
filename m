Return-Path: <linux-kernel-owner+w=401wt.eu-S1759135AbXEJASJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759135AbXEJASJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 20:18:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759746AbXEJARy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 20:17:54 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50639 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759743AbXEJARx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 20:17:53 -0400
Message-ID: <464264AE.4020407@garzik.org>
Date: Wed, 09 May 2007 20:17:50 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-kernel@vger.kernel.org, akpm@google.com, alan@redhat.com
Subject: Re: [PATCH] Fix pata_qdi.c probe code
References: <20070503093025.GB3595@implementation.labri.fr>
In-Reply-To: <20070503093025.GB3595@implementation.labri.fr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.8 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Samuel Thibault wrote:
> Hi,
> 
> There is a small typo in the probe code of pata_qdi.c, here is a patch.
> 
> Samuel
> 
> 
> ------------------------------------------------------------------------
> 
> diff --git a/drivers/ata/pata_qdi.c b/drivers/ata/pata_qdi.c
> index 27685ce..fb8c9e1 100644
> --- a/drivers/ata/pata_qdi.c
> +++ b/drivers/ata/pata_qdi.c
> @@ -375,7 +375,7 @@ static __init int qdi_init(void)
>  				res = inb(port + 3);
>  				if (res & 1) {
>  					/* Single channel mode */
> -					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04))
> +					if (qdi_init_one(port, 6580, ide_port[r & 0x01], ide_irq[r & 0x01], r & 0x04) == 0)
>  						ct++;

applied


