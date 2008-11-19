Return-Path: <linux-kernel-owner+w=401wt.eu-S1754754AbYKSSiu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754754AbYKSSiu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 13:38:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753529AbYKSSij
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 13:38:39 -0500
Received: from server.drzeus.cx ([85.8.24.28]:51339 "EHLO smtp.drzeus.cx"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753100AbYKSSij (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 13:38:39 -0500
Date: Wed, 19 Nov 2008 19:38:36 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: Ben Dooks <ben-linux@fluff.org>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       sdhci-devel@list.drzeus.cx
Subject: Re: [patch 5/7] SDHCI: Samsung SDHCI (HSMMC) driver
Message-ID: <20081119193836.74cc2ee8@mjolnir.drzeus.cx>
In-Reply-To: <20081116000302.GD9161@fluff.org.uk>
References: <20081103200944.099353331@fluff.org.uk>
	<20081103201010.652101443@fluff.org.uk>
	<20081114224813.063017d7@mjolnir.drzeus.cx>
	<20081116000302.GD9161@fluff.org.uk>
X-Mailer: Claws Mail 3.6.0 (GTK+ 2.14.4; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Nov 2008 00:03:02 +0000
Ben Dooks <ben-linux@fluff.org> wrote:

> On Fri, Nov 14, 2008 at 10:48:13PM +0100, Pierre Ossman wrote:
> > On Mon, 03 Nov 2008 20:09:49 +0000
> > Ben Dooks <ben-linux@fluff.org> wrote:
> > > +	if (pdata->cfg_card)
> > > +		pdata->cfg_card(ourhost->pdev, host->ioaddr,
> > > +				ios, host->mmc->card);
> > 
> > What's the deal here? Hosts shouldn't know more about the card than the
> > MMC core tells them.
> 
> Depending on exactly which version, there's a number of configurations
> in the extra configuration registers that get changed, such as delays
> used for clock feedback which are meant to be chnaged when the speed
> of the card is changed. Unfortunately this changes depending on the
> chip model and possibly also on the board it is on.
> 
> The other is that it is possible that depending on the chip and board
> combination things like the GPIO driver-strength controls will need to
> be changed.

I don't see where knowledge about the card gets into the picture here.
All of this sounds like information that is gathered from platform data
and/or ios information.

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
