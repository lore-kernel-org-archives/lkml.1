Return-Path: <linux-kernel-owner+w=401wt.eu-S1753522AbZGBRgk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753522AbZGBRgk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:36:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751145AbZGBRgc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:36:32 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58354 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117AbZGBRgb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:36:31 -0400
Date: Thu, 2 Jul 2009 18:36:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joe Perches <joe@perches.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Message-ID: <20090702173624.GA4647@sirena.org.uk>
References: <1246549388-29007-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1246550903.28915.87.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1246550903.28915.87.camel@Joe-Laptop.home>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 82.41.28.43
X-SA-Exim-Mail-From: broonie@sirena.org.uk
Subject: Re: [PATCH] MAINTAINERS: Add entry for Wolfson PMIC drivers
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 09:08:23AM -0700, Joe Perches wrote:
> On Thu, 2009-07-02 at 16:43 +0100, Mark Brown wrote:

> > +F:	drivers/leds/leds-wm83*.c
> > +F:	drivers/mfd/wm8*.c
> > +F:	drivers/power/wm83*.c
> > +F:	drivers/rtc/rtc-wm83*.c
> > +F:	drivers/regulator/wm8*.c
> > +F:	drivers/watchdog/wm83*_wdt.c

> Maybe this pattern is complete enough?

> F:	drivers/*/*wm8*.c

That misses the LED, RTC and watchdog drivers.  Making the match more
general with a leading * in the filename is just asking for false
positives.

> > +F:	sound/soc/codecs/wm8350.c
> > +F:	sound/soc/codecs/wm8400.c

> What about the other wm8 codecs?  Maybe:

Those are not PMICs and therefore not relevant here.  Since I am the
most active maintainer for the ASoC subsystem at the minute a separate
entry for the drivers within it would be a bit redundant.  The CODEC
drivers for the PMICs are included here for completeness more than
anything else.
