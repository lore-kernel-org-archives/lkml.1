Return-Path: <linux-kernel-owner+w=401wt.eu-S1752420AbZHXMtR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420AbZHXMtR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Aug 2009 08:49:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752339AbZHXMtP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Aug 2009 08:49:15 -0400
Received: from mho-01-ewr.mailhop.org ([204.13.248.71]:52924 "EHLO
	mho-01-ewr.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752299AbZHXMtP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Aug 2009 08:49:15 -0400
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 72.249.23.125
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX1+ESVh0lp3eXieSUVruHcUW
Date: Mon, 24 Aug 2009 15:49:03 +0300
From: Tony Lindgren <tony@atomide.com>
To: Jarkko Nikula <jhnikula@gmail.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
       "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
       Peter Ujfalusi <peter.ujfalusi@nokia.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [alsa-devel] [RFC][PATCH 1/3 v2] ARM: OMAP: DMA: Add support
	for DMA channel self linking on OMAP1510
Message-ID: <20090824124902.GH7069@atomide.com>
References: <200908101050.02530.jkrzyszt@tis.icnet.pl> <200908231945.40187.jkrzyszt@tis.icnet.pl> <20090823180543.GA6167@opensource.wolfsonmicro.com> <200908232038.05593.jkrzyszt@tis.icnet.pl> <20090823184943.GA6994@opensource.wolfsonmicro.com> <20090824084920.c99c561a.jhnikula@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090824084920.c99c561a.jhnikula@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jarkko Nikula <jhnikula@gmail.com> [090824 08:47]:
> On Sun, 23 Aug 2009 19:49:43 +0100
> Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:
> 
> > On Sun, Aug 23, 2009 at 08:38:05PM +0200, Janusz Krzysztofik wrote:
> > > Sunday 23 August 2009 20:05:43 Mark Brown wrote:
> > 
> > > > then what are the other 
> > > > patches that depend on this? Nobody reported any issues in testing with 
> > > > the other OMAP patches.
> > 
> > > Dependency on patch 1/3 is not compile time, but run time, and OMAP1510 
> > > specific, that's probably why nobody has reported any issues.
> > 
> > OK, given that and the fact that you're reporting that none of these
> > files are afected by any of the other patches it sounds like it'd be
> > better to keep it in the OMAP tree unless Tony says otherwse.
> 
> Yep, Janusz's commits 64844a6ac8ddd586cb832fea7cf2e93e5e7e03f4 and
> 471e3dec3abe2d41e8c742046353fcb01bc2459e do not cause problems on other
> OMAPs but will cause that ASoC on 1510 is broken until his DMA
> patch(es) are applied. I'm sure you Janusz will ping Tony until he'll
> apply them :-)
> 
> We should remember that arch/arm/plat-omap/mcbsp.c changes done via
> ALSA tree has been an exception and that's only for simpler procedure.
> McBSP is not so critical if sources goes out-of-sync but DMA is.

Sorry for the delay in replying. I'm OK for these to go in via the alsa
tree as there are not currently other patches pending in the mcbsp or
dma area for omap. So I think it's better merge all the audio related
patches together in this case.

Acked-by: Tony Lindgren <tony@atomide.com>

