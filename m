Return-Path: <linux-kernel-owner+w=401wt.eu-S1760523AbXGaOQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760523AbXGaOQQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 10:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752683AbXGaOQH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 10:16:07 -0400
Received: from mtagate6.uk.ibm.com ([195.212.29.139]:22143 "EHLO
	mtagate6.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752782AbXGaOQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 10:16:06 -0400
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: jack@hawkeye.stone.uk.eu.org
Subject: Re: [Patch 02/16] Remove unnecessary kmalloc casts from the mips arch.
Date: Tue, 31 Jul 2007 16:15:39 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       Ralf Baechle <ralf@linux-mips.org>
References: <20070731125316.860150000@hawkeye.stone.uk.eu.org> <20070731125438.662563000@hawkeye.stone.uk.eu.org>
In-Reply-To: <20070731125438.662563000@hawkeye.stone.uk.eu.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707311615.39946.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, 31. Juli 2007 schrieb jack@hawkeye.stone.uk.eu.org:
> ===================================================================
> --- a/arch/mips/au1000/common/dbdma.c
> +++ b/arch/mips/au1000/common/dbdma.c
[...]
> -	desc_base = (u32)kmalloc(entries * sizeof(au1x_ddma_desc_t),
> +	desc_base = kmalloc(entries * sizeof(au1x_ddma_desc_t),
[...]
> -		if ((desc_base = (u32)kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)
> +		if ((desc_base = kmalloc(i, GFP_KERNEL|GFP_DMA)) == 0)

See the comments to the other patches. The cast is necessary.
