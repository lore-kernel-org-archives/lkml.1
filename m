Return-Path: <linux-kernel-owner+w=401wt.eu-S934384AbZKXXSH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934384AbZKXXSH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 18:18:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934358AbZKXXSG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 18:18:06 -0500
Received: from mga09.intel.com ([134.134.136.24]:20336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934354AbZKXXSF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 18:18:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,280,1257148800"; 
   d="scan'208";a="470299963"
Date: Wed, 25 Nov 2009 00:19:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Force I2C to be built in when building WM831x
Message-ID: <20091124231949.GE8290@sortiz.org>
References: <>
 <1259059736-23651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1259059736-23651-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Tue, Nov 24, 2009 at 10:48:56AM +0000, Mark Brown wrote:
> This works around issues with allmodconfig where it won't propagate the
> dependency from the WM831x core back to the I2C and MFD cores.  When
> doing allmodconfig this causes WM831x to be omitted and ensures that in
> normal builds the dependencies get shaken out.
Applied, thanks for looking at this.

Cheers,
Samuel.


> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index 434bc2f..c33a526 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -183,7 +183,7 @@ config MFD_WM8400
>  config MFD_WM831X
>  	bool "Support Wolfson Microelectronics WM831x/2x PMICs"
>  	select MFD_CORE
> -	depends on I2C
> +	depends on I2C=y
>  	help
>  	  Support for the Wolfson Microelecronics WM831x and WM832x PMICs.
>  	  This driver provides common support for accessing the device,
> -- 
> 1.6.3.3
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
