Return-Path: <linux-kernel-owner+w=401wt.eu-S1758379AbYDJTpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758379AbYDJTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2008 15:45:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755332AbYDJTpW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Apr 2008 15:45:22 -0400
Received: from www.tglx.de ([62.245.132.106]:44310 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755305AbYDJTpV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2008 15:45:21 -0400
Date: Thu, 10 Apr 2008 21:45:14 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/4] UIO: wrap all uio drivers in "if UIO" and "endif"
Message-ID: <20080410194513.GD3193@local>
References: <1207831023-8583-1-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-2-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-3-git-send-email-Uwe.Kleine-Koenig@digi.com> <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1207831023-8583-4-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 10, 2008 at 02:37:02PM +0200, Uwe Kleine-König wrote:
> currently there is only one driver, but new entries don't need to depend
> explicitly on UIO.

Agreed.

Signed-off-by: Hans J Koch <hjk@linutronix.de>

> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>
> ---
>  drivers/uio/Kconfig |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index a899306..6bc2891 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -11,9 +11,11 @@ menuconfig UIO
>  
>  	  If you don't know what to do here, say N.
>  
> +if UIO
> +
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
> -	depends on UIO && PCI
> +	depends on PCI
>  	default n
>  	help
>  	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
> @@ -23,3 +25,5 @@ config UIO_CIF
>  
>  	  To compile this driver as a module, choose M here: the module
>  	  will be called uio_cif.
> +
> +endif
> -- 
> 1.5.4.5
