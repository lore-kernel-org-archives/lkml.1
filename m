Return-Path: <linux-kernel-owner+w=401wt.eu-S1759796AbZELA6y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759796AbZELA6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 May 2009 20:58:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757327AbZELA6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 May 2009 20:58:44 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:50366 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756784AbZELA6n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 May 2009 20:58:43 -0400
Message-ID: <4A08C9C0.6040202@pobox.com>
Date: Mon, 11 May 2009 20:58:40 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH] ata: libata depends on HAS_DMA
References: <20090511222702.352192505@arndb.de>> <200905112238.55404.arnd@arndb.de>
In-Reply-To: <200905112238.55404.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann wrote:
> libata uses the DMA mapping API, so it cannot be built
> on architectures that don't have DMA support.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/ata/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/ata/Kconfig b/drivers/ata/Kconfig
> index 9120717..f076268 100644
> --- a/drivers/ata/Kconfig
> +++ b/drivers/ata/Kconfig
> @@ -4,7 +4,7 @@
>  
>  menuconfig ATA
>  	tristate "Serial ATA (prod) and Parallel ATA (experimental) drivers"
> -	depends on HAS_IOMEM
> +	depends on HAS_IOMEM && HAS_DMA
>  	depends on BLOCK
>  	depends on !(M32R || M68K) || BROKEN

What specifically is breaking?

Ideally we should be able to work with PIO-only...

	JEff




