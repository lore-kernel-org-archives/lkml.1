Return-Path: <linux-kernel-owner+w=401wt.eu-S1756150AbXJIXNE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbXJIXNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2007 19:13:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750930AbXJIXMy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Oct 2007 19:12:54 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:59576 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750790AbXJIXMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2007 19:12:53 -0400
Date: Tue, 9 Oct 2007 16:12:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: (resubmitting) typo fixes for 2.6.23
Message-Id: <20071009161214.be33d7d7.randy.dunlap@oracle.com>
In-Reply-To: <20071009181355.3ae1cb3b.kernel1@cyberdogtech.com>
References: <20071009181355.3ae1cb3b.kernel1@cyberdogtech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.8.10; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Oct 2007 18:13:55 -0400 Matt LaPlante wrote:

> Most of these fixes were already submitted for old kernel versions, and were approved, but for some reason they never made it into the releases.  I've updated the changes for the 2.6.23 kernel and attached the resulting patch.  Because this is a consolidation of a couple old missed patches, it touches both Kconfigs and documentation texts.
> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> --

Hi Matt,
Mostly looks very good... a few nits below.


> diff -ru a/arch/ia64/Kconfig b/arch/ia64/Kconfig
> --- a/arch/ia64/Kconfig	2007-10-09 16:31:38.000000000 -0400
> +++ b/arch/ia64/Kconfig	2007-10-09 17:32:13.000000000 -0400
> @@ -443,9 +443,9 @@
>  config IA64_MC_ERR_INJECT
>  	tristate "MC error injection support"
>  	help
> -	  Selets whether support for MC error injection. By enabling the
> -	  support, kernel provide sysfs interface for user application to
> -	  call MC error injection PAL procedure to inject various errors.
> +	  Adds support for MC error injection. If enabled, the kernel 
> +          will provide a sysfs interface for user applications to

Use tab + 2 spaces to indent above instead of all spaces.

> +	  call MC error injection PAL procedures to inject various errors.
>  	  This is a useful tool for MCA testing.
>  
>  	  If you're unsure, do not select this option.
> diff -ru a/Documentation/arm/Samsung-S3C24XX/DMA.txt b/Documentation/arm/Samsung-S3C24XX/DMA.txt
> --- a/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-10-09 16:31:38.000000000 -0400
> +++ b/Documentation/arm/Samsung-S3C24XX/DMA.txt	2007-10-09 17:32:13.000000000 -0400
> @@ -17,15 +17,15 @@
>     channels to all sources, which means that some devices
>     have a restricted number of channels that can be used.
>  
> -   To allow flexibilty for each cpu type and board, the
> -   dma code can be given an dma ordering structure which
> +   To allow flexibility for each CPU type and board, the
> +   DMA code can be given a DMA ordering structure which
>     allows the order of channel search to be specified, as
>     well as allowing the prohibition of certain claims.
>  
>     struct s3c24xx_dma_order has a list of channels, and
> -   each channel within has a slot for a list of dma
> -   channel numbers. The slots are searched in order, for
> -   the presence of a dma channel number with DMA_CH_VALID
> +   each channel within has a slot for a list of DMA
> +   channel numbers. The slots are searched in order for
> +   the presence of a DMA channel number with DMA_CH_VALID
>     orred in.

      or-ed ?

>  
>     If the order has the flag DMA_CH_NEVER set, then after

> diff -ru a/Documentation/driver-model/devres.txt b/Documentation/driver-model/devres.txt
> --- a/Documentation/driver-model/devres.txt	2007-10-09 16:31:38.000000000 -0400
> +++ b/Documentation/driver-model/devres.txt	2007-10-09 17:32:13.000000000 -0400
> @@ -32,7 +32,7 @@
>  
>  For one reason or another, low level drivers don't receive as much
>  attention or testing as core code, and bugs on driver detach or
> -initilaization failure doesn't happen often enough to be noticeable.
> +initialization failure doesn't happen often enough to be noticeable.

                          don't

>  Init failure path is worse because it's much less travelled while
>  needs to handle multiple entry points.
>  
> diff -ru a/Documentation/input/iforce-protocol.txt b/Documentation/input/iforce-protocol.txt
> --- a/Documentation/input/iforce-protocol.txt	2007-10-09 16:31:38.000000000 -0400
> +++ b/Documentation/input/iforce-protocol.txt	2007-10-09 17:43:28.000000000 -0400
> @@ -234,12 +234,16 @@
>  
>  ** Appendix: How to study the protocol ? **
>  
> -1. Generate effects using the force editor provided with the DirectX SDK, or use Immersion Studio (freely available at their web site in the developer section: www.immersion.com)
> -2. Start a soft spying RS232 or USB (depending on where you connected your joystick/wheel). I used ComPortSpy from fCoder (alpha version!)
> +1. Generate effects using the force editor provided with the DirectX SDK, or 
> +use Immersion Studio (freely available at their web site in the developer section: 
> +www.immersion.com)
> +2. Start a soft spying RS232 or USB (depending on where you connected your 
> +joystick/wheel). I used ComPortSpy from fCoder (alpha version!)
>  3. Play the effect, and watch what happens on the spy screen.
>  
>  A few words about ComPortSpy:
> -At first glance, this soft seems, hum, well... buggy. In fact, data appear with a few seconds latency. Personnaly, I restart it every time I play an effect.
> +At first glance, this soft seems, hum, well... buggy. In fact, data appear with a 

                         software
Also, that line ends with a space... (9 of those found in the entire patch)

> +few seconds latency. Personally, I restart it every time I play an effect.
>  Remember it's free (as in free beer) and alpha!
>  
>  ** URLS **

> diff -ru a/Documentation/powerpc/eeh-pci-error-recovery.txt b/Documentation/powerpc/eeh-pci-error-recovery.txt
> --- a/Documentation/powerpc/eeh-pci-error-recovery.txt	2007-10-09 16:31:38.000000000 -0400
> +++ b/Documentation/powerpc/eeh-pci-error-recovery.txt	2007-10-09 17:32:13.000000000 -0400
> @@ -36,7 +36,7 @@
>  EEH was originally designed to guard against hardware failure, such
>  as PCI cards dying from heat, humidity, dust, vibration and bad
>  electrical connections. The vast majority of EEH errors seen in
> -"real life" are due to eithr poorly seated PCI cards, or,
> +"real life" are due to either poorly seated PCI cards, or,
>  unfortunately quite commonly, due device driver bugs, device firmware

                                 due to

>  bugs, and sometimes PCI card hardware bugs.
>  
> diff -ru a/Documentation/scsi/ibmmca.txt b/Documentation/scsi/ibmmca.txt
> --- a/Documentation/scsi/ibmmca.txt	2007-10-09 16:31:38.000000000 -0400
> +++ b/Documentation/scsi/ibmmca.txt	2007-10-09 17:32:13.000000000 -0400
> @@ -251,7 +251,7 @@
>     lun>0 or to non-existing devices, in order to satisfy the subsystem, if 
>     there are less than 15 SCSI-devices connected. In the case of more than 15 
>     devices, the dynamical mapping goes active. If the get_scsi[][] reports a 
> -   device to be existant, but it has no ldn assigned, it gets a ldn out of 7 
> +   device to be existent, but it has no ldn assigned, it gets a ldn out of 7

                                                                 an ldn

>     to 14. The numbers are assigned in cyclic order. Therefore it takes 8 
>     dynamical reassignments on the SCSI-devices, until a certain device 
>     loses its ldn again. This assures that dynamical remapping is avoided 

> diff -ru a/drivers/input/misc/Kconfig b/drivers/input/misc/Kconfig
> --- a/drivers/input/misc/Kconfig	2007-10-09 16:31:38.000000000 -0400
> +++ b/drivers/input/misc/Kconfig	2007-10-09 17:32:13.000000000 -0400
> @@ -70,9 +70,9 @@
>  	select LEDS_CLASS
>  	select CHECK_SIGNATURE
>  	help
> -	  Say Y here for support of Winstron laptop button interface, used on
> +	  Say Y here for support of Winstron laptop button interfaces, used on

                                    Wistron

>  	  laptops of various brands, including Acer and Fujitsu-Siemens. If
> -	  available, mail and wifi leds will be controlable via /sys/class/leds.
> +	  available, mail and wifi LEDs will be controllable via /sys/class/leds.
>  
>  	  To compile this driver as a module, choose M here: the module will
>  	  be called wistron_btns.
> diff -ru a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> --- a/drivers/mtd/maps/Kconfig	2007-10-09 16:31:38.000000000 -0400
> +++ b/drivers/mtd/maps/Kconfig	2007-10-09 17:32:13.000000000 -0400
> @@ -73,12 +73,12 @@
>  	depends on PMC_MSP && MTD_CFI
>  	select MTD_PARTITIONS
>  	help
> -	  This provides a 'mapping' driver which support the way
> +	  This provides a 'mapping' driver which supports the way
>            in which user-programmable flash chips are connected on the
> -          PMC-Sierra MSP eval/demo boards
> +          PMC-Sierra MSP eval/demo boards.

Use tab + 2 spaces for indent.

>  
>  choice
> -	prompt "Maximum mappable memory avialable for flash IO"
> +	prompt "Maximum mappable memory available for flash IO"
>  	depends on MTD_PMC_MSP_EVM
>  	default MSP_FLASH_MAP_LIMIT_32M
>  


Thanks.

---
~Randy
