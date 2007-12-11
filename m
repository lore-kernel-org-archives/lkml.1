Return-Path: <linux-kernel-owner+w=401wt.eu-S1754470AbXLKQiw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbXLKQiw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 11:38:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751466AbXLKQio
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 11:38:44 -0500
Received: from wr-out-0506.google.com ([64.233.184.224]:39110 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488AbXLKQim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 11:38:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:to:cc:subject:message-id:in-reply-to:references:organization:x-mailer:mime-version:content-type:content-transfer-encoding:from;
        b=TEd66C6rDgDWdnfFTZgTb1I37CAE1N7qLheYc2yKqko0xaoxUjzLbJ26l1AvTiws54ER/MYUF0NWGcrA8z0fXBYD2Q7MF+qVxQXg7kIPxgDXtiNOFIGuE04mBUNPvVhtl6RblJ1gmyEiS3wOVaHSZkCq+tTF/ooCVFGASCWWdlQ=
Date: Tue, 11 Dec 2007 17:38:44 +0100
To: Kristoffer Ericson <Kristoffer.ericson@gmail.com>
Cc: Dmitry <dmitry.torokhov@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
       Russell King <linux@arm.linux.org.uk>,
       linux-main <linux-kernel@vger.kernel.org>
Subject: Re: (RESEND) [PATCH/HP6xx/HP7xx] Cleanup
 drivers/input/keyboard|touchscreen Kconfigs
Message-Id: <20071211173844.60542380.Kristoffer.ericson@gmail.com>
In-Reply-To: <20071205211926.5a9e261b.Kristoffer.ericson@gmail.com>
References: <20071205211926.5a9e261b.Kristoffer.ericson@gmail.com>
Organization: JLime
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.1; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
From: Kristoffer Ericson <kristoffer.ericson@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dmitry, could I get feedback on this?

On Wed, 5 Dec 2007 21:19:26 +0100
Kristoffer Ericson <Kristoffer.ericson@gmail.com> wrote:

> Greetings,
> 
> Oki, here is a more standard Kconfig setting for both platforms. Nothing major really.
> Note that touchscreen for hp6xx was called TOUCHSCREEN_HP600 and I've changed it to HP6XX to get it inline with everything else.
> 
> This should be pushed through dmitry I assume. Its against linux-2.6.git.
> 
> shortlog:
> This patch cleans up the drivers/input/keyboard|touchscreen Kconfigs for platforms hp6xx and hp7xx. It unifies the naming and descriptions.
> 
> signed-off-by: Kristoffer Ericson <kristoffer.ericson@gmail.com>
> 
> diff --git a/drivers/input/keyboard/Kconfig b/drivers/input/keyboard/Kconfig
> index dfa6592..7421b91 100644
> --- a/drivers/input/keyboard/Kconfig
> +++ b/drivers/input/keyboard/Kconfig
> @@ -209,22 +209,22 @@ config KEYBOARD_HIL
>  	  to your machine, so normally you should say Y here.
>  
>  config KEYBOARD_HP6XX
> -	tristate "HP Jornada 6XX Keyboard support"
> +	tristate "HP Jornada 6xx keyboard"
>  	depends on SH_HP6XX
>  	select INPUT_POLLDEV
>  	help
> -	  This adds support for the onboard keyboard found on
> -	  HP Jornada 620/660/680/690.
> +	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
> +	  support the built-in keyboard.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called jornada680_kbd.
>  
>  config KEYBOARD_HP7XX
> -	tristate "HP Jornada 7XX Keyboard Driver"
> +	tristate "HP Jornada 7xx keyboard"
>  	depends on SA1100_JORNADA720_SSP && SA1100_SSP
>  	help
> -	  Say Y here to add support for the HP Jornada 7xx (710/720/728)
> -	  onboard keyboard.
> +	  Say Y here if you have a HP Jornada 710/720/728 and want to 
> +	  support the built-in keyboard.
>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called jornada720_kbd.
> diff --git a/drivers/input/touchscreen/Kconfig b/drivers/input/touchscreen/Kconfig
> index fa8442b..3271dd3 100644
> --- a/drivers/input/touchscreen/Kconfig
> +++ b/drivers/input/touchscreen/Kconfig
> @@ -114,20 +114,18 @@ config TOUCHSCREEN_MK712
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called mk712.
>  
> -config TOUCHSCREEN_HP600
> -	tristate "HP Jornada 680/690 touchscreen"
> +config TOUCHSCREEN_HP6XX
> +	tristate "HP Jornada 6xx touchscreen"
>  	depends on SH_HP6XX && SH_ADC
>  	help
> -	  Say Y here if you have a HP Jornada 680 or 690 and want to
> +	  Say Y here if you have a HP Jornada 620/660/680/690 and want to
>            support the built-in touchscreen.
>  
> -	  If unsure, say N.
> -
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called hp680_ts_input.
>  
>  config TOUCHSCREEN_HP7XX
> -	tristate "HP Jornada 710/720/728 touchscreen"
> +	tristate "HP Jornada 7xx touchscreen"
>  	depends on SA1100_JORNADA720_SSP
>  	help
>  	  Say Y here if you have a HP Jornada 710/720/728 and want
> diff --git a/drivers/input/touchscreen/Makefile b/drivers/input/touchscreen/Makefile
> index 35d4097..75c2fe8 100644
> --- a/drivers/input/touchscreen/Makefile
> +++ b/drivers/input/touchscreen/Makefile
> @@ -12,7 +12,7 @@ obj-$(CONFIG_TOUCHSCREEN_ELO)		+= elo.o
>  obj-$(CONFIG_TOUCHSCREEN_FUJITSU)	+= fujitsu_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_MTOUCH)	+= mtouch.o
>  obj-$(CONFIG_TOUCHSCREEN_MK712)		+= mk712.o
> -obj-$(CONFIG_TOUCHSCREEN_HP600)		+= hp680_ts_input.o
> +obj-$(CONFIG_TOUCHSCREEN_HP6XX)		+= hp680_ts_input.o
>  obj-$(CONFIG_TOUCHSCREEN_HP7XX)		+= jornada720_ts.o
>  obj-$(CONFIG_TOUCHSCREEN_USB_COMPOSITE)	+= usbtouchscreen.o
>  obj-$(CONFIG_TOUCHSCREEN_PENMOUNT)	+= penmount.o
> 
