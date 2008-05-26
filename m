Return-Path: <linux-kernel-owner+w=401wt.eu-S1754174AbYEZPiB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754174AbYEZPiB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 11:38:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752233AbYEZPhw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 11:37:52 -0400
Received: from rtsoft3.corbina.net ([85.21.88.6]:12469 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752211AbYEZPhv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 11:37:51 -0400
Date: Mon, 26 May 2008 19:37:47 +0400
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Chen Gong <G.Chen@freescale.com>
Cc: Kumar Gala <galak@kernel.crashing.org>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Pierre Ossman <drzeus-mmc@drzeus.cx>, linuxppc-dev@ozlabs.org,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Tabi Timur <timur@freescale.com>
Subject: Re: [PATCH 3/4] [MMC] mmc_spi: add polling support for the
	carddetectline
Message-ID: <20080526153747.GA31663@polina.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <20080516165057.GC24196@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F16E6A@zch01exm21.fsl.freescale.net> <20080522123838.GA27149@polina.dev.rtsoft.ru> <58A20A281BAF1047B4EAE68DE5C0BDC2F176EF@zch01exm21.fsl.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <58A20A281BAF1047B4EAE68DE5C0BDC2F176EF@zch01exm21.fsl.freescale.net>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 22, 2008 at 09:44:57PM +0800, Chen Gong wrote:
[...]
> > > I want to know whether every card working well ? Because 
> > I'm working 
> > > For 83xx MMC-over-SPI support, the presented concrete 
> > methods I used 
> > > as you do, but only 256M card seems good, 512M or 1G/2G 
> > card all have 
> > > some problems
> > 
> > So far I don't have cards larger than 256M. Will try to get 
> > one though.
> > 
> Thanks, if you have any new test report pls contact me.

Just tested with Apacer 1GB MicroSD (connected through dumb adapter),
it works quite well here. I've successfully wrote 10 mb file onto ext2
formatted partition...

> BTW, a fews days ago Joakim Tjernlund made a heavy fix for 
> spi_mpc83xx.c to resolve clock glitch. But it looks no any impact
> for me, but maybe it has positive effect for you.

Yup, I use it.

Btw, which mmc driver are you using? The one from MPC8610HPCD
BSP or mainline's mmc_spi?

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
