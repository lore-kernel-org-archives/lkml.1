Return-Path: <linux-kernel-owner+w=401wt.eu-S1755924AbZBWCnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755924AbZBWCnR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Feb 2009 21:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752652AbZBWCnA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Feb 2009 21:43:00 -0500
Received: from trinity.dh.bytemark.co.uk ([89.16.178.74]:59537 "EHLO
	trinity.fluff.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629AbZBWCm7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Feb 2009 21:42:59 -0500
X-Greylist: delayed 2773 seconds by postgrey-1.27 at vger.kernel.org; Sun, 22 Feb 2009 21:42:59 EST
Date: Mon, 23 Feb 2009 01:56:00 +0000
From: Ben Dooks <ben-linux@fluff.org>
To: Pierre Ossman <drzeus@drzeus.cx>
Cc: Anton Vorontsov <avorontsov@ru.mvista.com>,
       Ben Dooks <ben-linux@fluff.org>, Arnd Bergmann <arnd@arndb.de>,
       Kumar Gala <galak@kernel.crashing.org>,
       Liu Dave <DaveLiu@freescale.com>, sdhci-devel@list.drzeus.cx,
       linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 01/13] sdhci: Add quirk for controllers with no end-of-busy IRQ
Message-ID: <20090223015559.GB30710@trinity.fluff.org>
References: <20090220173228.GA5091@oksana.dev.rtsoft.ru> <20090220173308.GA7583@oksana.dev.rtsoft.ru> <20090221170504.657ff791@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090221170504.657ff791@mjolnir.ossman.eu>
X-Disclaimer: These are my views alone.
X-URL: http://www.fluff.org/
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 21, 2009 at 05:05:04PM +0100, Pierre Ossman wrote:
> On Fri, 20 Feb 2009 20:33:08 +0300
> Anton Vorontsov <avorontsov@ru.mvista.com> wrote:
> 
> > From: Ben Dooks <ben-linux@fluff.org>
> > 
> > The Samsung SDHCI (and FSL eSDHC) controller block seems to fail
> > to generate an INT_DATA_END after the transfer has completed and
> > the bus busy state finished.
> > 
> > Changes in e809517f6fa5803a5a1cd56026f0e2190fc13d5c to use the
> > new busy method are the cause of the behaviour change.
> > 
> > Signed-off-by: Ben Dooks <ben-linux@fluff.org>
> > Signed-off-by: Anton Vorontsov <avorontsov@ru.mvista.com>
> > ---
> 
> Any objections to me merging this right away? It is needed for another
> controller.

none from me.

sorry about the delay, moving servers.

-- 
Ben

Q:      What's a light-year?
A:      One-third less calories than a regular year.

