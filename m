Return-Path: <linux-kernel-owner+w=401wt.eu-S1752866AbYKXJXf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752866AbYKXJXf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2008 04:23:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKXJX1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Nov 2008 04:23:27 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:54605 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580AbYKXJX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2008 04:23:27 -0500
Subject: Re: w35und: fix Kconfig
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Pavel Machek <pavel@suse.cz>
Cc: kernel list <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
In-Reply-To: <20081124091829.GA30292@elf.ucw.cz>
References: <20081124091829.GA30292@elf.ucw.cz>
Date: Mon, 24 Nov 2008 11:25:02 +0200
Message-Id: <1227518703.3718.60.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-11-24 at 10:18 +0100, Pavel Machek wrote:
> 4KSTACK dependency was needed when driver carried its own softmac
> layer. That layer is gone, and functions have reasonably small stack
> footprint -> dependency can be removed.
> 
> Add better description of hardware this driver is targetted at.
> 
> Signed-off-by: Pavel Machek <pavel@suse.cz>

While I don't have the hardware to test this, I haven't seen anything in
the driver code either that abuses the kernel stack too badly.

Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>

> 
> --- gregkh-ofic/drivers/staging/winbond/Kconfig	2008-11-19 11:39:38.000000000 +0100
> +++ gregkh/drivers/staging/winbond/Kconfig	2008-11-19 12:26:57.000000000 +0100
> @@ -1,7 +1,11 @@
>  config W35UND
> -	tristate "Winbond driver"
> -	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL && !4KSTACKS
> +	tristate "IS89C35 WLAN USB driver"
> +	depends on MAC80211 && WLAN_80211 && USB && EXPERIMENTAL
>  	default n
>  	---help---
> -	  This is highly experimental driver for winbond wifi card on some Kohjinsha notebooks
> -	  Check http://code.google.com/p/winbondport/ for new version
> +	  This is highly experimental driver for Winbond WIFI card.
> +
> +	  HW is present in some Kohjinsha subnotebooks, and in some 
> +	  stand-alone USB modules. Chipset name seems to be w89c35d.
> +
> +	  Check http://code.google.com/p/winbondport/ for new version.
> 

