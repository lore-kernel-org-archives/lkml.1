Return-Path: <linux-kernel-owner+w=401wt.eu-S1755570AbZESR32@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570AbZESR32 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 May 2009 13:29:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752880AbZESR3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 May 2009 13:29:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35765 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752005AbZESR3W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 May 2009 13:29:22 -0400
Date: Tue, 19 May 2009 10:24:27 -0700
From: Greg KH <gregkh@suse.de>
To: Alexander Beregalov <a.beregalov@gmail.com>
Cc: linux-next <linux-next@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: staging: cpc-usb: wrong Makefile path
Message-ID: <20090519172427.GB30522@suse.de>
References: <a4423d670905191009i450545f6le9c49e84c5ce94fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4423d670905191009i450545f6le9c49e84c5ce94fd@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 19, 2009 at 09:09:53PM +0400, Alexander Beregalov wrote:
> diff --git a/drivers/staging/Makefile b/drivers/staging/Makefile
> index 9492a6f..cc1aac2 100644
> --- a/drivers/staging/Makefile
> +++ b/drivers/staging/Makefile
> @@ -40,4 +40,4 @@ obj-$(CONFIG_PLAN9AUTH)               += p9auth/
>  obj-$(CONFIG_HECI)             += heci/
>  obj-$(CONFIG_LINE6_USB)                += line6/
>  obj-$(CONFIG_USB_SERIAL_QUATECH_ESU100)        += serqt_usb/
> -obj-$(CONFIG_USB_CPC)          += cpc_usb/
> +obj-$(CONFIG_USB_CPC)          += cpc-usb/

Heh, wierd, I wonder how it was working for me when I tested this...

thanks,

greg k-h
