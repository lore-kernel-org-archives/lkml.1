Return-Path: <linux-kernel-owner+w=401wt.eu-S1756446AbYFPUNY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756446AbYFPUNY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 16:13:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753520AbYFPUMu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 16:12:50 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47122 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753414AbYFPUMt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 16:12:49 -0400
Message-ID: <4856C93B.7070804@garzik.org>
Date: Mon, 16 Jun 2008 16:12:43 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: David Woodhouse <dwmw2@infradead.org>
CC: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
       jaswinder@infradead.org
Subject: Re: [PATCH] ip2: use request_firmware()
References: <1213609751.26255.673.camel@pmac.infradead.org>
In-Reply-To: <1213609751.26255.673.camel@pmac.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Woodhouse wrote:
> diff --git a/drivers/char/Kconfig b/drivers/char/Kconfig
> index 595a925..b15d33d 100644
> --- a/drivers/char/Kconfig
> +++ b/drivers/char/Kconfig
> @@ -121,6 +121,13 @@ config COMPUTONE
>  	  To compile this driver as modules, choose M here: the
>  	  modules will be called ip2 and ip2main.
>  
> +config COMPUTONE_FIRMWARE
> +	bool "Firmware for Computone IntelliPort Plus serial devices"
> +	depends on COMPUTONE
> +	---help---
> +	  This builds the firmware for the Intelliport Plus devices into the
> +	  kernel image. Say 'N' and let it get loaded by udev.
> +


Anyone running 'make oldconfig' could easily skip over this and get a 
non-usable device, too.  Seems like a default 'y' is appropriate for the 
initial patch...

	Jeff





