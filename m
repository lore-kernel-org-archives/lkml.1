Return-Path: <linux-kernel-owner+w=401wt.eu-S1755104AbYLOKrt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755104AbYLOKrt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2008 05:47:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753159AbYLOKrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Dec 2008 05:47:41 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1828 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009AbYLOKrk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2008 05:47:40 -0500
Date: Mon, 15 Dec 2008 10:47:31 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Mike Rapoport <mike@compulab.co.il>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
       felipe.balbi@nokia.com, Liam Girdwood <lrg@kernel.org>
Subject: Re: [PATCH] mfd: DA9030 USB charge pump mode selection support
Message-ID: <20081215104730.GA31145@sirena.org.uk>
References: <4943FA3E.9090507@cam.ac.uk> <49461CFB.9080108@compulab.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49461CFB.9080108@compulab.co.il>
X-Cookie: Knowledge is power.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2008 at 11:01:47AM +0200, Mike Rapoport wrote:
> Jonathan Cameron wrote:

> > The main question on this is whether it should just be rolled into
> > the core mfd driver.  I'm inclined to keep it separate and decidedly
> > optional as the fact it isn't already in the driver implies that
> > it may not be commonly used. (Intel Stargate 2 does need this
> > functionality though, hence the submission as I'm hoping to get
> > the relevant board code in soonish.)

> I'm for adding "da9030_set_usb_charge_pump_mode" to the core mfd driver.

Me too - if there are concerns about kernel size a config option could
be added to allow users to select it.  Unless we get an abstraction for
these USB power sources (which might be useful) a separate driver
doesn't seem to buy much.
