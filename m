Return-Path: <linux-kernel-owner+w=401wt.eu-S1753239AbZK3QOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753239AbZK3QOZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752055AbZK3QOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:14:23 -0500
Received: from kroah.org ([198.145.64.141]:33987 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753104AbZK3QOV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:14:21 -0500
Date: Mon, 30 Nov 2009 08:14:05 -0800
From: Greg KH <greg@kroah.com>
To: Alan Cox <alan@linux.intel.com>, Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: fix a silly typo
Message-ID: <20091130161405.GB15572@kroah.com>
References: <20091130132432.27394.48685.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091130132432.27394.48685.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 30, 2009 at 01:24:49PM +0000, Alan Cox wrote:
> (Resend #3)
> 
> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
> 
>  drivers/staging/rtl8187se/r8180_core.c  |    2 +-
>  drivers/staging/rtl8192su/r8192U_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

This is due to changes in Rusty's tree, not mine.  You aren't the only
one constantly sending this patch, Randy is as well.

Rusty, I thought you fixed these up?

thanks,

greg k-h

> diff --git a/drivers/staging/rtl8187se/r8180_core.c b/drivers/staging/rtl8187se/r8180_core.c
> index 5a6cd60..d74bf70 100644
> --- a/drivers/staging/rtl8187se/r8180_core.c
> +++ b/drivers/staging/rtl8187se/r8180_core.c
> @@ -79,7 +79,7 @@ MODULE_AUTHOR("Andrea Merello <andreamrl@tiscali.it>");
>  MODULE_DESCRIPTION("Linux driver for Realtek RTL8180 / RTL8185 WiFi cards");
>  
>  
> -module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
> +module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
>  module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
>  module_param(hwwep,int, S_IRUGO|S_IWUSR);
>  module_param(channels,int, S_IRUGO|S_IWUSR);
> diff --git a/drivers/staging/rtl8192su/r8192U_core.c b/drivers/staging/rtl8192su/r8192U_core.c
> index e24815f..0a052ea 100644
> --- a/drivers/staging/rtl8192su/r8192U_core.c
> +++ b/drivers/staging/rtl8192su/r8192U_core.c
> @@ -142,7 +142,7 @@ static int channels = 0x3fff;
>  
>  
>  
> -module_param_string(ifname, ifname, sizef(ifname), S_IRUGO|S_IWUSR);
> +module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
>  //module_param(hwseqnum,int, S_IRUGO|S_IWUSR);
>  module_param(hwwep,int, S_IRUGO|S_IWUSR);
>  module_param(channels,int, S_IRUGO|S_IWUSR);
