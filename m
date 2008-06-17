Return-Path: <linux-kernel-owner+w=401wt.eu-S1760744AbYFQXUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760744AbYFQXUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:20:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751386AbYFQXUl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:20:41 -0400
Received: from trinity.fluff.org ([89.145.97.151]:59815 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759475AbYFQXUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:20:35 -0400
Date: Wed, 18 Jun 2008 00:20:33 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Harald Welte <laforge@openmoko.org>, Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: Re: [patch 06/15] MMC: Add platform data for S3C24XX MMC/SD driver
Message-ID: <20080617232033.GD10351@trinity.fluff.org>
References: <20080606155117.074799346@fluff.org.uk> <20080606155525.687756431@fluff.org.uk> <20080614182220.69474ac5@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614182220.69474ac5@mjolnir.drzeus.cx>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 06:22:20PM +0200, Pierre Ossman wrote:
> On Fri, 06 Jun 2008 16:51:23 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > This patch adds platform data support to the s3mci driver.  This allows
> > flexible board-specific configuration of set_power, card detect and read only
> > pins.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > 
> 
> Please see the changes in my #next branch where you can return -ENOSYS
> to indicate that you do not know the state of the read only pin.

thanks, fixed.
 
> > +
> > +static struct s3c24xx_mci_pdata s3cmci_def_pdata = {
> > +	.gpio_detect	= 0,
> > +	.set_power	= NULL,
> > +	.ocr_avail	= MMC_VDD_32_33,
> >  };
> 
> You probably want MMC_VDD_32_32 | MMC_VDD_33_34 here.

Ok, updated.

thanks,
-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

