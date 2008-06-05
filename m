Return-Path: <linux-kernel-owner+w=401wt.eu-S1755148AbYFEIqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148AbYFEIqA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2008 04:46:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753019AbYFEIpw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jun 2008 04:45:52 -0400
Received: from host2.marvell.com ([65.219.4.2]:35722 "EHLO maili.marvell.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752875AbYFEIpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2008 04:45:52 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Subject: RE: [PATCH] spi: fix list scan success verification in PXA ssp driver
Date: Thu, 5 Jun 2008 01:45:47 -0700
Message-ID: <E913911567467945BBEB9277E27868B0D6A414@msiexch01.marvell.com>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH] spi: fix list scan success verification in PXA ssp driver
thread-index: AcjG51ujSSvVOGcPSWODK2LCONH8ZwAADZ+Q
References: <Pine.LNX.4.64.0806051027340.6598@axis700.grange>
From: "Eric Miao" <ymiao3@marvell.com>
To: "Guennadi Liakhovetski" <g.liakhovetski@pengutronix.de>,
       <linux-kernel@vger.kernel.org>
Cc: <dbrownell@users.sourceforge.net>,
       <spi-devel-general@lists.sourceforge.net>,
       "Russell King" <rmk@arm.linux.org.uk>,
       <linux-arm-kernel@lists.arm.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id m558k5Hl022003

Acked-by: Eric Miao <eric.miao@marvell.com>

And this should really go through the ARM tree, please submit the patch
to RMK's patch system. Thanks.

Cheers
- eric

> -----Original Message-----
> From: Guennadi Liakhovetski [mailto:g.liakhovetski@pengutronix.de]
> Sent: Thursday, June 05, 2008 4:37 PM
> To: linux-kernel@vger.kernel.org
> Cc: dbrownell@users.sourceforge.net; Eric Miao;
> spi-devel-general@lists.sourceforge.net
> Subject: [PATCH] spi: fix list scan success verification in PXA ssp driver
> 
> The list search success check in arch/arm/mach-pxa/ssp.c is wrong: for
> example, it didn't recognise failure for me when I requested port 0.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@pengutronix.de>
> 
> ---
> 
>  arch/arm/mach-pxa/ssp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6/arch/arm/mach-pxa/ssp.c
> ===================================================================
> --- linux-2.6.orig/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:26.000000000
> +0200
> +++ linux-2.6/arch/arm/mach-pxa/ssp.c	2008-06-04 12:11:50.000000000 +0200
> @@ -330,7 +330,7 @@
> 
>  	mutex_unlock(&ssp_lock);
> 
> -	if (ssp->port_id != port)
> +	if (&ssp->node == &ssp_list)
>  		return NULL;
> 
>  	return ssp;

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
