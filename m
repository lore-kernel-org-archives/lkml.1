Return-Path: <linux-kernel-owner+w=401wt.eu-S1752681AbYCXDK2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752681AbYCXDK2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 23:10:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750896AbYCXDKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 23:10:20 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:19941 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750865AbYCXDKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 23:10:19 -0400
Date: Mon, 24 Mar 2008 12:09:45 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Cc: dwmw2 <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
       LKML <linux-kernel@vger.kernel.org>,
       MTD <linux-mtd@lists.infradead.org>,
       linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Subject: Re: [PATCH] 1/3 mtd: add Kbuild support and makefile support for Dreamcast VMU
Message-ID: <20080324030945.GA15872@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	Adrian McMenamin <adrian@newgolddream.dyndns.info>,
	dwmw2 <dwmw2@infradead.org>, Greg KH <greg@kroah.com>,
	LKML <linux-kernel@vger.kernel.org>,
	MTD <linux-mtd@lists.infradead.org>,
	linux-sh <linux-sh@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
References: <1206207805.6324.13.camel@localhost.localdomain> <1206208592.6324.19.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1206208592.6324.19.camel@localhost.localdomain>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 22, 2008 at 05:56:32PM +0000, Adrian McMenamin wrote:
> Signed-off-by: Adrian McMenamin <adrian@mcmen.demon.co.uk>
> ---
> diff -ruN a/drivers/mtd/maps/Kconfig b/drivers/mtd/maps/Kconfig
> --- a/drivers/mtd/maps/Kconfig	2008-03-22 17:26:24.000000000 +0000
> +++ b/drivers/mtd/maps/Kconfig	2008-03-22 17:20:45.000000000 +0000
> @@ -590,5 +590,19 @@
>  
>  	  This selection automatically selects the map_ram driver.
>  
> +config MTD_VMU_FLASH
> +	tristate "Dreamcast Visual Memory devices and clones"
> +	depends on SH_DREAMCAST
> +	select MAPLE
> +	help
> +	  Flash map driver for the SEGA Dreamcast Visual Memory Unit
> +	  and clones.
> +
> +	  Most Dreamcast users will have one of these and so will want
> +	  to say Y here.
> +
> +	  To compile this driver as a module choose M here: the module
> +	  will be called vmu-flash.
> +
>  endmenu
>  
1/3 and 2/3 should be merged, they're completely tied to each other and
are useless on their own.
