Return-Path: <linux-kernel-owner+w=401wt.eu-S1751319AbZCILxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319AbZCILxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 07:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750793AbZCILwu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 07:52:50 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:55553 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750746AbZCILwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 07:52:49 -0400
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <david-b@pacbell.net>, Mark Brown <broonie@sirena.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <20090308224907.62e9d9d5@mjolnir.ossman.eu>
References: <200902081037.06645.david-b@pacbell.net>
	 <200903031918.07443.david-b@pacbell.net>
	 <20090308145951.0fdd607a@mjolnir.ossman.eu>
	 <200903081334.26465.david-b@pacbell.net>
	 <20090308224907.62e9d9d5@mjolnir.ossman.eu>
Content-Type: text/plain
Date: Mon, 09 Mar 2009 11:52:46 +0000
Message-Id: <1236599566.6781.87.camel@vega.slimlogic.co.uk>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-03-08 at 22:49 +0100, Pierre Ossman wrote:
> On Sun, 8 Mar 2009 12:34:25 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > On Sunday 08 March 2009, Pierre Ossman wrote:
> > > Looks good. Now what should I do with it? Merge it in the next window
> > > good enough?
> > 
> > Well, after testing the previously-untested call ... here's
> > another update.
> > 
> > Since these depend on new calls in the regulator framework,
> > it can't merge until after they merge (in the next window).
> > Least hassle for you would be if this merges through the
> > regulator framework (with your ack), I suspect.
> > 
> > - Dave
> > 
> > 
> > ======== CUT HERE
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Glue between MMC and regulator stacks ... verified with
> > some OMAP3 boards using adjustable and configured-as-fixed
> > regulators on several MMC controllers.
> > 
> > These calls are intended to be used by MMC host adapters
> > using at least one regulator per host.  Examples include
> > slots with regulators supporting multiple voltages and
> > ones using multiple voltage rails (e.g. DAT4..DAT7 using a
> > separate supply, or a split rail chip like certain SDIO
> > WLAN or eMMC solutions).
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> 
> Acked-by: Pierre Ossman <drzeus@drzeus.cx>
> 

Applied.

Thanks

Liam

