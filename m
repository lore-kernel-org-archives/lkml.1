Return-Path: <linux-kernel-owner+w=401wt.eu-S1762327AbXGaORM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762327AbXGaORM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:17:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759328AbXGaOQp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:16:45 -0400
Received: from mtagate3.uk.ibm.com ([195.212.29.136]:35716 "EHLO
	mtagate3.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757149AbXGaOQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:16:43 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Subject: Re: [Patch 11/16] Remove unnecessary kmalloc casts in drivers/net.
Date: Tue, 31 Jul 2007 16:16:07 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       David Miller <davem@davemloft.net>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125444.707405000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125444.707405000@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311616.07364.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> --- a/drivers/net/lance.c
> +++ b/drivers/net/lance.c
[...]
> -	lp->rx_buffs = (unsigned long)kmalloc(PKT_BUF_SZ*RX_RING_SIZE,
> -						  GFP_DMA | GFP_KERNEL);
> +	lp->rx_buffs = kmalloc(PKT_BUF_SZ*RX_RING_SIZE, GFP_DMA | GFP_KERNEL);
[...]
> --- a/drivers/net/sgiseeq.c
> +++ b/drivers/net/sgiseeq.c
[...]
> -			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
> +			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);
[...]
> -			buffer = (unsigned long) kmalloc(PKT_BUF_SZ, GFP_KERNEL);
> +			buffer = kmalloc(PKT_BUF_SZ, GFP_KERNEL);

See the comments to the other patches. The cast is necessary.
