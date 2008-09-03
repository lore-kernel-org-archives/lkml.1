Return-Path: <linux-kernel-owner+w=401wt.eu-S1753470AbYICQu0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753470AbYICQu0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 12:50:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752077AbYICQuP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 12:50:15 -0400
Received: from metis.extern.pengutronix.de ([83.236.181.26]:55502 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752005AbYICQuO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 12:50:14 -0400
Date: Wed, 3 Sep 2008 18:50:11 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [MMC] Multiple cards on one host
Message-ID: <20080903165011.GG4941@pengutronix.de>
References: <20080903084343.GF4941@pengutronix.de> <20080903161102.004f6f9e@mjolnir.drzeus.cx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080903161102.004f6f9e@mjolnir.drzeus.cx>
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 16:42:57 up 78 days, 17 min, 53 users,  load average: 0.07, 0.04,
	0.07
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 10.1.1.3
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.extern.pengutronix.de); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 03, 2008 at 04:11:02PM +0200, Pierre Ossman wrote:
> On Wed, 3 Sep 2008 10:43:43 +0200
> Sascha Hauer <s.hauer@pengutronix.de> wrote:
> 
> > Hi,
> > 
> > I have a board (PXA based) which has two SD slots. It uses a gpio to
> > switch between the slots. In times when the MMC subsystem implemented
> > the bus topology our customer used this fact to connect the two slots on
> > a single host (although it was never intended to work with SD cards, it
> > seemed to work). Any idea how to implement this on recent kernels? I
> > thought about registering two hosts in pxamci.c, but this seems quite
> > hacky and I suppose I'll run into locking trouble.
> > 
> 
> To be honest, I don't think you can sanely support it. The OMAP guys
> have been playing with some kind of multiplexer in front of the
> controller, but it just seems like a world of hurt to me.

That's what I was afraid of. Lets see what our customer says (I hope I
won't find myself in this world of hurt)

> 
> Perhaps you can convert to using SPI for the second slot if the
> customer really needs a design with two slots?

Might be an option.

Thanks for your answer.

Sascha


-- 
 Pengutronix - Linux Solutions for Science and Industry
   Handelsregister:  Amtsgericht Hildesheim, HRA 2686
     Hannoversche Str. 2, 31134 Hildesheim, Germany
   Phone: +49-5121-206917-0 |  Fax: +49-5121-206917-9
