Return-Path: <linux-kernel-owner+w=401wt.eu-S1758014AbXFVO2X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014AbXFVO2X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2007 10:28:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755525AbXFVO2Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Jun 2007 10:28:16 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1757 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755476AbXFVO2P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2007 10:28:15 -0400
Date: Fri, 22 Jun 2007 16:27:53 +0200 (CEST)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Mauro Carvalho Chehab <mchehab@infradead.org>
cc: Oliver Neukum <oneukum@suse.de>, linux-usb-devel@lists.sourceforge.net,
       video4linux-list@redhat.com,
       =?UTF-8?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>,
       luca.risolia@studio.unibo.it, Jan Engelhardt <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig troubles when using menuconfig - Was: [patch]Re:
 [linux-usb-devel] linux-2.6.22-rc5-gf1518a0 build #300 failed in zc0301_core.c
In-Reply-To: <1182518566.14289.20.camel@gaivota>
Message-ID: <Pine.LNX.4.64.0706221602000.1817@scrub.home>
References: <200706211117.55908.toralf.foerster@gmx.de> 
 <200706211231.53898.luca.risolia@studio.unibo.it>  <200706211326.45031.toralf.foerster@gmx.de>
  <200706211350.14526.oneukum@suse.de> <1182518566.14289.20.camel@gaivota>
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463811837-1671747748-1182522473=:1817"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463811837-1671747748-1182522473=:1817
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE

Hi,

On Fri, 22 Jun 2007, Mauro Carvalho Chehab wrote:

> Hi Roman,
>=20
> Several instabilities on Kconfig started to happen after replacing
> Kconfig menus to use menuconfig, as this one, reported by Oliver:
>=20
> Em Qui, 2007-06-21 =C3=A0s 13:50 +0200, Oliver Neukum escreveu:
> > Am Donnerstag, 21. Juni 2007 schrieb Toralf F=C3=B6rster:
> > > Right, but IMHO this issue is typical for a problem with the Kconfig =
definitions of this module.
> > >=20
> > > I'll set USB devs as Cc: therefore.

There is too little context here, what was the exact error?
I'm assuming it's the module vs. builtin problem?

> In this specific case, all V4L USB drivers depends on V4L_USB_DRIVERS,
> that depends, in turn, on USB. So, if USB is not selected,
> V4L_USB_DRIVERS should be unselected, unselecting zc0301.
>=20
> Unfortunately, the Kernel building system is not properly handling it.
>=20
> This is the (snipped) media/video/Kconfig:
>=20
> menuconfig V4L_USB_DRIVERS
>         bool "V4L USB devices"
>         depends on USB
>         default y
>=20

The menuconfig patches were a little aggressive here, it created a config=
=20
symbol where there was none before and in this case it even changed=20
dependencies (it turns USB into a bool).
I'm also a little irritated by the "default y", if I enable V4L I'm very=20
tempted to check what other useless stuff has been automatically enabled,=
=20
which I have to turn off again.

bye, Roman
---1463811837-1671747748-1182522473=:1817--
