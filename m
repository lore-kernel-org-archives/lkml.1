Return-Path: <linux-kernel-owner+w=401wt.eu-S1757323AbZB0GU3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757323AbZB0GU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 01:20:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754162AbZB0GTz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 01:19:55 -0500
Received: from harmaja.edelkey.net ([213.138.147.141]:52193 "EHLO
	harmaja.edelkey.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753822AbZB0GTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 01:19:54 -0500
Subject: Re: [patch 2.6.29-rc3-git 2/2] USB: disable twl4030 USB regulators
	when cable unplugged
From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
To: David Brownell <david-b@pacbell.net>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, Mark Brown <broonie@sirena.org.uk>,
       lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org,
       OMAP <linux-omap@vger.kernel.org>
In-Reply-To: <200902261440.04129.david-b@pacbell.net>
References: <200902081053.00255.david-b@pacbell.net>
	 <1235686596.31223.106.camel@vega.slimlogic.co.uk>
	 <200902261440.04129.david-b@pacbell.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Digia / Pori
Date: Fri, 27 Feb 2009 08:19:33 +0200
Message-Id: <1235715573.7408.89.camel@ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
X-OriginalArrivalTime: 27 Feb 2009 06:19:34.0404 (UTC) FILETIME=[5BCD4440:01C998A3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-02-26 at 14:40 -0800, David Brownell wrote:
> On Thursday 26 February 2009, Liam Girdwood wrote:
> > On Sun, 2009-02-08 at 10:52 -0800, David Brownell wrote:
> > > From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> > > 
> > > This patch disables LDO regulators VUSB1V5, VUSB1V8, and VUSB3V1
> > > when the USB cable is unplugged, to eliminate that source of power
> > > waste.  (Enabled LDOs consume power at all times.)
> > > 
> > > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> > > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > > ---
> > > Depends on the twl4030 regulator driver, so I'm suggesting this
> > > be merged (with that driver) through the regulator patch queue
> > > to simplify things.
> > > 
> > >  drivers/usb/otg/twl4030-usb.c |   30 ++++++++++++++++++++++++------
> > >  1 file changed, 24 insertions(+), 6 deletions(-)
> > 
> > Applied.
> 
> Better suggestion:  grab Kalle's updated patch from Greg's USB
> queue:
> 
>   http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/
> 
> patch name usb-twl-disable-vusb-regulators-when-cable-unplugged.patch


Yep, this previous one lacked some error checks and a build dependency
to TWL_REGULATOR. 

- Kalle


> 
> - Dave
