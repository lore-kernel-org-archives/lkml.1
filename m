Return-Path: <linux-kernel-owner+w=401wt.eu-S1765229AbYBNHVe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765229AbYBNHVe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 02:21:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756897AbYBNHV0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 02:21:26 -0500
Received: from www.tglx.de ([62.245.132.106]:34936 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756354AbYBNHVZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 02:21:25 -0500
Date: Thu, 14 Feb 2008 08:21:14 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Alessandro Guido <alessandro.guido@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] Use menuconfig for CONFIG_UIO
Message-ID: <20080214082114.2c6117e3@dilbert.local>
In-Reply-To: <200802132328.19310.alessandro.guido@gmail.com>
References: <200802132328.19310.alessandro.guido@gmail.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Wed, 13 Feb 2008 23:28:19 +0100
schrieb Alessandro Guido <alessandro.guido@gmail.com>:

> Signed-off-by: Alessandro Guido <alessandro.guido@gmail.com>

Hi Alessandro,
thanks, but this was already done by Denis Cheng:

http://lkml.org/lkml/2008/2/2/60

I signed-off his patch, but AFAICS it hasn't been applied yet.
BTW, please CC Greg Kroah-Hartman as well if you send patches for UIO.

Thanks,
Hans

> 
> ---
> 
>  drivers/uio/Kconfig |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index b778ed7..dce4cae 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -1,8 +1,6 @@
> -menu "Userspace I/O"
> -	depends on !S390
> -
> -config UIO
> +menuconfig UIO
>  	tristate "Userspace I/O drivers"
> +	depends on !S390
>  	default n
>  	help
>  	  Enable this to allow the userspace driver core code to be
> @@ -25,5 +23,3 @@ config UIO_CIF
>  
>  	  To compile this driver as a module, choose M here: the
> module will be called uio_cif.
> -
> -endmenu
