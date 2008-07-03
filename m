Return-Path: <linux-kernel-owner+w=401wt.eu-S1759667AbYGCMlc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759667AbYGCMlc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2008 08:41:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbYGCMlF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jul 2008 08:41:05 -0400
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:54463 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757149AbYGCMlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2008 08:41:03 -0400
Date: Thu, 3 Jul 2008 12:30:58 +0200
From: Samuel Ortiz <sameo@openedhand.com>
To: Philipp Zabel <philipp.zabel@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mfd: add ASIC3_CONFIG_GPIO templates for blueangel and hx4700
Message-ID: <20080703103057.GB6436@caravaggio>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1214751678.2758.98.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1214751678.2758.98.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 29, 2008 at 05:01:18PM +0200, Philipp Zabel wrote:
> As ASIC3 GPIO alternate function configuration is expected to be similar
> for several devices, it is convenient to define descriptive macros. This
> patch is inspired by the PXA MFP configuration, the alternate functions
> were observed on hx4700 and blueangel.
Thanks, this one applied as well.

Cheers,
Samuel.

 
> Signed-off-by: Philipp Zabel <philipp.zabel@gmail.com>
> ---
>  include/linux/mfd/asic3.h |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/mfd/asic3.h b/include/linux/mfd/asic3.h
> index 0610449..f149180 100644
> --- a/include/linux/mfd/asic3.h
> +++ b/include/linux/mfd/asic3.h
> @@ -100,6 +100,35 @@ struct asic3_platform_data {
>  #define ASIC3_CONFIG_GPIO_DEFAULT_OUT(gpio, init) \
>  	ASIC3_CONFIG_GPIO((gpio), 0, 1, (init))
>  
> +/*
> + * Alternate functions
> + */
> +#define ASIC3_GPIOA11_PWM0		ASIC3_CONFIG_GPIO(11, 1, 1, 0)
> +#define ASIC3_GPIOA12_PWM1		ASIC3_CONFIG_GPIO(12, 1, 1, 0)
> +#define ASIC3_GPIOA15_CONTROL_CX	ASIC3_CONFIG_GPIO(15, 1, 1, 0)
> +#define ASIC3_GPIOC0_LED0		ASIC3_CONFIG_GPIO(32, 1, 1, 0)
> +#define ASIC3_GPIOC1_LED1		ASIC3_CONFIG_GPIO(33, 1, 1, 0)
> +#define ASIC3_GPIOC2_LED2		ASIC3_CONFIG_GPIO(34, 1, 1, 0)
> +#define ASIC3_GPIOC3_SPI_RXD		ASIC3_CONFIG_GPIO(35, 1, 0, 0)
> +#define ASIC3_GPIOC4_CF_nCD		ASIC3_CONFIG_GPIO(36, 1, 0, 0)
> +#define ASIC3_GPIOC4_SPI_TXD		ASIC3_CONFIG_GPIO(36, 1, 1, 0)
> +#define ASIC3_GPIOC5_SPI_CLK		ASIC3_CONFIG_GPIO(37, 1, 1, 0)
> +#define ASIC3_GPIOC5_nCIOW		ASIC3_CONFIG_GPIO(37, 1, 1, 0)
> +#define ASIC3_GPIOC6_nCIOR		ASIC3_CONFIG_GPIO(38, 1, 1, 0)
> +#define ASIC3_GPIOC7_nPCE_1		ASIC3_CONFIG_GPIO(39, 1, 0, 0)
> +#define ASIC3_GPIOC8_nPCE_2		ASIC3_CONFIG_GPIO(40, 1, 0, 0)
> +#define ASIC3_GPIOC9_nPOE		ASIC3_CONFIG_GPIO(41, 1, 0, 0)
> +#define ASIC3_GPIOC10_nPWE		ASIC3_CONFIG_GPIO(42, 1, 0, 0)
> +#define ASIC3_GPIOC11_PSKTSEL		ASIC3_CONFIG_GPIO(43, 1, 0, 0)
> +#define ASIC3_GPIOC12_nPREG		ASIC3_CONFIG_GPIO(44, 1, 0, 0)
> +#define ASIC3_GPIOC13_nPWAIT		ASIC3_CONFIG_GPIO(45, 1, 1, 0)
> +#define ASIC3_GPIOC14_nPIOIS16		ASIC3_CONFIG_GPIO(46, 1, 1, 0)
> +#define ASIC3_GPIOC15_nPIOR		ASIC3_CONFIG_GPIO(47, 1, 0, 0)
> +#define ASIC3_GPIOD11_nCIOIS16		ASIC3_CONFIG_GPIO(59, 1, 0, 0)
> +#define ASIC3_GPIOD12_nCWAIT		ASIC3_CONFIG_GPIO(60, 1, 0, 0)
> +#define ASIC3_GPIOD15_nPIOW		ASIC3_CONFIG_GPIO(63, 1, 0, 0)
> +
> +
>  #define ASIC3_SPI_Base		      0x0400
>  #define ASIC3_SPI_Control               0x0000
>  #define ASIC3_SPI_TxData                0x0004
> -- 
> 1.5.5.4
> 
> 
