Return-Path: <linux-kernel-owner+w=401wt.eu-S935536AbYEVMis@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935536AbYEVMis (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 08:38:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759854AbYEVMil
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 08:38:41 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:7850 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759295AbYEVMik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 08:38:40 -0400
Date: Thu, 22 May 2008 16:38:38 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Chen Gong <G.Chen@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Tabi Timur <timur@freescale.com>
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the card
	detectline
Message-ID: <20080522123838.GA27149@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 19, 2008 at 11:02:13AM +0800, Chen Gong wrote:
> 
> > -----Original Message-----
> > From: linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org 
> > [mailto:linuxppc-dev-bounces+b11801=freescale.com@ozlabs.org] 
> > On Behalf Of Anton Vorontsov
> > Sent: 2008?5?17? 0:51
> > To: Kumar Gala; David Brownell; Pierre Ossman
> > Cc: linuxppc-dev@ozlabs.org; 
> > spi-devel-general@lists.sourceforge.net; 
> > linux-kernel@vger.kernel.org; Tabi Timur
> > Subject: [PATCH 3/4] [MMC] mmc_spi: add polling support for 
> > the card detectline
> > 
> > Some boards do not use interrupts on the CD line, so we want 
> > to poll the CD and see if there was a change. 1 second poll 
> > interval seems resonable.
> > 
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> >  drivers/mmc/host/mmc_spi.c  |   51 
> 
> I want to know whether every card working well ? Because I'm working
> For 83xx MMC-over-SPI support, the presented concrete methods I used as
> you do,
> but only 256M card seems good, 512M or 1G/2G card all have some problems

So far I don't have cards larger than 256M. Will try to get one though.

Thanks,

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
