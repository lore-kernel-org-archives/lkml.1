Return-Path: <linux-kernel-owner+w=401wt.eu-S1758466AbYDJTkU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466AbYDJTkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:40:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752659AbYDJTkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:40:03 -0400
Received: from www.tglx.de ([62.245.132.106]:59672 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbYDJTkA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:40:00 -0400
Date: Thu, 10 Apr 2008 21:39:51 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] UIO: use menuconfig
Message-ID: <20080410193951.GC3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 02:37:01PM +0200, Uwe Kleine-König wrote:
> This allows configuring CONFIG_UIO without changing into the UIO submenu

I like it.

Signed-off-by: Hans J Koch <hjk@linutronix.de>

> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
>  drivers/uio/Kconfig |    8 ++------
>  1 files changed, 2 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index b778ed7..a899306 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -1,9 +1,7 @@
> -menu "Userspace I/O"
> -	depends on !S390
> -
> -config UIO
> +menuconfig UIO
>  	tristate "Userspace I/O drivers"
>  	default n
> +	depends on !S390
>  	help
>  	  Enable this to allow the userspace driver core code to be
>  	  built.  This code allows userspace programs easy access to
> @@ -25,5 +23,3 @@ config UIO_CIF
>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called uio_cif.
> -
> -endmenu
> -- 
> 1.5.4.5
