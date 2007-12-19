Return-Path: <linux-kernel-owner+w=401wt.eu-S1754116AbXLSJFE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754116AbXLSJFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 04:05:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbXLSJEs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 04:04:48 -0500
Received: from mail.gmx.net ([213.165.64.20]:55539 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751287AbXLSJEr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 04:04:47 -0500
X-Authenticated: #24222693
X-Provags-ID: V01U2FsdGVkX1+rqXIIe+er4Vy4eMaybV52mA0J+tBEb7n5YRixzn
	iukGda6p8FnC76
From: Robert Gerlach <khnz@gmx.de>
To: Stephen Hemminger <shemminger@linux-foundation.org>
Subject: Re: [PATCH] Fujitsu application panel driver
Date: Wed, 19 Dec 2007 10:04:41 +0100
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Dmitry Torokhov <dtor@insightbb.com>, Pavel Machek <pavel@ucw.cz>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       linux-input@atrey.karlin.mff.cuni.cz, linux-kernel@vger.kernel.org
References: <20070702111724.43ee5b43@freepuppy.localdomain.hemminger.net> <200711191350.31965.khnz@gmx.de> <20071119151918.19ebd8aa@freepuppy.rosehill>
In-Reply-To: <20071119151918.19ebd8aa@freepuppy.rosehill>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200712191004.42565.khnz@gmx.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 20 November 2007 00:19:18 schrieb Stephen Hemminger:
> On Mon, 19 Nov 2007 13:50:30 +0100
>
> Robert Gerlach <khnz@gmx.de> wrote:
> > Am Montag 19 November 2007 05:43:07 schrieb Stephen Hemminger:
> > > On Sun, 18 Nov 2007 23:36:58 +0100
> > >
> > > Robert Gerlach <khnz@gmx.de> wrote:
> > > > Am Dienstag 23 Oktober 2007 21:55:55 schrieb Stephen Hemminger:
> > > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifeBook*:pvr*:rvnFUJITSU:*");
> > > > > +MODULE_ALIAS("dmi:*:svnFUJITSU:pnLifebook*:pvr*:rvnFUJITSU:*");
> > > >
> > > > Please make sure that this module is not autoload on Lifebook tablets
> > > > (T series and P1[56]10). It works fine, but only supports a subset of
> > > > features (4 of 7 buttons and no display orientation for my T4010).
> > >
> > > I would rather get those tablets working (with help). Rather than
> > > trying to enumerate all the possible DMI values of the full range of
> > > different laptops.
> >
> > I've played with apanel some month ago. I've never found the keys and the
> > switch over the I2C bus. So I was starting my own module (fsc_btns) to
> > play with the IO range announced by ACPI. There I found it all. But my
> > module doesn't work on all Lifebooks (S7110 for example; has no such ACPI
> > device).
>
> Are you sure the IO range isn't really the same as the I2C bus.

No, I'm not sure. But, I was looking through the spec and played with my 
Lifebook, and again with no success.

> See: http://apanel.sourceforge.net/tech.php

Doesn't help ether.


  Robert
