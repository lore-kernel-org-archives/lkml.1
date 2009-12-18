Return-Path: <linux-kernel-owner+w=401wt.eu-S932361AbZLRRqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361AbZLRRqk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:46:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932350AbZLRRqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:46:39 -0500
Received: from rcsinet12.oracle.com ([148.87.113.124]:43305 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbZLRRqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:46:38 -0500
Date: Fri, 18 Dec 2009 09:45:52 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: vt665x depend on WIRELESS
Message-Id: <20091218094552.f06aad32.randy.dunlap@oracle.com>
In-Reply-To: <1261156988-14346-1-git-send-email-a.beregalov@gmail.com>
References: <1261156988-14346-1-git-send-email-a.beregalov@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4B2BBFF9.0036:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 20:23:08 +0300 Alexander Beregalov wrote:

> Fix build error when NET or/and WIRELESS are not enabled.
> 
> Signed-off-by: Alexander Beregalov <a.beregalov@gmail.com>
> ---
>  drivers/staging/vt6655/Kconfig |    2 +-
>  drivers/staging/vt6656/Kconfig |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
> index 825bbc4..6a186be 100644
> --- a/drivers/staging/vt6655/Kconfig
> +++ b/drivers/staging/vt6655/Kconfig
> @@ -1,6 +1,6 @@
>  config VT6655
>     tristate "VIA Technologies VT6655 support"
> -   depends on PCI
> +   depends on PCI && WIRELESS
>     select WIRELESS_EXT
>     select WEXT_PRIV
>     ---help---
> diff --git a/drivers/staging/vt6656/Kconfig b/drivers/staging/vt6656/Kconfig
> index 87bcd26..6fceae4 100644
> --- a/drivers/staging/vt6656/Kconfig
> +++ b/drivers/staging/vt6656/Kconfig
> @@ -1,6 +1,6 @@
>  config VT6656
>  	tristate "VIA Technologies VT6656 support"
> -	depends on USB
> +	depends on USB && WIRELESS
>  	select WIRELESS_EXT
>  	select WEXT_PRIV
>  	---help---
> -- 

	depends on WLAN

would be better, and the patch has already been submitted to Greg...
I don't know where it is in his "system" though.


---
~Randy
