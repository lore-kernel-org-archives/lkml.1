Return-Path: <linux-kernel-owner+w=401wt.eu-S1757043AbYIRQL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043AbYIRQL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 12:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754613AbYIRQLQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 12:11:16 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:33847 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755570AbYIRQLP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 12:11:15 -0400
Message-ID: <48D27D9F.7090103@garzik.org>
Date: Thu, 18 Sep 2008 12:11:11 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Marin Mitov <mitov@issp.bas.bg>
CC: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH]pci_dma_mapping_error changes
References: <200809180812.25143.mitov@issp.bas.bg>
In-Reply-To: <200809180812.25143.mitov@issp.bas.bg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marin Mitov wrote:
> Make the example code consistent with changed API.
> 
> Signed-off-by: Marin Mitov <mitov@ispp.bas.bg>
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

Acked-by: Jeff Garzik <jgarzik@redhat.com>

