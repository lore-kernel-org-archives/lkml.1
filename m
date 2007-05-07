Return-Path: <linux-kernel-owner+w=401wt.eu-S1753607AbXEGBow@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607AbXEGBow (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 21:44:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753606AbXEGBow
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 21:44:52 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:4236 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753521AbXEGBov (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 21:44:51 -0400
Date: Mon, 7 May 2007 03:44:37 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Krzysztof Halasa <khc@pm.waw.pl>
cc: Jeff Garzik <jeff@garzik.org>, Russell King <rmk@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       linux-arm-kernel@lists.arm.linux.org.uk
Subject: Re: [PATCH 1/3] WAN Kconfig: change "depends on HDLC" to "select"
In-Reply-To: <m3y7k1biov.fsf@maximus.localdomain>
Message-ID: <Pine.LNX.4.64.0705070343330.2733@scrub.home>
References: <m3abwhcy74.fsf@maximus.localdomain> <m3y7k1biov.fsf@maximus.localdomain>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 7 May 2007, Krzysztof Halasa wrote:

> Allow enabling WAN drivers without selecting generic HDLC first,
> HDLC will be selected automatically.
> 
> Signed-off-by: Krzysztof Halasa <khc@pm.waw.pl>
> 
> diff --git a/drivers/net/wan/Kconfig b/drivers/net/wan/Kconfig
> index 8897f53..3a2fe82 100644
> --- a/drivers/net/wan/Kconfig
> +++ b/drivers/net/wan/Kconfig
> @@ -171,7 +171,8 @@ comment "X.25/LAPB support is disabled"
>  
>  config PCI200SYN
>  	tristate "Goramo PCI200SYN support"
> -	depends on HDLC && PCI
> +	depends on PCI
> +	select HDLC
>  	help
>  	  Driver for PCI200SYN cards by Goramo sp. j.
>  

What's the advantage? The HDLC option is directly before this?

bye, Roman
