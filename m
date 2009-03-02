Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbZCBVky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbZCBVky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 16:40:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751362AbZCBVko
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 16:40:44 -0500
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:41924 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750772AbZCBVko (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 16:40:44 -0500
Date: Mon, 2 Mar 2009 22:40:40 +0100
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
To: David Brownell <david-b@pacbell.net>
Cc: Mark Brown <broonie@sirena.org.uk>, Liam Girdwood <lrg@slimlogic.co.uk>,
       lkml <linux-kernel@vger.kernel.org>, OMAP <linux-omap@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc6+misc] MMC: regulator utilities
Message-ID: <20090302224040.5e7ab0b2@mjolnir.ossman.eu>
In-Reply-To: <200903021327.14285.david-b@pacbell.net>
References: <200902081037.06645.david-b@pacbell.net>
	<200902261348.30617.david-b@pacbell.net>
	<20090302215956.3f355eee@mjolnir.ossman.eu>
	<200903021327.14285.david-b@pacbell.net>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Mar 2009 13:27:13 -0800
David Brownell <david-b@pacbell.net> wrote:

> On Monday 02 March 2009, Pierre Ossman wrote:
> > On Thu, 26 Feb 2009 13:48:30 -0800
> > David Brownell <david-b@pacbell.net> wrote:
> > 
> > > + */
> > > +int mmc_regulator_set_ocr(struct mmc_host *host, struct regulator *supply)
> > > +{
> > 
> > Why not pass the vdd directly? Saves a few dereferences if nothing else.
> 
> This call syntax is simpler, which is usually a win.
> Passing a third parameter would create fault paths
> of the "pass *wrong* parameter" flavor.
> 
> In terms of object code, when I've looked at such things
> the dereferences generally cost the same as a ref to a
> parameter, but passing an extra parameter isn't free.
> 

I couldn't see host being used in there, so I was thinking more of a
replacement, not an addition.

Rgds
-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  rdesktop, core developer          http://www.rdesktop.org

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.
