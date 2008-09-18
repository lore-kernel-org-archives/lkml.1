Return-Path: <linux-kernel-owner+w=401wt.eu-S1754053AbYIROHD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053AbYIROHD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 10:07:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754225AbYIROGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 10:06:53 -0400
Received: from mo11.iij4u.or.jp ([210.138.174.79]:43132 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754219AbYIROGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 10:06:53 -0400
Date: Thu, 18 Sep 2008 23:06:30 +0900
To: mitov@issp.bas.bg
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH]pci_dma_mapping_error changes
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <200809180812.25143.mitov@issp.bas.bg>
References: <200809180812.25143.mitov@issp.bas.bg>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20080918230516T.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 08:12:25 +0300
Marin Mitov <mitov@issp.bas.bg> wrote:

> Make the example code consistent with changed API.

Thanks,


> Signed-off-by: Marin Mitov <mitov@ispp.bas.bg>

Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>

> 
> ===================================================
> --- a/Documentation/DMA-mapping.txt	2008-09-14 11:34:48.000000000 +0300
> +++ b/Documentation/DMA-mapping.txt	2008-09-14 11:37:17.000000000 +0300
> @@ -740,7 +740,7 @@ failure can be determined by:
>  	dma_addr_t dma_handle;
>  
>  	dma_handle = pci_map_single(pdev, addr, size, direction);
> -	if (pci_dma_mapping_error(dma_handle)) {
> +	if (pci_dma_mapping_error(pdev, dma_handle)) {
>  		/*
>  		 * reduce current DMA mapping usage,
>  		 * delay and try again later or
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
