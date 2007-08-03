Return-Path: <linux-kernel-owner+w=401wt.eu-S932433AbXHCPmO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433AbXHCPmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:42:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762341AbXHCPl4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:41:56 -0400
Received: from emulex.emulex.com ([138.239.112.1]:47276 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762231AbXHCPly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:41:54 -0400
Message-ID: <46B34C9C.2050300@emulex.com>
Date: Fri, 03 Aug 2007 11:41:16 -0400
From: James Smart <James.Smart@Emulex.Com>
Reply-To: James.Smart@Emulex.Com
User-Agent: Thunderbird 1.5.0.12 (Windows/20070509)
MIME-Version: 1.0
To: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
CC: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 45] drivers/scsi/lpfc/lpfc_init.c: kmalloc + memset conversion
 to kcalloc
References: <200707311845.48807.m.kozlowski@tuxland.pl> <200707312026.43947.m.kozlowski@tuxland.pl>
In-Reply-To: <200707312026.43947.m.kozlowski@tuxland.pl>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 Aug 2007 15:41:11.0398 (UTC) FILETIME=[B7AA0060:01C7D5E4]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

ACK

-- james s

Mariusz Kozlowski wrote:
> Signed-off-by: Mariusz Kozlowski <m.kozlowski@tuxland.pl>
> 
>  drivers/scsi/lpfc/lpfc_init.c | 65932 -> 65881 (-51 bytes)
>  drivers/scsi/lpfc/lpfc_init.o | 219760 -> 219616 (-144 bytes)
> 
>  drivers/scsi/lpfc/lpfc_init.c |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- linux-2.6.23-rc1-mm1-a/drivers/scsi/lpfc/lpfc_init.c	2007-07-26 13:07:42.000000000 +0200
> +++ linux-2.6.23-rc1-mm1-b/drivers/scsi/lpfc/lpfc_init.c	2007-07-31 11:07:59.000000000 +0200
> @@ -1280,11 +1280,10 @@ lpfc_hba_init(struct lpfc_hba *phba, uin
>  	uint32_t *HashWorking;
>  	uint32_t *pwwnn = (uint32_t *) phba->wwnn;
> 
> -	HashWorking = kmalloc(80 * sizeof(uint32_t), GFP_KERNEL);
> +	HashWorking = kcalloc(80, sizeof(uint32_t), GFP_KERNEL);
>  	if (!HashWorking)
>  		return;
> 
> -	memset(HashWorking, 0, (80 * sizeof(uint32_t)));
>  	HashWorking[0] = HashWorking[78] = *pwwnn++;
>  	HashWorking[1] = HashWorking[79] = *pwwnn;
> 
> 
