Return-Path: <linux-kernel-owner+w=401wt.eu-S1754304Ab0AHAfd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754304Ab0AHAfd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:35:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753761Ab0AHAfc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:35:32 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:47979 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753824Ab0AHAfc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:35:32 -0500
Date: Fri, 8 Jan 2010 11:35:29 +1100
From: Simon Horman <horms@verge.net.au>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] staging/wlan-ng: Add select WEXT_PRIV to Kconfig
 to prevent build failure
Message-ID: <20100108003529.GA31142@verge.net.au>
References: <201001072133.20487.PeterHuewe@gmx.de>
 <201001072135.08745.PeterHuewe@gmx.de>
 <201001072136.38318.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001072136.38318.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:36:38PM +0100, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Thu, 7 Jan 2010 21:21:35 +0100
> 
> Without WEXT_PRIV set the p80211wext.c fails to build due to unknown fields in
> the iw_handler_def struct.
> Those fields are enclosed in WEXT_PRIV conditionals in the prototype
> of iw_handler_def in include/net/iw_handler.h
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Looks good to me.

Acked-by: Simon Horman <horms@verge.net.au>

> ---
> Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010
>  drivers/staging/wlan-ng/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/Kconfig b/drivers/staging/wlan-ng/Kconfig
> index 704ebd2..82fcc16 100644
> --- a/drivers/staging/wlan-ng/Kconfig
> +++ b/drivers/staging/wlan-ng/Kconfig
> @@ -2,6 +2,7 @@ config PRISM2_USB
>  	tristate "Prism2.5/3 USB driver"
>  	depends on WLAN && USB
>  	select WIRELESS_EXT
> +	select WEXT_PRIV
>  	default n
>  	---help---
>  	  This is the wlan-ng prism 2.5/3 USB driver for a wide range of
> -- 
> 1.6.4.4
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
