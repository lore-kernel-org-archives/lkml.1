Return-Path: <linux-kernel-owner+w=401wt.eu-S1754650AbXLWNST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650AbXLWNST (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 08:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752566AbXLWNSD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 08:18:03 -0500
Received: from [212.12.190.108] ([212.12.190.108]:35914 "EHLO raad.intranet"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751309AbXLWNSB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 08:18:01 -0500
From: Al Boldi <a1426z@gawab.com>
To: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH] USB Kconfig: Reorganize USB Kconfig Menu
Date: Sun, 23 Dec 2007 16:15:21 +0300
User-Agent: KMail/1.5
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
       Andrew Morton <akpm@linux-foundation.org>
References: <200712231449.00862.a1426z@gawab.com> <Pine.LNX.4.64.0712231331270.21470@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712231331270.21470@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712231615.21003.a1426z@gawab.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 23 2007 14:49, Al Boldi wrote:
> >--- 23.a/drivers/usb/Kconfig
> >+++ 23.b/drivers/usb/Kconfig
> >@@ -2,8 +2,8 @@
> > # USB device configuration
> > #
> >
> >-menuconfig USB_SUPPORT
> >-	bool "USB support"
> >+config USB_SUPPORT
> >+	bool
> > 	depends on HAS_IOMEM
> > 	default y
> > 	---help---
>
> With this patch, is USB_SUPPORT still needed? It is not visible (anymore),
> always is y and no other options select/depend on it (according to
> Kconfig '/' function).

Well, I left it in, because of defconfig dependencies, and HAS_IOMEM is 
needed for a few archs.

> Looks good.


Thanks!

--
Al

