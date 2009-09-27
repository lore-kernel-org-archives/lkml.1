Return-Path: <linux-kernel-owner+w=401wt.eu-S1753649AbZI0Ixk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649AbZI0Ixk (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 04:53:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753415AbZI0Ixj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 04:53:39 -0400
Received: from cmpxchg.org ([85.214.51.133]:46168 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753385AbZI0Ixj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 04:53:39 -0400
Date: Sun, 27 Sep 2009 10:52:27 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Jaswinder Singh Rajput <jaswinder@kernel.org>
Cc: Johannes Weiner <jw@emlix.com>, Chris Zankel <chris@zankel.net>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xtensa: Remove unused CONFIG XTENSA_ISS_NETWORK and XTENSA_UNALIGNED_USER
Message-ID: <20090927085227.GA8022@cmpxchg.org>
References: <1253983999.4568.66.camel@ht.satnam>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253983999.4568.66.camel@ht.satnam>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 26, 2009 at 10:23:19PM +0530, Jaswinder Singh Rajput wrote:
> 
> Removed unused CONFIG XTENSA_ISS_NETWORK and XTENSA_UNALIGNED_USER from Kconfig and defconfigs
> 
> Reported-by: Robert P. J. Day <rpjday@crashcourse.ca>
> Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
> Cc: Johannes Weiner <jw@emlix.com>
> Cc: Chris Zankel <chris@zankel.net>
> ---
>  arch/xtensa/Kconfig                 |   13 -------------
>  arch/xtensa/configs/iss_defconfig   |    2 --
>  arch/xtensa/configs/s6105_defconfig |    2 --
>  3 files changed, 0 insertions(+), 17 deletions(-)
> 
> diff --git a/arch/xtensa/Kconfig b/arch/xtensa/Kconfig
> index ebe228d..328d0dd 100644
> --- a/arch/xtensa/Kconfig
> +++ b/arch/xtensa/Kconfig
> @@ -83,15 +83,6 @@ config XTENSA_VARIANT_S6000
>  	select XTENSA_CALIBRATE_CCOUNT
>  endchoice
>  
> -config XTENSA_UNALIGNED_USER

The code refers to CONFIG_UNALIGNED_USER, so a rename would be better
instead of removing it.

> -	bool "Unaligned memory access in use space"
> -	help
> -	  The Xtensa architecture currently does not handle unaligned
> -	  memory accesses in hardware but through an exception handler.
> -	  Per default, unaligned memory accesses are disabled in user space.
> -
> -	  Say Y here to enable unaligned memory access in user space.
> -
>  config PREEMPT
>  	bool "Preemptible Kernel"
>  	help
> @@ -122,9 +113,6 @@ config XTENSA_CALIBRATE_CCOUNT
>  config SERIAL_CONSOLE
>  	def_bool n
>  
> -config XTENSA_ISS_NETWORK
> -	def_bool n
> -

That one is of no use in the mainline kernel.  I guess out-of-tree
code uses it.

>  menu "Bus options"
>  
>  config PCI
> @@ -150,7 +138,6 @@ config XTENSA_PLATFORM_ISS
>  	bool "ISS"
>  	select XTENSA_CALIBRATE_CCOUNT
>  	select SERIAL_CONSOLE
> -	select XTENSA_ISS_NETWORK
>  	help
>  	  ISS is an acronym for Tensilica's Instruction Set Simulator.
>  
> diff --git a/arch/xtensa/configs/iss_defconfig b/arch/xtensa/configs/iss_defconfig
> index f198540..e6c1a29 100644
> --- a/arch/xtensa/configs/iss_defconfig
> +++ b/arch/xtensa/configs/iss_defconfig

No need to edit auto-generated files.
