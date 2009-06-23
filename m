Return-Path: <linux-kernel-owner+w=401wt.eu-S1759670AbZFWVnN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759670AbZFWVnN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:43:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754532AbZFWVm7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:42:59 -0400
Received: from 42.mail-out.ovh.net ([213.251.189.42]:55656 "HELO
	42.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756180AbZFWVm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:42:58 -0400
Date: Tue, 23 Jun 2009 23:36:47 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: pierre@ossman.eu, avictor.za@gmail.com, linux-kernel@vger.kernel.org,
       haavard.skinnemoen@atmel.com, linux-arm-kernel@lists.arm.linux.org.uk,
       rob@emanuele.us
Subject: Re: [PATCH 2/2] AT91: atmel-mci: Platform configuration to the the
 atmel-mci driver
Message-ID: <20090623213647.GP23512@game.jcrosoft.org>
References: <95818a17c2b96d3769f4e1d3de26208647111758.1245778411.git.nicolas.ferre@atmel.com>
 <f8889fb59887a970581697beb313363a6a065606.1245778411.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8889fb59887a970581697beb313363a6a065606.1245778411.git.nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 5503117271780338540
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|H 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19:39 Tue 23 Jun     , Nicolas Ferre wrote:
> From: Rob Emanuele <rob@emanuele.us>
> 
> Created a modified version of the at91sam9g20 evaluation kit platform
> (board-sam9g20ek-2slot-mmc.c) and device support to make use of the updated
> atmel-mci driver.
> As the use of two slots modify GPIO pin allocation, we create another board
> file.
> 
> Signed-off-by: Rob Emanuele <rob@emanuele.us>
> [nicolas.ferre@atmel.com: printk, slot_count modification in at91sam9260_devices.c file]
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
> This requires getting the most updated arch/arm/tools/mach-types from
> http://www.arm.linux.org.uk/developer/machines/download.php to have the machine
> type for the at91sam9g20ek-2slot-mmc board.
> 
>  arch/arm/mach-at91/Kconfig                     |    7 +
>  arch/arm/mach-at91/Makefile                    |    1 +
>  arch/arm/mach-at91/at91sam9260_devices.c       |   96 ++++++++
>  arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c |  277 ++++++++++++++++++++++++
>  arch/arm/mach-at91/include/mach/board.h        |    5 +
>  5 files changed, 386 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-at91/board-sam9g20ek-2slot-mmc.c
> 
> diff --git a/arch/arm/mach-at91/Kconfig b/arch/arm/mach-at91/Kconfig
> index 323b47f..5c8d770 100644
> --- a/arch/arm/mach-at91/Kconfig
> +++ b/arch/arm/mach-at91/Kconfig
> @@ -276,6 +276,13 @@ config MACH_AT91SAM9G20EK
>  	help
>  	  Select this if you are using Atmel's AT91SAM9G20-EK Evaluation Kit.
>  
> +config MACH_AT91SAM9G20EK_2MMC
> +	bool "Atmel AT91SAM9G20-EK Evaluation Kit modified for 2 MMC Slots"
> +	depends on ARCH_AT91SAM9G20
> +	help
> +	  Select this if you are using an Atmel AT91SAM9G20-EK Evaluation Kit
> +	  Rev A or B modified for 2 MMC Slots.
create a new machine id for just such update :(
is this not possible to detect it and use the same machine?

Best Regards,
J.
