Return-Path: <linux-kernel-owner+w=401wt.eu-S1759470AbZFWVf5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759470AbZFWVf5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:35:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZFWVfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:35:48 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:33595 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751392AbZFWVfs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:35:48 -0400
Date: Tue, 23 Jun 2009 23:29:37 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-usb@vger.kernel.org, avictor.za@gmail.com,
       linux-kernel@vger.kernel.org, david-b@pacbell.net,
       haavard.skinnemoen@atmel.com, patrice.vilchez@atmel.com,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3 v3] at91/USB: Add USB gadget driver selection for
 at91sam9g45 series
Message-ID: <20090623212937.GO23512@game.jcrosoft.org>
References: <200906190045.16496.david-b@pacbell.net>
 <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6af1745bf0de30efbd68addd05c2670311c7743a.1245775871.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5381801556061563756
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18:58 Tue 23 Jun     , Nicolas Ferre wrote:
> Add gadget USB drivers for at91sam9g45 series. Those SOC include
> high speed USB interfaces.
> The gadget driver is the already available atmel_usba_udc.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
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
same as ATMEL_FB
it will be really better to define it at the soc level

Best Regards,
J.
