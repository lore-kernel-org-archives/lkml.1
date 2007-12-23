Return-Path: <linux-kernel-owner+w=401wt.eu-S1754006AbXLWMhh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006AbXLWMhh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 07:37:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751355AbXLWMh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 07:37:28 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:41712 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751279AbXLWMh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 07:37:27 -0500
Date: Sun, 23 Dec 2007 13:37:26 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Al Boldi <a1426z@gawab.com>
cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
In-Reply-To: <200712231449.00862.a1426z@gawab.com>
Message-ID: <Pine.LNX.4.64.0712231331270.21470@fbirervta.pbzchgretzou.qr>
References: <200712231449.00862.a1426z@gawab.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 23 2007 14:49, Al Boldi wrote:
>--- 23.a/drivers/usb/Kconfig
>+++ 23.b/drivers/usb/Kconfig
>@@ -2,8 +2,8 @@
> # USB device configuration
> #
> 
>-menuconfig USB_SUPPORT
>-	bool "USB support"
>+config USB_SUPPORT
>+	bool
> 	depends on HAS_IOMEM
> 	default y
> 	---help---

With this patch, is USB_SUPPORT still needed? It is not visible (anymore),
always is y and no other options select/depend on it (according to
Kconfig '/' function).

Looks good.
