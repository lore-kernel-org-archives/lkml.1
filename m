Return-Path: <linux-kernel-owner+w=401wt.eu-S1755493Ab0AFIyr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755493Ab0AFIyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 03:54:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754824Ab0AFIyq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 03:54:46 -0500
Received: from mga06.intel.com ([134.134.136.21]:1269 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754779Ab0AFIyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 03:54:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,228,1262592000"; 
   d="scan'208";a="481676108"
Date: Wed, 6 Jan 2010 09:56:21 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/4] mfd: Don't allow WM8350 to be built modular
Message-ID: <20100106085620.GA5500@sortiz.org>
References: <1262699949-3079-4-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1262724047-4042-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1262724047-4042-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Jan 05, 2010 at 08:40:47PM +0000, Mark Brown wrote:
> The genirq implementation does not allow modules to implement irq_chips
> so the conversion of WM8350 to genirq means we can no longer allow the
> driver to be built as a module.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> 
> Sorry, I thought I'd sent a patch for this earlier but I appear to be
> imagining things.
No problem, patch applied.

Cheers,
Samuel.

>  drivers/mfd/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 8782978..1414cec 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -205,7 +205,7 @@ config MFD_WM831X
>  	  functionality of the device.
>  
>  config MFD_WM8350
> -	tristate
> +	bool
>  
>  config MFD_WM8350_CONFIG_MODE_0
>  	bool
> @@ -256,9 +256,9 @@ config MFD_WM8352_CONFIG_MODE_3
>  	depends on MFD_WM8350
>  
>  config MFD_WM8350_I2C
> -	tristate "Support Wolfson Microelectronics WM8350 with I2C"
> +	bool "Support Wolfson Microelectronics WM8350 with I2C"
>  	select MFD_WM8350
> -	depends on I2C
> +	depends on I2C=y
>  	help
>  	  The WM8350 is an integrated audio and power management
>  	  subsystem with watchdog and RTC functionality for embedded
> -- 
> 1.6.5.7
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
