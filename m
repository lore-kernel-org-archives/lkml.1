Return-Path: <linux-kernel-owner+w=401wt.eu-S1752807Ab0AHKS2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab0AHKS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jan 2010 05:18:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752018Ab0AHKS1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Jan 2010 05:18:27 -0500
Received: from kirsty.vergenet.net ([202.4.237.240]:57841 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751891Ab0AHKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jan 2010 05:18:26 -0500
Date: Fri, 8 Jan 2010 21:18:25 +1100
From: Simon Horman <horms@verge.net.au>
To: Peter =?utf-8?B?SMO8d2U=?= <PeterHuewe@gmx.de>
Cc: devel@driverdev.osuosl.org, Greg Kroah-Hartman <gregkh@suse.de>,
       devel@driverdev.osuosl.org, Randy Dunlap <randy.dunlap@oracle.com>,
       linux-kernel@vger.kernel.org,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH 2/3 v2] staging/rtl8192u: Add select WEXT_PRIV to
 Kconfig to prevent build failure
Message-ID: <20100108101822.GA27997@verge.net.au>
References: <201001072133.20487.PeterHuewe@gmx.de>
 <201001072135.08745.PeterHuewe@gmx.de>
 <201001080914.39084.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201001080914.39084.PeterHuewe@gmx.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 08, 2010 at 09:14:38AM +0100, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> Date: Fri, 8 Jan 2010 09:10:13 +0100
> 
> Without WEXT_PRIV set the driver fails to build due to unknown fields in
> the iw_handler_def struct.
> Those fields are enclosed in WEXT_PRIV conditionals in the prototype
> of iw_handler_def in include/net/iw_handler.h
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Acked-by: Simon Horman <horms@verge.net.au>

depends on WIRELESS_EXT should be select WIRELESS_EXT.
Do you want to handle that?

> ---
> This time without whitespace error  - sorry about that.
> 
>  drivers/staging/rtl8192u/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/Kconfig b/drivers/staging/rtl8192u/Kconfig
> index 9913ab8..d7bc35c 100644
> --- a/drivers/staging/rtl8192u/Kconfig
> +++ b/drivers/staging/rtl8192u/Kconfig
> @@ -2,5 +2,6 @@ config RTL8192U
>  	tristate "RealTek RTL8192U Wireless LAN NIC driver"
>  	depends on PCI && WLAN && USB
>  	depends on WIRELESS_EXT
> +	select WEXT_PRIV
>  	default N
>  	---help---
> -- 
> 1.6.4.4
