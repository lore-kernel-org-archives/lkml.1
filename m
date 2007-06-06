Return-Path: <linux-kernel-owner+w=401wt.eu-S1758226AbXFFIAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758226AbXFFIAF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 04:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753174AbXFFH7y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 03:59:54 -0400
Received: from canuck.infradead.org ([209.217.80.40]:54114 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbXFFH7x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 03:59:53 -0400
Subject: Re: remove references to dead urls from mtd nand code.
From: David Woodhouse <dwmw2@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20070606054647.GA20850@redhat.com>
References: <20070606054647.GA20850@redhat.com>
Content-Type: text/plain
Date: Wed, 06 Jun 2007 08:59:48 +0100
Message-Id: <1181116788.25232.404.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-17.fc7.dwmw2.1) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-06-06 at 01:46 -0400, Dave Jones wrote:
> As reported in http://bugzilla.kernel.org/show_bug.cgi?id=7815
> this URL 404's.  Unless they're coming back, we should probably
> just remove them.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>
> 
> diff --git a/drivers/mtd/nand/Kconfig b/drivers/mtd/nand/Kconfig
> index f1d60b6..8f665bb 100644
> --- a/drivers/mtd/nand/Kconfig
> +++ b/drivers/mtd/nand/Kconfig
> @@ -7,8 +7,7 @@ menuconfig MTD_NAND
>  	select MTD_NAND_IDS
>  	help
>  	  This enables support for accessing all type of NAND flash
> -	  devices. For further information see
> -	  <http://www.linux-mtd.infradead.org/doc/nand.html>.

That one doesn't 404.

> +	  devices.
>  
>  if MTD_NAND
>  
> diff --git a/drivers/mtd/nand/nand_base.c b/drivers/mtd/nand/nand_base.c
> index 7e68203..3f406c7 100644
> --- a/drivers/mtd/nand/nand_base.c
> +++ b/drivers/mtd/nand/nand_base.c
> @@ -6,9 +6,6 @@
>   *   capable of working with almost all NAND chips currently available.
>   *   Basic support for AG-AND chips is provided.
>   *
> - *	Additional technical information is available on
> - *	http://www.linux-mtd.infradead.org/tech/nand.html

And that one should be changed to match the working one (and possibly be
enclosed in <...> too for consistency, although I've never been very
fond of that convention.

-- 
dwmw2

