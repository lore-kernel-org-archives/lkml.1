Return-Path: <linux-kernel-owner+w=401wt.eu-S1753822AbZFZFWS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753822AbZFZFWS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jun 2009 01:22:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752380AbZFZFWF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jun 2009 01:22:05 -0400
Received: from smtp102.sbc.mail.gq1.yahoo.com ([67.195.15.61]:37333 "HELO
	smtp102.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751034AbZFZFWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jun 2009 01:22:04 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-Yahoo-SMTP:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=1Py/MGqlMiqg7jCN2/pYSHEDDuRV2LkcBvEl5eXjoAMRaWNJwzM1nF2kcDtWi9qyIqLztZiqNzsE9GIIR+ymwTzseTDg3Y7OFk0LtQF1G0qkdPlctsvaA0dwyPVqOvu7pScLnLB6bfOzmMCR8EXFn43ruJP2sXnN7jsruYSUqXk=  ;
X-Yahoo-SMTP: HIlLYKCswBDnjrunw3O.NnLyvismjGf1HBYfVTvuneM-
X-YMail-OSG: 8qzw8JwVM1n0R3fQGEdspFiFNrwz2DPIHqFCE9_uofHvNR8rrdjQIhZVjMzlTkx6hoocKMKqe7j55elHew.lpov5b6Cwf7ftNf_PKpiQ.dqHLPyCgJIK_SoITRjb1h.w9GZXcad1oSF.GfEAK67W_aloDaQhvNuHRAG3uvSMDzEIJP_u78L.gKCDD4n3pQPFESp.UJkah.ChU0zyxdAod7JjqDnRBVEF7ilZG3xrVjnfOv2n5sIL2qpouWsfFjgC_uoC6v5VuDgFRY2m3V7ls59rtm3eRz5ufJ.Sqto3keP7tjyXkjLUEUiRKwViMzhRGLA9nb9yYqTRuN6o4xw7inU_ko14Xg--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: Re: [PATCH 1/3 v3] at91/USB: Add USB gadget driver selection for at91sam9g45 series
Date: Thu, 25 Jun 2009 22:22:05 -0700
User-Agent: KMail/1.9.10
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, haavard.skinnemoen@atmel.com,
       patrice.vilchez@atmel.com
References: <200906190045.16496.david-b@pacbell.net> <1245776317-7134-1-git-send-email-nicolas.ferre@atmel.com>
In-Reply-To: <1245776317-7134-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200906252222.05258.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 June 2009, Nicolas Ferre wrote:
> Add gadget USB drivers for at91sam9g45 series. Those SOC include
> high speed USB interfaces.
> The gadget driver is the already available atmel_usba_udc.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

Acked-by: David Brownell <dbrownell@users.sourceforge.net>

SAM9G45 patches aren't in mainine yet, right?  So I
assume these can wait (maybe until 2.6.32-early).


> ---
> v2 -> v3: split patch to:
> - gadget
> - ohci
> - ehci
> 
>  drivers/usb/gadget/Kconfig |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
> index 080bb1e..9beea52 100644
> --- a/drivers/usb/gadget/Kconfig
> +++ b/drivers/usb/gadget/Kconfig
> @@ -124,7 +124,7 @@ choice
>  
>  config USB_GADGET_AT91
>  	boolean "Atmel AT91 USB Device Port"
> -	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9
> +	depends on ARCH_AT91 && !ARCH_AT91SAM9RL && !ARCH_AT91CAP9 && !ARCH_AT91SAM9G45
>  	select USB_GADGET_SELECTED
>  	help
>  	   Many Atmel AT91 processors (such as the AT91RM2000) have a
> @@ -143,7 +143,7 @@ config USB_AT91
>  config USB_GADGET_ATMEL_USBA
>  	boolean "Atmel USBA"
>  	select USB_GADGET_DUALSPEED
> -	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL
> +	depends on AVR32 || ARCH_AT91CAP9 || ARCH_AT91SAM9RL || ARCH_AT91SAM9G45
>  	help
>  	  USBA is the integrated high-speed USB Device controller on
>  	  the AT32AP700x, some AT91SAM9 and AT91CAP9 processors from Atmel.
> -- 
> 1.5.3.7
> 
> 


