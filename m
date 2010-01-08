Return-Path: <linux-kernel-owner+w=401wt.eu-S1754092Ab0AHAhv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab0AHAhv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 19:37:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753909Ab0AHAhv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 19:37:51 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:52538 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0AHAhu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 19:37:50 -0500
Date: Fri, 8 Jan 2010 11:37:48 +1100
From: Simon Horman <horms@verge.net.au>
To: Peter Huewe <PeterHuewe@gmx.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging/otus: Add select WEXT_PRIV to Kconfig to
 prevent build failure
Message-ID: <20100108003748.GJ2436@verge.net.au>
References: <201001072133.20487.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201001072133.20487.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 07, 2010 at 09:33:20PM +0100, Peter Huewe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Thu, 7 Jan 2010 21:13:55 +0100
> 
> Without WEXT_PRIV set the driver fails to build due to unknown fields in
> the iw_handler_def struct.
> Those fields are enclosed in WEXT_PRIV conditionals in the prototype
> of iw_handler_def in include/net/iw_handler.h
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
> Patch against Linux-next of Do 7. Jan 19:59:41 CET 2010
> 
> drivers/staging/otus/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/otus/Kconfig b/drivers/staging/otus/Kconfig
> index f6cc262..409e01c 100644
> --- a/drivers/staging/otus/Kconfig
> +++ b/drivers/staging/otus/Kconfig
> @@ -1,6 +1,8 @@
>  config OTUS
>  	tristate "Atheros OTUS 802.11n USB wireless support"
>  	depends on USB && WLAN && MAC80211
> +    select WIRELESS_EXT
> +    select WEXT_PRIV
>  	default N
>  	---help---
>  	  Enable support for Atheros 802.11n USB hardware:

Indentation seems to be broken here and in the next patch -
4 spaces instead of a tab.

