Return-Path: <linux-kernel-owner+w=401wt.eu-S934270AbZFLVr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934270AbZFLVr3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 17:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765628AbZFLVrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 17:47:16 -0400
Received: from mail.mnementh.co.uk ([173.45.232.4]:59575 "EHLO mnementh.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934254AbZFLVrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 17:47:15 -0400
Message-ID: <4A32CCDA.20802@f2s.com>
Date: Fri, 12 Jun 2009 22:47:06 +0100
From: Ian molton <spyro@f2s.com>
Reply-To: ian@mnementh.co.uk
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Philipp Zabel <philipp.zabel@gmail.com>
CC: linux-kernel@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
       Pierre Ossman <pierre@ossman.eu>
Subject: Re: [PATCH 7/7] mmc: tmio_mmc: allow compilation for ASIC3
References: <1244139157-16404-1-git-send-email-philipp.zabel@gmail.com> <1244139157-16404-8-git-send-email-philipp.zabel@gmail.com>
In-Reply-To: <1244139157-16404-8-git-send-email-philipp.zabel@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does this patch actually _do_ anything? wont the asic3 driver need 
modifying to use tmio_mmc before this patch is useful?

Is the idea that this patch go in and asic3 MFDs migrate gradually?

If so then I'll ack it.

Philipp Zabel wrote:
> Now tmio_mmc is able to drive the MMC/SD cell in ASIC3.
> 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> Cc: Pierre Ossman <pierre@ossman.eu>
> Cc: Ian Molton <spyro@f2s.com>
> ---
>  drivers/mmc/host/Kconfig    |    4 ++--
>  drivers/mmc/host/tmio_mmc.c |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mmc/host/Kconfig b/drivers/mmc/host/Kconfig
> index b4cf691..9aae7f5 100644
> --- a/drivers/mmc/host/Kconfig
> +++ b/drivers/mmc/host/Kconfig
> @@ -237,7 +237,7 @@ config MMC_SDRICOH_CS
>  
>  config MMC_TMIO
>  	tristate "Toshiba Mobile IO Controller (TMIO) MMC/SD function support"
> -	depends on MFD_TMIO
> +	depends on MFD_TMIO || MFD_ASIC3
>  	help
>  	  This provides support for the SD/MMC cell found in TC6393XB,
> -	  T7L66XB and also ipaq ASIC3
> +	  T7L66XB and also HTC ASIC3.
> diff --git a/drivers/mmc/host/tmio_mmc.c b/drivers/mmc/host/tmio_mmc.c
> index 9f6e180..9f68c2f 100644
> --- a/drivers/mmc/host/tmio_mmc.c
> +++ b/drivers/mmc/host/tmio_mmc.c
> @@ -10,7 +10,7 @@
>   *
>   * Driver for the MMC / SD / SDIO cell found in:
>   *
> - * TC6393XB TC6391XB TC6387XB T7L66XB
> + * TC6393XB TC6391XB TC6387XB T7L66XB ASIC3
>   *
>   * This driver draws mainly on scattered spec sheets, Reverse engineering
>   * of the toshiba e800  SD driver and some parts of the 2.4 ASIC3 driver (4 bit

