Return-Path: <linux-kernel-owner+w=401wt.eu-S1754747AbZBSHwv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747AbZBSHwv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 02:52:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752097AbZBSHwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 02:52:43 -0500
Received: from cs-studio.ru ([195.178.208.66]:51875 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928AbZBSHwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 02:52:42 -0500
Date: Thu, 19 Feb 2009 10:52:25 +0300
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] w1: add missing Kconfig/Makefile entries for DS2431 slave driver
Message-ID: <20090219075225.GA26591@ioremap.net>
References: <200902182247.12494.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200902182247.12494.herton@mandriva.com.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On Wed, Feb 18, 2009 at 10:47:12PM -0300, Herton Ronaldo Krzesinski (herton@mandriva.com.br) wrote:
> Signed-off-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

Thank you.

Signed-off-by: Evgeniy Polyakov <zbr@ioremap.net>

> ---
>  drivers/w1/slaves/Kconfig  |    6 ++++++
>  drivers/w1/slaves/Makefile |    1 +
>  2 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/w1/slaves/Kconfig b/drivers/w1/slaves/Kconfig
> index 8d0b1fb..1f51366 100644
> --- a/drivers/w1/slaves/Kconfig
> +++ b/drivers/w1/slaves/Kconfig
> @@ -16,6 +16,12 @@ config W1_SLAVE_SMEM
>  	  Say Y here if you want to connect 1-wire
>  	  simple 64bit memory rom(ds2401/ds2411/ds1990*) to your wire.
>  
> +config W1_SLAVE_DS2431
> +	tristate "1kb EEPROM family support (DS2431)"
> +	help
> +	  Say Y here if you want to use a 1-wire
> +	  1kb EEPROM family device (DS2431)
> +
>  config W1_SLAVE_DS2433
>  	tristate "4kb EEPROM family support (DS2433)"
>  	help
> diff --git a/drivers/w1/slaves/Makefile b/drivers/w1/slaves/Makefile
> index 990f400..f1f51f1 100644
> --- a/drivers/w1/slaves/Makefile
> +++ b/drivers/w1/slaves/Makefile
> @@ -4,6 +4,7 @@
>  
>  obj-$(CONFIG_W1_SLAVE_THERM)	+= w1_therm.o
>  obj-$(CONFIG_W1_SLAVE_SMEM)	+= w1_smem.o
> +obj-$(CONFIG_W1_SLAVE_DS2431)	+= w1_ds2431.o
>  obj-$(CONFIG_W1_SLAVE_DS2433)	+= w1_ds2433.o
>  obj-$(CONFIG_W1_SLAVE_DS2760)	+= w1_ds2760.o
>  obj-$(CONFIG_W1_SLAVE_BQ27000)	+= w1_bq27000.o
> -- 
> 1.6.1.3

-- 
	Evgeniy Polyakov
