Return-Path: <linux-kernel-owner+w=401wt.eu-S1756307AbYE0CMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307AbYE0CMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 22:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753163AbYE0CLw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 22:11:52 -0400
Received: from az33egw01.freescale.net ([192.88.158.102]:54737 "EHLO
	az33egw01.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088AbYE0CLw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 22:11:52 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] [MMC] mmc_spi: add polling support for thecarddetectline
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Tue, 27 May 2008 10:11:45 +0800
Message-ID: <58A20A281BAF1047B4EAE68DE5C0BDC2F5939E@zch01exm21.fsl.freescale.net>
In-Reply-To: <20080526153747.GA31663@polina.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] [MMC] mmc_spi: add polling support for thecarddetectline
Thread-Index: Aci/RnifA3kWpJO4Suem0n6Xj77R1wAV9pFQ
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net> <20080522123838.GA27149@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F176EF@zch01exm21.fsl.freescale.net> <20080526153747.GA31663@polina.dev.rtsoft.ru>
From: "Chen Gong" <G.Chen@freescale.com>
To: <avorontsov@ru.mvista.com>
Cc: "Kumar Gala" <galak@kernel.crashing.org>,
       "David Brownell" <dbrownell@users.sourceforge.net>,
       "Pierre Ossman" <drzeus-mmc@drzeus.cx>, <linuxppc-dev@ozlabs.org>,
       <spi-devel-general@lists.sourceforge.net>,
       <linux-kernel@vger.kernel.org>, "Tabi Timur" <timur@freescale.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 

> -----Original Message-----
> From: Anton Vorontsov [mailto:avorontsov@ru.mvista.com] 
> Sent: 2008?5?26? 23:38
> To: Chen Gong
> Cc: Kumar Gala; David Brownell; Pierre Ossman; 
> linuxppc-dev@ozlabs.org; 
> spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org; Tabi Timur
> Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support 
> for thecarddetectline
> 
> On Thu, May 22, 2008 at 09:44:57PM +0800, Chen Gong wrote:
> [...]
> > > > I want to know whether every card working well ? Because
> > > I'm working
> > > > For 83xx MMC-over-SPI support, the presented concrete
> > > methods I used
> > > > as you do, but only 256M card seems good, 512M or 1G/2G
> > > card all have
> > > > some problems
> > > 
> > > So far I don't have cards larger than 256M. Will try to get one 
> > > though.
> > > 
> > Thanks, if you have any new test report pls contact me.
> 
> Just tested with Apacer 1GB MicroSD (connected through dumb 
> adapter), it works quite well here. I've successfully wrote 
> 10 mb file onto ext2 formatted partition...

Oh, thanks for your info. The card I used is Kingston 1G SD card.

> 
> > BTW, a fews days ago Joakim Tjernlund made a heavy fix for 
> > spi_mpc83xx.c to resolve clock glitch. But it looks no any 
> impact for 
> > me, but maybe it has positive effect for you.
> 
> Yup, I use it.
> 
> Btw, which mmc driver are you using? The one from MPC8610HPCD 
> BSP or mainline's mmc_spi?

:-( the mmc driver now in the MPC8610HPCD BSP is ported from uClinux
 by me, it has many problems, because at that time MMC-over-SPI driver
doen't exist in the kernel.

