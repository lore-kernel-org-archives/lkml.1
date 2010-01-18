Return-Path: <linux-kernel-owner+w=401wt.eu-S1754779Ab0ARXbO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab0ARXbO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jan 2010 18:31:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754263Ab0ARXbN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Jan 2010 18:31:13 -0500
Received: from xenotime.net ([72.52.64.118]:58097 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753652Ab0ARXbM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jan 2010 18:31:12 -0500
Date: Mon, 18 Jan 2010 15:31:07 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Mark Allyn <mark.a.allyn@intel.com>
Cc: linux-kernel@vger.kernel.org, greg@kroah.com, alan@linux.intel.com,
       charles.f.johnson@intel.com
Subject: Re: [PATCH] Remove cflags from Makefile and fix Kconfig
Message-Id: <20100118153107.567b2b0c.rdunlap@xenotime.net>
In-Reply-To: <1263849774-23152-1-git-send-email-mark.a.allyn@intel.com>
References: <1263849774-23152-1-git-send-email-mark.a.allyn@intel.com>
Organization: YPO4
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jan 2010 13:22:54 -0800 Mark Allyn wrote:

> This patch fixes bothe the Makefile and the Kconfig file
> 
> This is the fourth of seven patches for the rar_register driver
> for Sunday, January 17, 2009
> 
> The rar stands for restricted access region. The restricted access
> region is an area of memory that can be locked from access by the
> x86 processor.
> 
> The purpose of the restricted access region is to safeguard confidential
> information from any unauthorized software running on the x86 processor.
> 
> The purpose of this driver is to enable other drivers to obtain
> the address ranges of the restricted regions as well as lock them.
> 
> This patch is referenced off the linux-next repository as pulled
> on Sunday, January 17, 2010
> 
> Signed-off-by: Mark Allyn <mark.a.allyn@intel.com>
> 
> Date: January 17, 2010
> ---
>  drivers/staging/rar/Kconfig  |    8 ++++++--
>  drivers/staging/rar/Makefile |    1 -
>  2 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/staging/rar/Kconfig b/drivers/staging/rar/Kconfig
> index 17f8bf3..e923178 100644
> --- a/drivers/staging/rar/Kconfig
> +++ b/drivers/staging/rar/Kconfig
> @@ -8,10 +8,14 @@ menu "RAR Register Driver"
>  #
>  config RAR_REGISTER
>  	tristate "Restricted Access Region Register Driver"
> -	default n
>  	---help---
>  		This driver allows other kernel drivers access to the
>  		contents of the restricted access region control
> -		registers.
> +		registers. The restricted access regions are areas
> +		of memory on the Intel ultra mobile platform which the
> +		x86 processor (and software running thereupon) cannot
> +		access for reading or writing. It is used the protect
		                                          ^^^
		                                          to

> +		sensitive information from unauthorized programms running
> +		on the x86 processor.
>  
>  endmenu
> diff --git a/drivers/staging/rar/Makefile b/drivers/staging/rar/Makefile
> index d5954cc..7f1478b 100644
> --- a/drivers/staging/rar/Makefile
> +++ b/drivers/staging/rar/Makefile
> @@ -1,2 +1 @@
> -EXTRA_CFLAGS += -DLITTLE__ENDIAN
>  obj-$(CONFIG_RAR_REGISTER) += rar_register.o
> -- 
> 1.6.0.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


---
~Randy
