Return-Path: <linux-kernel-owner+w=401wt.eu-S935416AbYBCAMa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935416AbYBCAMa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 19:12:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753657AbYBCAMW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 19:12:22 -0500
Received: from www.tglx.de ([62.245.132.106]:42919 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031AbYBCAMV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 19:12:21 -0500
Date: Sun, 3 Feb 2008 01:12:07 +0100
From: =?UTF-8?B?SGFucy1Kw7xyZ2Vu?= Koch <hjk@linutronix.de>
To: Denis Cheng <crquan@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       cr_quan@163.com
Subject: Re: [PATCH 1/3] uio: Kconfig improvements
Message-ID: <20080203011207.292de4c3@dilbert.local>
In-Reply-To: <1201945897-32297-1-git-send-email-crquan@gmail.com>
References: <1201945897-32297-1-git-send-email-crquan@gmail.com>
Organization: Linutronix
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sat,  2 Feb 2008 17:51:35 +0800
schrieb Denis Cheng <crquan@gmail.com>:

Agreed.

> Signed-off-by: Denis Cheng <crquan@gmail.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/Kconfig |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index b778ed7..d8ab7e6 100644
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
> @@ -13,6 +11,8 @@ config UIO
>  
>  	  If you don't know what to do here, say N.
>  
> +if UIO
> +
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
>  	depends on UIO && PCI
> @@ -26,4 +26,4 @@ config UIO_CIF
>  	  To compile this driver as a module, choose M here: the
> module will be called uio_cif.
>  
> -endmenu
> +endif
