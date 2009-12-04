Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbZLDJlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbZLDJlT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Dec 2009 04:41:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752528AbZLDJlR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Dec 2009 04:41:17 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51859 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbZLDJlQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Dec 2009 04:41:16 -0500
Date: Fri, 4 Dec 2009 10:41:22 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Amit Kucheria <amit.kucheria@canonical.com>
Cc: List Linux Kernel <linux-kernel@vger.kernel.org>,
       Dinh.Nguyen@freescale.com, s.hauer@pengutronix.de,
       grant.likely@secretlab.ca, r.herring@freescale.com,
       linux-arm-kernel@lists.infradead.org, daniel@caiaq.de,
       valentin.longchamp@epfl.ch
Subject: Re: [RFC][PATCH 02/10] arm: mxc: base support for Freescale i.MX51
	processor
Message-ID: <20091204094122.GC10910@pengutronix.de>
References: <cover.1259893118.git.amit.kucheria@canonical.com> <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6608c4dca645d87efce78ae0b7dbad265004f482.1259893118.git.amit.kucheria@canonical.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Dec 04, 2009 at 04:47:02AM +0200, Amit Kucheria wrote:
> Kconfig and Makefiles to enable the i.MX51 processor separated to help ease
> the review process
> 
> Signed-off-by: Amit Kucheria <amit.kucheria@canonical.com>
> ---
>  arch/arm/Makefile               |    1 +
>  arch/arm/mach-mx5/Kconfig       |   17 +++++++++++++++++
>  arch/arm/mach-mx5/Makefile      |    9 +++++++++
>  arch/arm/mach-mx5/Makefile.boot |    3 +++
>  arch/arm/plat-mxc/Kconfig       |    8 ++++++++
>  5 files changed, 38 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-mx5/Kconfig
>  create mode 100644 arch/arm/mach-mx5/Makefile
>  create mode 100644 arch/arm/mach-mx5/Makefile.boot
> 
> diff --git a/arch/arm/Makefile b/arch/arm/Makefile
> index a73caaf..daedbf2 100644
> --- a/arch/arm/Makefile
> +++ b/arch/arm/Makefile
> @@ -145,6 +145,7 @@ machine-$(CONFIG_ARCH_MX1)		:= mx1
>  machine-$(CONFIG_ARCH_MX2)		:= mx2
>  machine-$(CONFIG_ARCH_MX25)		:= mx25
>  machine-$(CONFIG_ARCH_MX3)		:= mx3
> +machine-$(CONFIG_ARCH_MX5)		:= mx5
>  machine-$(CONFIG_ARCH_NETX)		:= netx
>  machine-$(CONFIG_ARCH_NOMADIK)		:= nomadik
>  machine-$(CONFIG_ARCH_NS9XXX)		:= ns9xxx
> diff --git a/arch/arm/mach-mx5/Kconfig b/arch/arm/mach-mx5/Kconfig
> new file mode 100644
> index 0000000..80a749c
> --- /dev/null
> +++ b/arch/arm/mach-mx5/Kconfig
> @@ -0,0 +1,17 @@
> +if ARCH_MX5
> +
> +config ARCH_MX51
> +	bool
> +	default y
> +	select MXC_TZIC
> +	select ARCH_MXC_IOMUX_V3
> +
> +comment "MX5 platforms:"
> +
> +config MACH_MX51_BABBAGE
> +	bool "Support MX51 BABBAGE platforms"
> +	help
> +	  Include support for MX51 Babbage platform. This includes specific
> +	  configurations for the board and its peripherals.
> +
> +endif
> diff --git a/arch/arm/mach-mx5/Makefile b/arch/arm/mach-mx5/Makefile
> new file mode 100644
> index 0000000..e4cf91f
> --- /dev/null
> +++ b/arch/arm/mach-mx5/Makefile
> @@ -0,0 +1,9 @@
> +#
> +# Makefile for the linux kernel.
> +#
> +
> +# Object file lists.
> +obj-y   := cpu.o mm.o clock.o devices.o
I couldn't find arch/arm/mach-mx5/cpu.c neither in your series nor in
mainline.  Didn't check the others.  Is it just me?

Best regards
Uwe

-- 
Pengutronix e.K.                              | Uwe Kleine-König            |
Industrial Linux Solutions                    | http://www.pengutronix.de/  |
