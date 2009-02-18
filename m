Return-Path: <linux-kernel-owner+w=401wt.eu-S1756108AbZBRUwf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756108AbZBRUwf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 15:52:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753796AbZBRUwW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 15:52:22 -0500
Received: from mho-01-bos.mailhop.org ([63.208.196.178]:52709 "EHLO
	mho-01-bos.mailhop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604AbZBRUwU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 15:52:20 -0500
X-Mail-Handler: MailHop Outbound by DynDNS
X-Originating-IP: 69.181.40.92
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/mailhop/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18a5uFMCB3gI7ugegonOLEC
Date: Wed, 18 Feb 2009 12:52:14 -0800
From: Tony Lindgren <tony@atomide.com>
To: Pierre Ossman <drzeus-mmc@drzeus.cx>
Cc: David Brownell <david-b@pacbell.net>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2.6.29-rc5] MMC: omap_hsmmc: only MMC1 allows HCTL.SDVS
	!= 1.8V
Message-ID: <20090218205214.GD11928@atomide.com>
References: <200902171449.01646.david-b@pacbell.net> <20090218212237.4cc73890@mjolnir.ossman.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090218212237.4cc73890@mjolnir.ossman.eu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pierre Ossman <drzeus-mmc@drzeus.cx> [090218 12:22]:
> On Tue, 17 Feb 2009 14:49:01 -0800
> David Brownell <david-b@pacbell.net> wrote:
> 
> > From: David Brownell <dbrownell@users.sourceforge.net>
> > 
> > Based on a patch from Tony Lindgren ... after initialization,
> > never change HCTL.SDVS except for MMC1.  The other controller
> > instances only support 1.8V in that field, although they can
> > suport other card/SDIO/eMMC/... voltages with level shifting
> > solutions such as external transceivers.
> >
> > MMC2 behavior sanity tested on Overo/WLAN, OMAP3430 SDP, and
> > custom hardware.  MMC1 also sanity tested on those platforms
> > plus Beagle.  This also fixes a bug preventing MMC2 (and also
> > presumably MMC3) from powering down when requested.
> > 
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> 
> This suffers from the same problem as all other omap_hsmmc patches. Who
> claims ownership of that driver?

Jarkko Lavinen has agreed to maintain it. Meanwhile, here's my
ack for this one:

Acked-by: Tony Lindgren <tony@atomide.com>

Regards,

Tony
