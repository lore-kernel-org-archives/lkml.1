Return-Path: <linux-kernel-owner+w=401wt.eu-S1761502AbYCFGgW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761502AbYCFGgW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2008 01:36:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756858AbYCFGgI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Mar 2008 01:36:08 -0500
Received: from gateway.drzeus.cx ([85.8.24.16]:55641 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756772AbYCFGgH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2008 01:36:07 -0500
Date: Thu, 6 Mar 2008 07:34:32 +0100
From: Pierre Ossman <drzeus-list@drzeus.cx>
To: me@felipebalbi.com
Cc: Carlos Aguiar <carlos.aguiar@indt.org.br>,
       Tony Lindgren <tony@atomide.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 05/18] MMC: OMAP: Introduce new multislot structure and
 change driver to use it
Message-ID: <20080306073432.4206d50e@mjolnir.drzeus.cx>
In-Reply-To: <20080305205408.GA16229@kedavra.cpe.vivax.com.br>
References: <479E27EB.3040502@indt.org.br>
	<20080207183744.1491c995@poseidon.drzeus.cx>
	<20080305205408.GA16229@kedavra.cpe.vivax.com.br>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.12.8; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Mar 2008 22:54:09 +0200
Felipe Balbi <me@felipebalbi.com> wrote:

> 
> Not nightmare. OMAP1/2 have mmc/sd/sdio controller supporting one or
> more mmc cards sharing the same bus.
> 

Do you have some docs to that effect? All that's been presented to me so far is a standard, one port controller with a mux in front of it. Under that definition, all controllers support an infinite number of cards.

> > > +
> > > +	mmc->caps = MMC_CAP_MULTIWRITE | MMC_CAP_MMC_HIGHSPEED |
> > > +		    MMC_CAP_SD_HIGHSPEED;
> > 
> > This is also unrelated. From what I've seen, the OMAP is a SD controller and does not support high speed MMC. The fact that you also conditionally set the max frequency later also suggests that this code is entirely incorrect.
> > 
> 
> Not true. I can't show you not even parts of the technical documentation
> but OMAP has mmc/sd/sdio controller. On OMAP1/2 it handles several mmc
> cards sharing the same bus.
> 

I'm afraid empirical data is insufficient. Show me a data sheet saying that OMAP controllers are designed in accordance with the newer MMC specs and I'll be happy.

And you'll have to do a lot better than that to convince me that older OMAP controllers are designed for standards that were written after the chips were released (i.e. high speed bus timings).

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org
