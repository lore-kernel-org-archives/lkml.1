Return-Path: <linux-kernel-owner+w=401wt.eu-S933955AbYETVMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933955AbYETVMk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2008 17:12:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761698AbYETVMa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 May 2008 17:12:30 -0400
Received: from www.tglx.de ([62.245.132.106]:35149 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760760AbYETVM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2008 17:12:29 -0400
Date: Tue, 20 May 2008 23:12:21 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <Uwe.Kleine-Koenig@digi.com>
Cc: "Hans J. Koch" <hjk@linutronix.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UIO: don't let UIO_CIF and UIO_SMX depend twice on UIO
Message-ID: <20080520211219.GG3220@local>
References: <20080520092312.GA10745@digi.com> <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1211275482-11249-1-git-send-email-Uwe.Kleine-Koenig@digi.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 20, 2008 at 11:24:41AM +0200, Uwe Kleine-König wrote:
> ae210f188614bb3d1ee3f19c64e28e3cdd44877c introduced a big "if UIO"/"endif"
> where all uio drivers are defined.  So know there is no need for them to
> depend explicitly on UIO.

Ahem, of course. Thanks!

> 
> Signed-off-by: Uwe Kleine-König <Uwe.Kleine-Koenig@digi.com>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/Kconfig |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index a4aaab9..78e139c 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -15,7 +15,7 @@ if UIO
>  
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
> -	depends on UIO && PCI
> +	depends on PCI
>  	default n
>  	help
>  	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
> @@ -28,7 +28,6 @@ config UIO_CIF
>  
>  config UIO_SMX
>  	tristate "SMX cryptengine UIO interface"
> -	depends on UIO
>  	default n
>  	help
>  	  Userspace IO interface to the Cryptography engine found on the
> -- 
> 1.5.5.1
