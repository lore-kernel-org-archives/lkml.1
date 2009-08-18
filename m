Return-Path: <linux-kernel-owner+w=401wt.eu-S1752379AbZHRXoY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379AbZHRXoY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 19:44:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbZHRXoX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 19:44:23 -0400
Received: from mga12.intel.com ([143.182.124.36]:57159 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752011AbZHRXoX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 19:44:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,405,1246863600"; 
   d="scan'208";a="177442836"
Date: Wed, 19 Aug 2009 01:46:29 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm <akpm@linux-foundation.org>,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] mfd: fix mc13783 build error
Message-ID: <20090818234628.GC3378@sortiz.org>
References: <20090818184215.fdf1c7ae.sfr@canb.auug.org.au> <20090818152555.793773ad.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090818152555.793773ad.randy.dunlap@oracle.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Tue, Aug 18, 2009 at 03:25:55PM -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build errors due to missing Kconfig dependency:
Thanks, should be fixed now.

Cheers,
Samuel.


> mc13783-core.c:(.text+0x11bbaf): undefined reference to `spi_sync'
> mc13783-core.c:(.init.text+0xb6b3): undefined reference to `spi_register_driver'
> mc13783-core.c:(.devinit.text+0x1fd8b): undefined reference to `spi_setup'
> drivers/built-in.o:(.data+0x157c0): undefined reference to `spi_bus_type'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  drivers/mfd/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> --- linux-next-20090818.orig/drivers/mfd/Kconfig
> +++ linux-next-20090818/drivers/mfd/Kconfig
> @@ -240,6 +240,7 @@ config MFD_PCF50633
>  
>  config MFD_MC13783
>  	tristate "Support Freescale MC13783"
> +	depends on SPI_MASTER
>  	select MFD_CORE
>  	help
>  	  Support for the Freescale (Atlas) MC13783 PMIC and audio CODEC.
> 
> 
> 
> ---
> ~Randy
> LPC 2009, Sept. 23-25, Portland, Oregon
> http://linuxplumbersconf.org/2009/

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
