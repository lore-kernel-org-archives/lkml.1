Return-Path: <linux-kernel-owner+w=401wt.eu-S1757256AbYESDCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757256AbYESDCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 23:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750968AbYESDCZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 23:02:25 -0400
Received: from de01egw02.freescale.net ([192.88.165.103]:34770 "EHLO
	de01egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403AbYESDCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 23:02:24 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card detectline
Date: Mon, 19 May 2008 11:02:13 +0800
X-MimeOLE: Produced By Microsoft Exchange V6.5
Message-ID: <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net>
In-Reply-To: <20080516165057.GC24196@polina.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card detectline
Thread-Index: Aci3dUvcirSGxDHdRIewGRtsHsrJcgB5rykw
References: <20080516165057.GC24196@polina.dev.rtsoft.ru>
From: "Chen Gong" <G.Chen@freescale.com>
To: "Anton Vorontsov" <avorontsov@ru.mvista.com>,
       "Kumar Gala" <galak@kernel.crashing.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>
Cc: <linuxppc-dev@ozlabs.org>, <spi-devel-general@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, "Tabi Timur" <timur@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org 
> [mailto:linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org] 
> On Behalf Of Anton Vorontsov
> Sent: 2008?5?17? 0:51
> To: Kumar Gala; David Brownell; Pierre Ossman
> Cc: linuxppc-dev@ozlabs.org; 
> spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org; Tabi Timur
> Subject: [PATCH 3/4] [MMC] mmc_spi: add polling support for 
> the card detectline
> 
> Some boards do not use interrupts on the CD line, so we want 
> to poll the CD and see if there was a change. 1 second poll 
> interval seems resonable.
> 
> Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> ---
>  drivers/mmc/host/mmc_spi.c  |   51 

I want to know whether every card working well ? Because I'm working
For 83xx MMC-over-SPI support, the presented concrete methods I used as
you do,
but only 256M card seems good, 512M or 1G/2G card all have some problems
