Return-Path: <linux-kernel-owner+w=401wt.eu-S932587AbXHCPmc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932587AbXHCPmc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:42:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932304AbXHCPmG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:42:06 -0400
Received: from emulex.emulex.com ([138.239.112.1]:47295 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932260AbXHCPmD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:42:03 -0400
Message-ID: <46B34CA6.6010502@emulex.com>
Date: Fri, 03 Aug 2007 11:41:26 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 46] drivers/scsi/lpfc/lpfc_scsi.c: kmalloc + memset conversion
 to kzalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312027.55149.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312027.55149.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 15:41:21.0913 (UTC) FILETIME=[BDEE7690:01C7D5E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/lpfc/lpfc_scsi.c | 42769 -> 42721 (-48 bytes)
>  drivers/scsi/lpfc/lpfc_scsi.o | 191332 -> 191240 (-92 bytes)
> 
>  drivers/scsi/lpfc/lpfc_scsi.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-26 13:07:42.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_scsi.c	2007-07-31 11:08:46.000000000 +0200
> @@ -208,10 +208,9 @@ lpfc_new_scsi_buf(struct lpfc_vport *vpo
>  	dma_addr_t pdma_phys;
>  	uint16_t iotag;
> 
> -	psb = kmalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
> +	psb = kzalloc(sizeof(struct lpfc_scsi_buf), GFP_KERNEL);
>  	if (!psb)
>  		return NULL;
> -	memset(psb, 0, sizeof (struct lpfc_scsi_buf));
> 
>  	/*
>  	 * Get memory from the pci pool to map the virt space to pci bus space
> 
