Return-Path: <linux-kernel-owner+w=401wt.eu-S1757618AbXENVhe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757618AbXENVhe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 17:37:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754388AbXENVh2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 17:37:28 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60066 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754331AbXENVh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 17:37:27 -0400
X-Sasl-enc: xaQfZJPX6IVAPazq843TYXVIHvYHh7WCfNnwRU5ccCb2 1179178646
Message-ID: <4648D74C.6010305@imap.cc>
Date: Mon, 14 May 2007 23:40:28 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org> <4647569D.7010709@imap.cc> <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr> <4648A3DF.7040004@imap.cc> <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig084BD14407D6D583AC091A60"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig084BD14407D6D583AC091A60
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.05.2007 22:33 schrieb Jan Engelhardt:
> On May 14 2007 20:01, Tilman Schmidt wrote:
>>> "Patches welcome" ;-)
>> Sure. Just tell me exactly what those options are intended to do
>> and I'll happily write up a patch adding help texts trying to
>> express that in bad English. :-)
>=20
> They are just a menu that can be switched on or off.

Ok, that's the first essential piece of information which is *not*
evident from the prompt "make oldconfig" presents me with:

  Ethernet (1000 Mbit) (NETDEV_1000) [Y/n] (NEW)

contains *no* indication that this is the start of a menu.

>   * Disabling this menu disables all the fluff inside it,

Another essential piece of information. I seem to remember other
menus which, when disabled, kept the selection status of the
options inside and just hid them from view.

> menuconfig NETDEV_10000
> 	bool "Ethernet (10GbE)"
> 	---help--
> 	Say Y here to actually be able to go into this menu
> 	and select some drivers that we think belong to the
> 	"10 Gigabit Ethernet" family.
>=20
> 	If unsure, it is unwise to say N!
>=20
> See, this looks so fundamentally basic to me that I find it
> almost funny. YMMV, hence I asked for suggestions from
> other people.

That's because it's so incomplete and mentions only the facts
which where obvious in the first place. (Except for the "this
menu" part which might appear rather cryptic to users of the
curses based interface who don't see any menu.)

Have a look at the entry "config NET_ETHERNET" for an impression
of what others felt worth mentioning in similar circumstances.
And no, that is not funny, even though much of it is of course
fundamentally basic for most of us. It does actually help people
confronted with the question.

>> For a start, it shouldn't require users to grep through Kconfigs
>> and Makefiles in order to find out what effects an option has.
>=20
> menuconfigs are some special kind in that they combine an option
> with a menu. Perhaps now that some ->menuconfig patches have gone
> in, more people will get to know these constructs.

Point is, without grepping through the Kconfig the user has no
way of knowing that the question comes from a menuconfig in the
first place, at least with "make menuconfig" and friends, and
without grepping through the Makefile (and, =E0 la limite, source
files) s/he cannot be sure the option doesn't directly affect
code generation.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig084BD14407D6D583AC091A60
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSNdTMdB4Whm86/kRArLoAJ44rFWzbg1jN2DUdL+qAeLyEtEGYQCdHmBq
MRJCD6CJRzsAIGt/V1eL5Rk=
=gGaR
-----END PGP SIGNATURE-----

--------------enig084BD14407D6D583AC091A60--
