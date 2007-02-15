Return-Path: <linux-kernel-owner+w=401wt.eu-S1751101AbXBOXaG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751101AbXBOXaG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Feb 2007 18:30:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751692AbXBOXaG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Feb 2007 18:30:06 -0500
Received: from fmx10.freemail.hu ([195.228.245.60]:47610 "HELO
	fmx10.freemail.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751101AbXBOXaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Feb 2007 18:30:04 -0500
Date: Thu, 15 Feb 2007 23:47:56 +0100 (CET)
From: =?ISO-8859-2?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Subject: Re: [PATCH] input: extend EV_LED
To: Pavel Machek <pavel@ucw.cz>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Richard Purdie <rpurdie@rpsys.net>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
In-Reply-To: <20070215174009.GA6535@ucw.cz>
Message-ID: <freemail.20070115234756.58787@fm13.freemail.hu>
X-Originating-IP: [80.98.105.91]
X-HTTP-User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; hu-HU; rv:1.8.0.6) Gecko/20060729 SeaMonkey/1.0.4
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-2
Content-Transfer-Encoding: 8BIT
X-Freemail: message scanned
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



Pavel Machek <pavel@ucw.cz> wrote:

> Hi!
> 
> > >I do not know the LED subsystem in detail, but I do not 
> > >know
> > >any possibility to access the i8042 from different 
> > >subsystem
> > >than the input subsystem.
> > >
> > >What do you think and recommend?
> > 
> > I think you need to use leds framework for what you are 
> > trying to do.
> 
> I'm actually not sure if led framework can do that. It was
designed
> for leds on gpios, and handles blinking itself.
> 
> But he could export two leds :-).

Hi,

what do you mean about two leds? The first one would be
off/0.5Hz and the other off/1Hz?

I read in linux/Documentation/led-class.txt the following:

| Some leds can be programmed to flash in hardware. As this
isn't a generic
| LED device property, this should be exported as a device
specific sysfs
| attribute rather than part of the class if this
functionality is required.

Does it mean that neither the input subsystem nor the led
subsystem is designed for hardware acelerated blinking leds?
Is there any usual way what attribute a hw accelerated
blinking LED_MAIL should export?

        NMarci

______________________________________________________________________________
10.000 Ft ajándék fotókidolgozás minden Panasonic digitális fényképezõgéphez!
FotoMarket Online Fotóáruház 
http://ad.adverticum.net/b/cl,1,6022,99786,162268/click.prm


