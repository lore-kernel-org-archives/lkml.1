Return-Path: <linux-kernel-owner+w=401wt.eu-S933033AbXHAOCw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933033AbXHAOCw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:02:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932496AbXHAOCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:02:40 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:41662 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932137AbXHAOCj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:02:39 -0400
Message-ID: <46B0927C.10408@garzik.org>
Date: Wed, 01 Aug 2007 10:02:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20070719)
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: [PATCH] pata_sis: fix MWDMA for <= UDMA66 chipsets and UDMA for
 UDMA33 chipsets
References: <200707312202.41856.bzolnier@gmail.com>
In-Reply-To: <200707312202.41856.bzolnier@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.3 (----)
X-Spam-Report: SpamAssassin version 3.1.9 on srv5.dvmed.net summary:
	Content analysis details:   (-4.3 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Bartlomiej Zolnierkiewicz wrote:
> * Fix MWDMA timings setup in sis_old_set_dmamode() and sis_66_set_dmamode().
> 
>   The old timings were overclocked (even worse behavior than sis5513 IDE driver
>   which depends on BIOS to program correct timings), the new timings are taken
>   from the datasheet (they match timings from ATA spec).
> 
> * Fix UDMA timings setup in sis_old_set_dmamode().
> 
>   Misplaced pci_write_config_word() call resulted in UDMA timings never
>   being set.
> 
> * Fix comments for sis_133_early_set_dmamode() and sis_133_set_dmamode():
>   - only the former function handles early SiS 961 bridges
>   - both functions lack MWDMA timings setup
> 
> * Fix typos in sis_100_set_piomode() and sis_133_set_piomode() comments.
> 
> * Bump driver version.
> 
> Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Signed-off-by: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
> ---
> Sergei: Yes, I'm working on sis5513 IDE driver. :)
> 
>  drivers/ata/pata_sis.c |   20 +++++++++-----------
>  1 file changed, 9 insertions(+), 11 deletions(-)

applied to #upstream-fixes


