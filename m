Return-Path: <linux-kernel-owner+w=401wt.eu-S1752764AbZK3QJq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764AbZK3QJq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 11:09:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752291AbZK3QJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 11:09:45 -0500
Received: from rcsinet11.oracle.com ([148.87.113.123]:60662 "EHLO
	rgminet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751957AbZK3QJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 11:09:45 -0500
Message-ID: <4B13EE3D.4030704@oracle.com>
Date: Mon, 30 Nov 2009 08:09:33 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: greg@kroah.com, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH] staging: fix a silly typo
References: <20091130132432.27394.48685.stgit@localhost.localdomain>
In-Reply-To: <20091130132432.27394.48685.stgit@localhost.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4B13EE44.001D:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> (Resend #3)

> Signed-off-by: Alan Cox <alan@linux.intel.com>
> ---
I have also sent this patch a few times.

The problems are in Rusty Russell's quilt series/tree and he replied to me
that he fixed them, but they don't seem to be pushed yet....

Rusty?


>  drivers/staging/rtl8187se/r8180_core.c  |    2 +-
>  drivers/staging/rtl8192su/r8192U_core.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> 
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


-- 
~Randy
