Return-Path: <linux-kernel-owner+w=401wt.eu-S1423367AbXBIXzb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423367AbXBIXzb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:55:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423360AbXBIXzb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:55:31 -0500
Received: from gprs189-60.eurotel.cz ([160.218.189.60]:2811 "EHLO spitz.ucw.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1946135AbXBIXza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:55:30 -0500
Date: Fri, 9 Feb 2007 20:54:52 +0000
From: Pavel Machek <pavel@ucw.cz>
To: Levitsky Maxim <maximlevitsky@yahoo.com>
Cc: linux-kernel@vger.kernel.org, tori@unhappy.mine.nu, netdev@vger.kernel.org
Subject: Re: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support
Message-ID: <20070209205451.GA3949@ucw.cz>
References: <549393.8054.qm@web38506.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <549393.8054.qm@web38506.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> From: Maxim Levitsky <maximlevitsky@yahoo.com>
> Subject: [PATCH] [NETDEV] [004] dmfe : Add suspend/resume support
> 
> Adds support for suspend/resume

Patch looks ok, but your mailer damaged it heavily.

> --- linux-2.6.20-mod/drivers/net/tulip/dmfe.c   2007-02-07 18:46:13.000000000 +0200
> +++ linux-2.6.20-test/drivers/net/tulip/dmfe.c  2007-02-07 18:50:52.000000000 +0200
> @@ -55,9 +55,6 @@
>  
>      TODO
>  
> -    Implement pci_driver::suspend() and pci_driver::resume()
> -    power management methods.
> -
>      Check on 64 bit boxes.
>      Check and fix on big endian boxes.
>  
> @@ -2027,11 +2024,59 @@ static struct pci_device_id dmfe_pci_tbl
>  MODULE_DEVICE_TABLE(pci, dmfe_pci_tbl);
>  
>  
> +
> +static int dmfe_suspend(struct pci_dev *pci_dev, pm_message_t state)
> +{

							Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
