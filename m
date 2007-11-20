Return-Path: <linux-kernel-owner+w=401wt.eu-S1758617AbXKTMGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617AbXKTMGG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 07:06:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756306AbXKTMFy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 07:05:54 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:38408 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756261AbXKTMFx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 07:05:53 -0500
Date: Tue, 20 Nov 2007 13:07:35 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Haavard Skinnemoen <hskinnemoen@atmel.com>
Cc: Shannon Nelson <shannon.nelson@intel.com>,
       Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
       Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] dmaengine: Simple DMA memcpy test client
Message-ID: <20071120120735.GA25255@uranus.ravnborg.org>
References: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1195558354-23150-1-git-send-email-hskinnemoen@atmel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2007 at 12:32:34PM +0100, Haavard Skinnemoen wrote:
> This client tests DMA memcpy using various lengths and various offsets
> into the source and destination buffers. It will initialize both
> buffers with a know pattern and verify that the DMA engine copies the
> requested region and nothing more.
> 
> Signed-off-by: Haavard Skinnemoen <hskinnemoen@atmel.com>
> ---
> This patch depends on "DMAENGINE: Convert from class_device to
> device". Please let me know if you want a patch that doesn't.
> 
>  drivers/dma/Kconfig   |    8 ++
>  drivers/dma/Makefile  |    1 +
>  drivers/dma/dmatest.c |  272 +++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 281 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/dma/dmatest.c
> 
> diff --git a/drivers/dma/Kconfig b/drivers/dma/Kconfig
> index 6a7d25f..b669595 100644
> --- a/drivers/dma/Kconfig
> +++ b/drivers/dma/Kconfig
> @@ -49,4 +49,12 @@ config NET_DMA
>  	  Since this is the main user of the DMA engine, it should be enabled;
>  	  say Y here.
>  
> +config DMATEST
> +	tristate "DMA Test client"
> +	depends on DMA_ENGINE
> +	default n

n is implicit default so adding it is for no use.

	Sam
