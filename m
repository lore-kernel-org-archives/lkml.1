Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754480Ab0CBUpT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 15:45:19 -0500
Received: from gmp-eb-inf-1.sun.com ([192.18.6.21]:42108 "EHLO
	gmp-eb-inf-1.sun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab0CBUpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 15:45:17 -0500
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Tue, 02 Mar 2010 21:44:48 +0100
From: Michael Thayer <Michael.Thayer@Sun.COM>
Subject: Re: [PATCH 1/1]: input: add support for VirtualBox touchscreen
 emulation to the Lifebook driver
In-reply-to: <20100225101705.GF10823@core.coreip.homeip.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <1267562688.2441.7.camel@michael-laptop>
Organization: Sun Microsystems GmbH
X-Mailer: Evolution 2.28.1
References: <1266923615.3602.85.camel@michael-laptop>
 <20100223175852.GA11301@core.coreip.homeip.net>
 <1266958533.3602.128.camel@michael-laptop>
 <20100224100206.GA5598@core.coreip.homeip.net>
 <1267011989.2831.30.camel@michael-laptop>
 <20100225101705.GF10823@core.coreip.homeip.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Dmitry,

Le jeudi 25 février 2010 à 02:17 -0800, Dmitry Torokhov a écrit :
> On Wed, Feb 24, 2010 at 12:46:29PM +0100, Michael Thayer wrote:
> > Le mercredi 24 février 2010 à 02:02 -0800, Dmitry Torokhov a écrit :
> > > On Tue, Feb 23, 2010 at 09:55:33PM +0100, Michael Thayer wrote:
> > > > I'm not sure, if we ended up doing a completely new device, how different it
> > > > would end up being.  Emulating a touchscreen or a tablet makes sense for us as
> > > > these are both something known, which will work with existing systems without
> > > > too much tweaking
> > > > [snip]
> > > But the virtual mouse is not a touchscreen or a tablet, it behaves
> > > differently.
> > What would you suggest emulating that exists in the real world?
> 
> There are not many real devices that have teh same characteristics as
> virtual mouse generating absolute coordinates. Umm, the closest would be
> a wacom tablet when used with its own mouse.
We decided in the end to emulate a USB tablet, as some other virtualisers do.
It works well out of the box with recent Linux distributions, and while older
ones recognise it as a touchpad (in fact they use it through /dev/input/mice),
it still provides a reasonable user experience until the user has installed our
guest drivers.

Thank you again for your comments and assistance.

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

