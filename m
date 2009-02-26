Return-Path: <linux-kernel-owner+w=401wt.eu-S1759439AbZBZWkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759439AbZBZWkq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 17:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754974AbZBZWkM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 17:40:12 -0500
Received: from smtp122.sbc.mail.sp1.yahoo.com ([69.147.64.95]:37735 "HELO
	smtp122.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755061AbZBZWkI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 17:40:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=aWpW8oHPFEMfksQ2WNtdzUkFzTV+CNq+O9r3xlU4EvvllkrJXXA37OeQg1+bP6GnenyUsCfz/jizQF2xJ5C5Zy51froOMNBJK0akVDaF0KUPkkC1dNWAvIKG0np/k0FfiGyqv48KQANJZ8Tvj7t0mV3+XJyj9mINgzf3ARMXBpI=  ;
X-YMail-OSG: 0GjgC7cVM1lg.fzrmLPUo_hQ9KYmvFFr.ryTJ8Ujefw6pLEQrrburpJOtsor6c4.tX3rH3V35hiSmpjEqotPUG3_A55kz6EglzsbN9cpojlN6oFeWm6MZIOwAj5J_U7YpBXXLzXrXByBJpyc_D_S8xMRRH3NOhhMiXKjHUnaagl4dqBWjJYV99hISvFYQfHm2g--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [patch 2.6.29-rc3-git 2/2] USB: disable twl4030 USB regulators when cable unplugged
Date: Thu, 26 Feb 2009 14:40:03 -0800
User-Agent: KMail/1.9.10
Cc: Mark Brown <broonie@sirena.org.uk>, lkml <linux-kernel@vger.kernel.org>,
       linux-usb@vger.kernel.org, OMAP <linux-omap@vger.kernel.org>,
       Kalle Jokiniemi <kalle.jokiniemi@digia.com>
References: <200902081053.00255.david-b@pacbell.net> <1235686596.31223.106.camel@vega.slimlogic.co.uk>
In-Reply-To: <1235686596.31223.106.camel@vega.slimlogic.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902261440.04129.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 February 2009, Liam Girdwood wrote:
> On Sun, 2009-02-08 at 10:52 -0800, David Brownell wrote:
> > From: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> > 
> > This patch disables LDO regulators VUSB1V5, VUSB1V8, and VUSB3V1
> > when the USB cable is unplugged, to eliminate that source of power
> > waste.  (Enabled LDOs consume power at all times.)
> > 
> > Signed-off-by: Kalle Jokiniemi <kalle.jokiniemi@digia.com>
> > Signed-off-by: David Brownell <dbrownell@users.sourceforge.net>
> > ---
> > Depends on the twl4030 regulator driver, so I'm suggesting this
> > be merged (with that driver) through the regulator patch queue
> > to simplify things.
> > 
> >  drivers/usb/otg/twl4030-usb.c |   30 ++++++++++++++++++++++++------
> >  1 file changed, 24 insertions(+), 6 deletions(-)
> 
> Applied.

Better suggestion:  grab Kalle's updated patch from Greg's USB
queue:

  http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/gregkh-04-usb/

patch name usb-twl-disable-vusb-regulators-when-cable-unplugged.patch

- Dave
