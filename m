Return-Path: <linux-kernel-owner+w=401wt.eu-S1753498Ab0AUMEg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab0AUMEg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 07:04:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719Ab0AUMEf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 07:04:35 -0500
Received: from mga10.intel.com ([192.55.52.92]:50766 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752706Ab0AUMEe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 07:04:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,316,1262592000"; 
   d="scan'208";a="766110782"
Date: Thu, 21 Jan 2010 13:06:05 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH -next] mfd: htc-i2cpld depends on GPIOLIB
Message-ID: <20100121120604.GA6936@sortiz.org>
References: <4B57D036.2000001@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B57D036.2000001@oracle.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 20, 2010 at 07:55:34PM -0800, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> htc-i2cpld should depend on GPIOLIB, otherwise there are many
> build errors:
Thanks Randy, patch applied and pushed to my for-next branch.

Cheers,
Samuel.

 
> drivers/mfd/htc-i2cpld.c:50: error: field 'chip_out' has incomplete type
> drivers/mfd/htc-i2cpld.c:54: error: field 'chip_in' has incomplete type
> drivers/mfd/htc-i2cpld.c:243: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/htc-i2cpld.c:243: warning: initialization from incompatible pointer type
> drivers/mfd/htc-i2cpld.c:278: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/htc-i2cpld.c:278: warning: initialization from incompatible pointer type
> drivers/mfd/htc-i2cpld.c:282: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/htc-i2cpld.c:282: warning: initialization from incompatible pointer type
> drivers/mfd/htc-i2cpld.c:315: error: dereferencing pointer to incomplete type
> drivers/mfd/htc-i2cpld.c:322: warning: type defaults to 'int' in declaration of '__mptr'
> drivers/mfd/htc-i2cpld.c:322: warning: initialization from incompatible pointer type
> drivers/mfd/htc-i2cpld.c:467+: error: dereferencing pointer to incomplete type [19X]
> drivers/mfd/htc-i2cpld.c:490: error: implicit declaration of function 'gpiochip_add'
> drivers/mfd/htc-i2cpld.c:504: error: implicit declaration of function 'gpiochip_remove'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> --- linux-next-20100120.orig/drivers/mfd/Kconfig
> +++ linux-next-20100120/drivers/mfd/Kconfig
> @@ -80,7 +80,7 @@ config HTC_PASIC3
>  
>  config HTC_I2CPLD
>  	bool "HTC I2C PLD chip support"
> -	depends on I2C=y
> +	depends on I2C=y && GPIOLIB
>  	help
>  	  If you say yes here you get support for the supposed CPLD
>  	  found on omap850 HTC devices like the HTC Wizard and HTC Herald.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
