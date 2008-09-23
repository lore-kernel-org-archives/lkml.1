Return-Path: <linux-kernel-owner+w=401wt.eu-S1756067AbYIWV0U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067AbYIWV0U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 17:26:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753594AbYIWV0J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 17:26:09 -0400
Received: from outbound-mail-12.bluehost.com ([69.89.18.112]:54227 "HELO
	outbound-mail-12.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752934AbYIWV0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 17:26:08 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=FuaAeTMEJdP3gDIczm+QRspcCnSqW0svxz+2p0xFYpPXHJuFrqQ3hYaqRk+v2Eb7zwCu7P2+h8lE4XL138Qyccyx6/Mn3A6q/Cc1EFfoB0iQYKgtYC/qt3Cjn4+ya9WW;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH]pci_dma_mapping_error changes
Date: Tue, 23 Sep 2008 14:26:05 -0700
User-Agent: KMail/1.9.9
Cc: Marin Mitov <mitov@issp.bas.bg>, linux-kernel@vger.kernel.org
References: <200809180812.25143.mitov@issp.bas.bg> <48D27D9F.7090103@garzik.org>
In-Reply-To: <48D27D9F.7090103@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809231426.06194.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 18, 2008 9:11 am Jeff Garzik wrote:
> Make the example code consistent with changed API.
>
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
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
>

Applied to linux-next, thanks.

-- 
Jesse Barnes, Intel Open Source Technology Center
