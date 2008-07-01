Return-Path: <linux-kernel-owner+w=401wt.eu-S1763978AbYGABre@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763978AbYGABre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2008 21:47:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756706AbYGABr0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Jun 2008 21:47:26 -0400
Received: from senator.holtmann.net ([87.106.208.187]:37213 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbYGABrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2008 21:47:25 -0400
Subject: Re: [PATCH 4/5] MMC: fix spares errors of sdhci.c
From: Marcel Holtmann <marcel@holtmann.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: drzeus-list@drzeus.cx, linux-kernel@vger.kernel.org
In-Reply-To: <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
References: <1214869984-20115-1-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-2-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-3-git-send-email-tomas.winkler@intel.com>
	 <1214869984-20115-4-git-send-email-tomas.winkler@intel.com>
Content-Type: text/plain
Date: Tue, 01 Jul 2008 03:47:38 +0200
Message-Id: <1214876858.11537.91.camel@violet.holtmann.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomas,

>  	if (host->flags & SDHCI_REQ_USE_DMA) {
> -		int count;
> +		int dma_cnt;
>  
> -		count = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
> +		dma_cnt = dma_map_sg(mmc_dev(host->mmc), data->sg, data->sg_len,
>  				(data->flags & MMC_DATA_READ) ?
>  					DMA_FROM_DEVICE : DMA_TO_DEVICE);
> -		WARN_ON(count != 1);
> +		WARN_ON(dma_cnt != 1);

can you include what sparse error this is trying to fix. From the patch
itself, I can't see it.

Regards

Marcel


