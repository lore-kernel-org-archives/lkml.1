Return-Path: <linux-kernel-owner+w=401wt.eu-S1764648AbYEVNpV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764648AbYEVNpV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 09:45:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754421AbYEVNpJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 09:45:09 -0400
Received: from az33egw02.freescale.net ([192.88.158.103]:63688 "EHLO
	az33egw02.freescale.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbYEVNpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 09:45:08 -0400
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH 3/4] [MMC] mmc_spi: add polling support for the carddetectline
X-MimeOLE: Produced By Microsoft Exchange V6.5
Date: Thu, 22 May 2008 21:44:57 +0800
Message-ID: <58A20A281BAF1047B4EAE68DE5C0BDC2F176EF@zch01exm21.fsl.freescale.net>
In-Reply-To: <20080522123838.GA27149@polina.dev.rtsoft.ru>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Thread-Topic: [PATCH 3/4] [MMC] mmc_spi: add polling support for the carddetectline
Thread-Index: Aci8CMdRxik0uCeSQhq1GqJJzy+/wAACBy+w
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net> <20080522123838.GA27149@polina.dev.rtsoft.ru>
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
> Sent: 2008?5?22? 20:39
> To: Chen Gong
> Cc: Kumar Gala; David Brownell; Pierre Ossman; 
> linuxppc-dev@ozlabs.org; 
> spi-devel-general@lists.sourceforge.net; 
> linux-kernel@vger.kernel.org; Tabi Timur
> Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support 
> for the carddetectline
> 
> On Mon, May 19, 2008 at 11:02:13AM +0800, Chen Gong wrote:
> > 
> > > -----Original Message-----
> > > From: linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org
> > > [mailto:linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org]
> > > On Behalf Of Anton Vorontsov
> > > Sent: 2008?5?17? 0:51
> > > To: Kumar Gala; David Brownell; Pierre Ossman
> > > Cc: linuxppc-dev@ozlabs.org;
> > > spi-devel-general@lists.sourceforge.net;
> > > linux-kernel@vger.kernel.org; Tabi Timur
> > > Subject: [PATCH 3/4] [MMC] mmc_spi: add polling support 
> for the card 
> > > detectline
> > > 
> > > Some boards do not use interrupts on the CD line, so we 
> want to poll 
> > > the CD and see if there was a change. 1 second poll 
> interval seems 
> > > resonable.
> > > 
> > > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > > ---
> > >  drivers/mmc/host/mmc_spi.c  |   51 
> > 
> > I want to know whether every card working well ? Because 
> I'm working 
> > For 83xx MMC-over-SPI support, the presented concrete 
> methods I used 
> > as you do, but only 256M card seems good, 512M or 1G/2G 
> card all have 
> > some problems
> 
> So far I don't have cards larger than 256M. Will try to get 
> one though.
> 
Thanks, if you have any new test report pls contact me.

BTW, a fews days ago Joakim Tjernlund made a heavy fix for 
spi_mpc83xx.c to resolve clock glitch. But it looks no any impact
for me, but maybe it has positive effect for you.
