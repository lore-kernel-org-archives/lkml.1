Return-Path: <linux-kernel-owner+w=401wt.eu-S1760873AbZE1NHt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760873AbZE1NHt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 May 2009 09:07:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757193AbZE1NHl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 May 2009 09:07:41 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:51877 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756236AbZE1NHk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 May 2009 09:07:40 -0400
Date: Thu, 28 May 2009 14:07:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jon Smirl <jonsmirl@gmail.com>
Cc: Robert Schwebel <r.schwebel@pengutronix.de>,
       Timur Tabi <timur@freescale.com>, Janboe Ye <yuan-bo.ye@motorola.com>,
       Grant Likely <grant.likely@secretlab.ca>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.arm.linux.org.uk,
       rmk@arm.linux.org.uk
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-ID: <20090528130734.GB19523@sirena.org.uk>
References: <1243408083.13460.14.camel@debian-nb> <fa686aa40905270727m31250984tf12249fc87179ce9@mail.gmail.com> <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> <20090527150527.GK6805@pengutronix.de> <20090527163223.GE1970@sirena.org.uk> <9e4733910905271150q1d51538draa8d039c8b147c05@mail.gmail.com> <20090527222420.GC5591@sirena.org.uk> <9e4733910905271704q14e98429x241bc91399ccc5d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e4733910905271704q14e98429x241bc91399ccc5d0@mail.gmail.com>
X-Cookie: Vitamin C deficiency is apauling.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 08:04:58PM -0400, Jon Smirl wrote:
> On Wed, May 27, 2009 at 6:24 PM, Mark Brown

> > Please read back over the original soc-of-simple thread, it goes into
> > the problems in a bit more detail.

...

> It's an evolutionary process, let's get ASoC loading all of the right
> modules first. Then we can move on to clocking, etc. I2C went through

As I have said a number of times with the exception of the AC97 the core
is basically there.  Certainly as far as loading modules goes the work
that needs doing is all at the driver level.  It'd be helpful if you'd
take this on board more - as things stand ASoC isn't doing any device
loading itself and relies on notifications from the individual drivers
that they're ready to use.

There's more stuff that needs doing in the core but I'm not going to
stop and wait for the drivers to catch up except in so much as it stops
other work - I only have the ability to test some devices and plenty of
stuff to be getting on with.  The feature is there if people want to use
it and I'm insisting on it for new CODEC drivers.

> the same process.  For example, the new efika-audio-fabric and
> pcm030-audio-fabric files should not be needed once the binding

As I have repeatedly explained to you there are particular issues with
AC97 which affect these drivers.

> When I disabled soc-of-simple that stop the autoloading of codecs on
> i2s. That needs to be fixed. Next kernel cycle I will be working on
> mpc5200 i2s.

This is going down to the individual drivers for your systems using old
device instantiation methods.  Someone needs to update the drivers.
