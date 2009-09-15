Return-Path: <linux-kernel-owner+w=401wt.eu-S1758537AbZIOTfw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758537AbZIOTfw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:35:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZIOTfs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:35:48 -0400
Received: from www.tglx.de ([62.245.132.106]:33430 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754518AbZIOTfr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:35:47 -0400
Date: Tue, 15 Sep 2009 21:35:41 +0200
From: "Hans J. Koch" <hjk@linutronix.de>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Daniel Mack <daniel@caiaq.de>,
       "Hans J. Koch" <hjk@linutronix.de>
Subject: Re: [PATCH 04/20] UIO: remove 'default n' from Kconfig
Message-ID: <20090915193538.GA3630@local>
References: <20090915181247.GA32167@kroah.com> <1253041976-1111-4-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1253041976-1111-4-git-send-email-gregkh@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 15, 2009 at 12:12:40PM -0700, Greg Kroah-Hartman wrote:
> From: Daniel Mack <daniel@caiaq.de>
> 
> 'default n' is the default, there is no need for these lines.

That's quite true.

I must have forgotten to sign-off this one, you can add my signed-off-by,
if you like.

Thanks,
Hans

> 
> Signed-off-by: Daniel Mack <daniel@caiaq.de>
> Cc: Hans J. Koch <hjk@linutronix.de>
> Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Signed-off-by: Hans J. Koch <hjk@linutronix.de>

> ---
>  drivers/uio/Kconfig |    5 -----
>  1 files changed, 0 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/uio/Kconfig b/drivers/uio/Kconfig
> index 7f86534..45200fd 100644
> --- a/drivers/uio/Kconfig
> +++ b/drivers/uio/Kconfig
> @@ -1,7 +1,6 @@
>  menuconfig UIO
>  	tristate "Userspace I/O drivers"
>  	depends on !S390
> -	default n
>  	help
>  	  Enable this to allow the userspace driver core code to be
>  	  built.  This code allows userspace programs easy access to
> @@ -16,7 +15,6 @@ if UIO
>  config UIO_CIF
>  	tristate "generic Hilscher CIF Card driver"
>  	depends on PCI
> -	default n
>  	help
>  	  Driver for Hilscher CIF DeviceNet and Profibus cards.  This
>  	  driver requires a userspace component that handles all of the
> @@ -48,7 +46,6 @@ config UIO_PDRV_GENIRQ
>  
>  config UIO_SMX
>  	tristate "SMX cryptengine UIO interface"
> -	default n
>  	help
>  	  Userspace IO interface to the Cryptography engine found on the
>  	  Nias Digital SMX boards.  These will be available from Q4 2008
> @@ -61,7 +58,6 @@ config UIO_SMX
>  config UIO_AEC
>  	tristate "AEC video timestamp device"
>  	depends on PCI
> -	default n
>  	help
>  
>  	  UIO driver for the Adrienne Electronics Corporation PCI time
> @@ -78,7 +74,6 @@ config UIO_AEC
>  
>  config UIO_SERCOS3
>  	tristate "Automata Sercos III PCI card driver"
> -	default n
>  	help
>  	  Userspace I/O interface for the Sercos III PCI card from
>  	  Automata GmbH. The userspace part of this driver will be
> -- 
> 1.6.4.2
