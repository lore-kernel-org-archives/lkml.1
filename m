Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754093Ab0CBXOL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:14:11 -0500
Received: from gmp-eb-inf-2.sun.com ([192.18.6.24]:57112 "EHLO
	gmp-eb-inf-2.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab0CBXOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:14:08 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Wed, 03 Mar 2010 00:13:47 +0100
From: Michael Thayer <Michael.Thayer@Sun.COM>
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
In-reply-to: <20100302223947.GC13499@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1267571627.2441.24.camel@michael-laptop>
Organization: Sun Microsystems GmbH
X-Mailer: Evolution 2.28.1
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
 <1266958533.3602.128.camel@michael-laptop>
 <20100224100206.GA5598@core.coreip.homeip.net>
 <1267011989.2831.30.camel@michael-laptop>
 <20100225101705.GF10823@core.coreip.homeip.net>
 <1267562688.2441.7.camel@michael-laptop>
 <20100302212812.GA13499@core.coreip.homeip.net>
 <1267567219.2441.12.camel@michael-laptop>
 <20100302223947.GC13499@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 02 mars 2010 à 14:39 -0800, Dmitry Torokhov a écrit :
> On Tue, Mar 02, 2010 at 11:00:19PM +0100, Michael Thayer wrote:
> > Le mardi 02 mars 2010 à 13:28 -0800, Dmitry Torokhov a écrit :
> > > It is your call but I would much rather if you worked on fixeng evdev to
> > > work with your virtual device rather than having to install a new X
> > > driver and going through the hoops trying to detect which one should be
> > > used on a particular box. At least on Linux...
> > That wouldn't really help us much here, as we are talking about distributions
> > shipping X.Org Server 1.4 and earlier, and those distributions are no longer
> > going to get that sort of update (in those cases in which they are still
> > getting updates at all).  Legacy support if you like.

> You need to distribute something... Or do these older distros already
> include your guest drivers?
We provide the drivers for those distributions (as well as a couple of other
things like tools for clipboard integration with the host, or seamless desktop
integration) as part of the VirtualBox package (and yes, we do jump through
hoops to install them :) ).  A couple of distributions do actually install them
by default (openSUSE, Pardus), but that is a bit of a mixed blessing for us, as
the versions installed are usually not the most recent, and it is hard for us to
update them.

Regards,

Michael
-- 
Sun Microsystems GmbH        Michael Thayer
Werkstrasse 24               VirtualBox engineer
71384 Weinstadt, Germany     mailto:michael.thayer@sun.com

Sitz der Gesellschaft:
Sun Microsystems GmbH, Sonnenallee 1, 85551 Kirchheim-Heimstetten
Amtsgericht Muenchen: HRB 161028
Geschaeftsfuehrer: Thomas Schroeder, Wolfgang Engels
Vorsitzender des Aufsichtsrates: Martin Haering

