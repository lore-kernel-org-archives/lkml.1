Return-Path: <linux-kernel-owner+w=401wt.eu-S1761925AbYFQXMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761925AbYFQXMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2008 19:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761536AbYFQXCk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jun 2008 19:02:40 -0400
Received: from trinity.fluff.org ([89.145.97.151]:46954 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761528AbYFQXCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2008 19:02:38 -0400
Date: Wed, 18 Jun 2008 00:02:33 +0100
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Ben Dooks <ben-linux@fluff.org>, linux-kernel@vger.kernel.org,
       Harald Welte <laforge@openmoko.org>, Thomas Kleffel <tk@maintech.de>,
       Roman Moravcik <roman.moravcik@gmail.com>
Subject: Re: [patch 01/15] MMC: S3C24XX MMC/SD driver. From: Thomas Kleffel <tk@maintech.de>
Message-ID: <20080617230233.GA10351@trinity.fluff.org>
References: <20080606155117.074799346@fluff.org.uk> <20080606155524.699256747@fluff.org.uk> <20080614181851.01849d03@mjolnir.drzeus.cx>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080614181851.01849d03@mjolnir.drzeus.cx>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.9i
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: ben@trinity.fluff.org
X-SA-Exim-Scanned: No (on trinity.fluff.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 14, 2008 at 06:18:51PM +0200, Pierre Ossman wrote:
> On Fri, 06 Jun 2008 16:51:18 +0100
> Ben Dooks <ben-linux@fluff.org> wrote:
> 
> > +#include <linux/mmc/mmc.h>
> 
> You don't need this anymore.

right, done in patch #2
 
> > +	//if(cmd->flags & MMC_RSP_MAYFAIL) debug_as_failure = 0;
> 
> Please remove all the dead code.

removed in patch #2

> > +	if (mrq->data->error == MMC_ERR_NONE) {

ok, i've done:

MMC_ERR_NONE	=> 0
MMC_ERR_DMA	=> EINVAL
MMC_ERR_TIMEOUT	=> ETIMEDOUT
MMC_ERR_BADCRC	=> EILSEQ
MMC_ERR_FIFO	=> EILSEQ
 
> And rebase against HEAD. MMC_ERR_* are long gone.

right, will try and build and test as soon as possible.
 
> Also, please test using the mmc_test driver available in HEAD. A proper
> driver should pass all those tests (or possibly mark a few as
> unsupported if the hardware is utterly incapable of handling those
> requests).

Thanks, I'll repost v3 when this is done.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

