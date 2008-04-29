Return-Path: <linux-kernel-owner+w=401wt.eu-S1762756AbYD2P4D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762756AbYD2P4D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2008 11:56:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752842AbYD2Pzy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Apr 2008 11:55:54 -0400
Received: from outbound-mail-132.bluehost.com ([67.222.39.22]:51774 "HELO
	outbound-mail-132.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751946AbYD2Pzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2008 11:55:53 -0400
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Matti Linnanvuori <mattilinnanvuori@hotmail.com>
Subject: Re: [patch] doc: replace yet another dev with pdev for consistency in DMA-mapping.txt
Date: Tue, 29 Apr 2008 08:55:51 -0700
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, linux-pci@atrey.karlin.mff.cuni.cz
References: <BLU128-W15159BD11397A0AF8D1A36D7D90@phx.gbl>
In-Reply-To: <BLU128-W15159BD11397A0AF8D1A36D7D90@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200804290855.51076.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, April 29, 2008 12:54 am Matti Linnanvuori wrote:
> From: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
>
> Replace "dev" with "pdev" for consistency in DMA-mapping.txt.
>
> Signed-off-by: Matti Linnanvuori <mattilinnanvuori@yahoo.com>
>
> ---
>
> --- linux-2.6.25/Documentation/DMA-mapping.txt    2008-04-29
> 10:41:30.721452200 +0300 +++ linux/Documentation/DMA-mapping.txt   
> 2008-04-29 10:43:38.804537700 +0300 @@ -332,7 +332,7 @@ __get_free_pages
> (but takes size instead
>  driver needs regions sized smaller than a page, you may prefer using
>  the pci_pool interface, described below.
>
> -The consistent DMA mapping interfaces, for non-NULL dev, will by
> +The consistent DMA mapping interfaces, for non-NULL pdev, will by
>  default return a DMA address which is SAC (Single Address Cycle)
>  addressable.  Even if the device indicates (via PCI dma mask) that it
>  may address the upper 32-bits and thus perform DAC cycles, consistent

Applied, thanks.

Jesse
