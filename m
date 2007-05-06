Return-Path: <linux-kernel-owner+w=401wt.eu-S1758962AbXEFVMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758962AbXEFVMZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2007 17:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758968AbXEFVMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 May 2007 17:12:24 -0400
Received: from mail.z-net.ru ([89.113.80.10]:2008 "EHLO mail.z-net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758957AbXEFVMW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2007 17:12:22 -0400
Date: Mon, 7 May 2007 01:07:54 +0400
From: Anton Vorontsov <cbou@mail.ru>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: ian <spyro@f2s.com>, Shem Multinymous <multinymous@gmail.com>,
       Greg KH <gregkh@suse.de>, David Woodhouse <dwmw2@infradead.org>,
       linux-kernel@vger.kernel.org, kernel-discuss@handhelds.org
Subject: Re: [Kernel-discuss] Re: [PATCH 3/8] Universal power supply class
	(was: battery class)
Message-ID: <20070506210754.GB10236@zarina>
Reply-To: cbou@mail.ru
References: <20070503213139.GC20067@zarina> <41840b750705032155w21d98b5g6236daf9bff66606@mail.gmail.com> <20070505035413.GB21359@khazad-dum.debian.net> <1178372786.3901.4.camel@wirenth> <20070506180937.GB31940@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf8
Content-Disposition: inline
In-Reply-To: <20070506180937.GB31940@khazad-dum.debian.net>
User-Agent: Mutt/1.5.15 (2007-04-06)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 06, 2007 at 03:09:37PM -0300, Henrique de Moraes Holschuh wrote:
> On Sat, 05 May 2007, ian wrote:
> > On Sat, 2007-05-05 at 00:54 -0300, Henrique de Moraes Holschuh wrote:
> > 
> > > Given that USB-power *is* usually also "dumb" (i.e. it doesn't do any
> > > control signaling over the USB bus for power-control purposes),
> > 
> > it might be dumb, but it is useful to know wether the PDA is charging
> > from usb or mains power. and some devices allow one to switch on / off
> > the ability to charge via usb
> 
> Which, at the proper abstraction level provided by this class, means that it
> allows one to switch on or off a power supply channel.
> 
> Laptops let one do this with their batteries, too.  It is the same thing.  I
> didn't check if the class comes with an attribute for "enable/disable this
> power source", but if doesn't, we need to add one: it *is* a generic and
> widely used capability in laptops, and according to you, also on PDAs.

Yup, this is simple matter of adding such attribute (plus implemention
of set_property function, which is trivial).

-- 
Anton Vorontsov
email: cbou@mail.ru
backup email: ya-cbou@yandex.ru
irc://irc.freenode.org/bd2
