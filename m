Return-Path: <linux-kernel-owner+w=401wt.eu-S1752875Ab0AHKSi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752875Ab0AHKSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:18:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018Ab0AHKSh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:18:37 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:57854 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab0AHKSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:18:36 -0500
Date: Fri, 8 Jan 2010 21:18:35 +1100
From: Simon Horman <horms@verge.net.au>
To: Peter =?utf-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v2] staging/otus: Add select WEXT_PRIV to Kconfig
 to prevent build failure
Message-ID: <20100108101835.GB27997@verge.net.au>
References: <201001072133.20487.PeterHuewe@gmx.de>
 <201001080913.19300.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001080913.19300.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 09:13:19AM +0100, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Fri, 8 Jan 2010 09:09:12 +0100
> 
> Without WEXT_PRIV set the driver fails to build due to unknown fields in
> the iw_handler_def struct.
> Those fields are enclosed in WEXT_PRIV conditionals in the prototype
> of iw_handler_def in include/net/iw_handler.h
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Simon Horman <horms@verge.net.au>

> ---
> This time without whitespace/indention errors. Sorry about that.
> 
>  drivers/staging/otus/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/otus/Kconfig b/drivers/staging/otus/Kconfig
> index f6cc262..e918134 100644
> --- a/drivers/staging/otus/Kconfig
> +++ b/drivers/staging/otus/Kconfig
> @@ -1,6 +1,8 @@
>  config OTUS
>  	tristate "Atheros OTUS 802.11n USB wireless support"
>  	depends on USB && WLAN && MAC80211
> +	select WIRELESS_EXT
> +	select WEXT_PRIV
>  	default N
>  	---help---
>  	  Enable support for Atheros 802.11n USB hardware:
> -- 
> 1.6.4.4
> 
