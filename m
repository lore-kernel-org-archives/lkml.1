Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYH0JSZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYH0JSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2008 05:18:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753434AbYH0JSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Aug 2008 05:18:08 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:45216 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752903AbYH0JSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2008 05:18:07 -0400
Message-ID: <48B51BCB.60402@garzik.org>
Date: Wed, 27 Aug 2008 05:18:03 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.16 (X11/20080723)
MIME-Version: 1.0
To: Bryan Wu <cooloney@kernel.org>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 1/1] netdev: Blackfin EMAC Driver: the BF526 also supports
 the MAC, so updates things accordingly
References: <1219808877-15168-1-git-send-email-cooloney@kernel.org>
In-Reply-To: <1219808877-15168-1-git-send-email-cooloney@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bryan Wu wrote:
> From: Mike Frysinger <vapier.adi@gmail.com>
> 
> Signed-off-by: Mike Frysinger <vapier.adi@gmail.com>
> Signed-off-by: Bryan Wu <cooloney@kernel.org>
> ---
>  drivers/net/Kconfig |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
> index a5c141c..4a11296 100644
> --- a/drivers/net/Kconfig
> +++ b/drivers/net/Kconfig
> @@ -822,14 +822,14 @@ config ULTRA32
>  	  will be called smc-ultra32.
>  
>  config BFIN_MAC
> -	tristate "Blackfin 527/536/537 on-chip mac support"
> -	depends on NET_ETHERNET && (BF527 || BF537 || BF536)
> +	tristate "Blackfin on-chip MAC support"
> +	depends on NET_ETHERNET && (BF526 || BF527 || BF536 || BF537)
>  	select CRC32
>  	select MII
>  	select PHYLIB
>  	select BFIN_MAC_USE_L1 if DMA_UNCACHED_NONE
>  	help
> -	  This is the driver for blackfin on-chip mac device. Say Y if you want it
> +	  This is the driver for Blackfin on-chip mac device. Say Y if you want it
>  	  compiled into the kernel. This driver is also available as a module
>  	  ( = code which can be inserted in and removed from the running kernel
>  	  whenever you want). The module will be called bfin_mac.

applied

