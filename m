Return-Path: <linux-kernel-owner+w=401wt.eu-S1752794AbYIAEZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794AbYIAEZU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2008 00:25:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750987AbYIAEZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Sep 2008 00:25:08 -0400
Received: from agminet01.oracle.com ([141.146.126.228]:17760 "EHLO
	agminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbYIAEZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2008 00:25:06 -0400
Date: Sun, 31 Aug 2008 21:24:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Matt LaPlante <kernel1@cyberdogtech.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] Kconfig cleanup including spelling and grammar
 touchups.
Message-Id: <20080831212445.22af3250.randy.dunlap@oracle.com>
In-Reply-To: <1220239702-15688-1-git-send-email-kernel1@cyberdogtech.com>
References: <1220239702-15688-1-git-send-email-kernel1@cyberdogtech.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Aug 2008 22:28:22 -0500 Matt LaPlante wrote:

> 
> Signed-off-by: Matt LaPlante <kernel1@cyberdogtech.com>
> ---
>  arch/arm/mach-omap1/Kconfig          |    4 ++--
>  arch/arm/mach-pxa/Kconfig            |    2 +-
>  arch/blackfin/Kconfig                |    6 +++---
>  arch/cris/Kconfig                    |    6 +++---
>  arch/cris/arch-v32/Kconfig           |    2 +-
>  arch/cris/arch-v32/drivers/Kconfig   |    2 +-
>  arch/cris/arch-v32/mach-fs/Kconfig   |    2 +-
>  arch/mips/Kconfig                    |    2 +-
>  arch/powerpc/Kconfig                 |    2 +-
>  arch/powerpc/platforms/Kconfig       |    2 +-
>  arch/powerpc/sysdev/bestcomm/Kconfig |    4 ++--
>  arch/sh/Kconfig                      |    4 ++--
>  arch/x86/Kconfig                     |    4 ++--
>  drivers/ata/Kconfig                  |    2 +-
>  drivers/base/Kconfig                 |    2 +-
>  drivers/gpio/Kconfig                 |    6 +++---
>  drivers/hwmon/Kconfig                |    2 +-
>  drivers/i2c/chips/Kconfig            |    4 ++--
>  drivers/input/Kconfig                |    2 +-
>  drivers/leds/Kconfig                 |    6 +++---
>  drivers/media/dvb/frontends/Kconfig  |    2 +-
>  drivers/misc/Kconfig                 |    8 ++++----
>  drivers/mmc/host/Kconfig             |    2 +-
>  drivers/serial/Kconfig               |    2 +-
>  drivers/usb/core/Kconfig             |    2 +-
>  drivers/usb/serial/Kconfig           |    4 ++--
>  fs/Kconfig                           |    2 +-
>  init/Kconfig                         |    6 +++++-
>  net/Kconfig                          |    2 +-
>  net/ipv6/Kconfig                     |   18 +++++++++---------
>  net/mac80211/Kconfig                 |    2 +-
>  net/netfilter/Kconfig                |    2 +-
>  32 files changed, 61 insertions(+), 57 deletions(-)
> 
> diff --git a/arch/arm/mach-omap1/Kconfig b/arch/arm/mach-omap1/Kconfig
> index 79f0b1f..c259ced 100644
> --- a/arch/arm/mach-omap1/Kconfig
> +++ b/arch/arm/mach-omap1/Kconfig
> @@ -93,9 +93,9 @@ config MACH_OMAP_PALMZ71
>  	bool "Palm Zire71"
>  	depends on ARCH_OMAP1 && ARCH_OMAP15XX
>  	help
> -	 Support for the Palm Zire71 PDA. To boot the kernel,
> +	 Support for the Palm Zire71 PDA. To boot the kernel

What's wrong with the comma?

>  	 you'll need a PalmOS compatible bootloader; check out
> -	 http://hackndev.com/palm/z71 for more informations.
> +	 http://hackndev.com/palm/z71 for more information.
>  	 Say Y here if you have such a PDA, say N otherwise.
>  
>  config MACH_OMAP_PALMTT

> diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
> index 4154ff1..4953f7b 100644
> --- a/arch/blackfin/Kconfig
> +++ b/arch/blackfin/Kconfig
> @@ -795,7 +795,7 @@ config C_B3PEN
>  	default n
>  
>  choice
> -	prompt"Enable Asynchonous Memory Banks"
> +	prompt"Enable Asynchronous Memory Banks"

Space is preferred, like:
	prompt "Enable Async..."

>  	default C_AMBEN_ALL
>  
>  config C_AMBEN

> diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> index 6318f6b..b1f3738 100644
> --- a/drivers/base/Kconfig
> +++ b/drivers/base/Kconfig
> @@ -54,7 +54,7 @@ config FIRMWARE_IN_KERNEL
>  	  such firmware, and do not wish to use an initrd.
>  
>  	  This single option controls the inclusion of firmware for
> -	  every driver which usees request_firmare() and ships its
> +	  every driver which usees request_firmware() and ships its

                             uses

>  	  firmware in the kernel source tree, to avoid a proliferation
>  	  of 'Include firmware for xxx device' options.
>  

> diff --git a/drivers/serial/Kconfig b/drivers/serial/Kconfig
> index 77cb342..2aaeb71 100644
> --- a/drivers/serial/Kconfig
> +++ b/drivers/serial/Kconfig
> @@ -1383,7 +1383,7 @@ config SERIAL_BFIN_SPORT
>  	depends on BLACKFIN && EXPERIMENTAL
>  	select SERIAL_CORE
>  	help
> -	  Enble support SPORT emulate UART on Blackfin series.
> +	  Enable SPORT emulate UART on Blackfin series.

Difficult to say which one is better....

>  
>  	  To compile this driver as a module, choose M here: the
>  	  module will be called bfin_sport_uart.

> diff --git a/init/Kconfig b/init/Kconfig
> index c11da38..0cd1edf 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -487,7 +487,11 @@ config PID_NS
>  	depends on NAMESPACES && EXPERIMENTAL
>  	help
>  	  Support process id namespaces.  This allows having multiple
> +<<<<<<< HEAD:init/Kconfig
>  	  process with the same pid as long as they are in different
> +=======
> +	  processes with the same pid as long as they are in different
> +>>>>>>> 00c0d3c... Fix misc small typos/grammar in Kconfigs.:init/Kconfig

eh??

>  	  pid namespaces.  This is a building block of containers.
>  
>  	  Unless you want to work with an experimental feature



Ack for the others.

---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/
