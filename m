Return-Path: <linux-kernel-owner+w=401wt.eu-S932326AbZDIJ6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932326AbZDIJ6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Apr 2009 05:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765405AbZDIJ5K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Apr 2009 05:57:10 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:48551 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1765813AbZDIJ5J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Apr 2009 05:57:09 -0400
X-Sasl-enc: tU2IdAaKBenILXQf8LF1zwPLwA4GTfL5Uzs5dG44bP5+ 1239271028
Message-ID: <49DDC670.4080904@fastmail.fm>
Date: Thu, 09 Apr 2009 10:57:04 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Thunderbird 2.0.0.21 (X11/20090325)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: jeff@garzik.org, kernel-janitors@vger.kernel.org, bzolnier@gmail.com
Subject: Re: [PATCH 15/56] ide: Remove void casts
References: <> <1239189748-11703-1-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-2-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-3-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-4-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-5-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-6-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-7-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-8-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-9-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-10-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-11-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-12-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-13-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-14-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-15-git-send-email-jwjstone@fastmail.fm> <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
In-Reply-To: <1239189748-11703-16-git-send-email-jwjstone@fastmail.fm>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added maintainer CC]
Jack Stone wrote:
> Remove uneeded void casts
>
> Signed-Off-By: Jack Stone <jwjstone@fastmail.fm>
> ---
>  drivers/ide/pmac.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/ide/pmac.c b/drivers/ide/pmac.c
> index 052b9bf..f76e4e6 100644
> --- a/drivers/ide/pmac.c
> +++ b/drivers/ide/pmac.c
> @@ -1682,7 +1682,7 @@ static int __devinit pmac_ide_init_dma(ide_hwif_t *hwif,
>  	 * The +2 is +1 for the stop command and +1 to allow for
>  	 * aligning the start address to a multiple of 16 bytes.
>  	 */
> -	pmif->dma_table_cpu = (struct dbdma_cmd*)pci_alloc_consistent(
> +	pmif->dma_table_cpu = pci_alloc_consistent(
>  		dev,
>  		(MAX_DCMDS + 2) * sizeof(struct dbdma_cmd),
>  		&hwif->dmatable_dma);
>   

