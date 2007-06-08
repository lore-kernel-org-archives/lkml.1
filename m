Return-Path: <linux-kernel-owner+w=401wt.eu-S966968AbXFHAYS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966968AbXFHAYS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2007 20:24:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764829AbXFHAYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jun 2007 20:24:07 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:35287 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1764069AbXFHAYG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2007 20:24:06 -0400
X-Sasl-enc: DsgmgHDDMtYpE28svnFiDk4Bb5d6WG9FH7mpSJWj97id 1181262245
Message-ID: <4668A283.70902@imap.cc>
Date: Fri, 08 Jun 2007 02:27:47 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: huang ying <huang.ying.caritas@gmail.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com> <465366CB.7090608@imap.cc> <46632489.9070107@gmx.de> <4665D89E.8080408@imap.cc> <46666FD8.9010702@gmx.de> <466885CB.4070702@gmx.de>
In-Reply-To: <466885CB.4070702@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig70E4B1406181CE4E48DBCF58"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig70E4B1406181CE4E48DBCF58
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 08.06.2007 00:25 schrieb Lars K.W. Gohlke:
>>> a) With a line discipline, [...]
>>> b) With the "serio" interface, [...]
>>>
>> ok because I want to handle it in kernel space I will no take option a=
)
>=20
>> I will try it the way of b)

> I asked vojtech@suse.cz as one of the driver developer
>=20
> this is how I did it (just prototype)
>=20
> (neccessary just one folder and two files)
> 1. copy template linux-source/drivers/input/joystick/magellan.c
> 2. insert in line 90  :
> 	printk("%s:\"%s\"\n",__FUNCTION__, data);
> 3. make and insert it
> 4. inputattach --magellan /dev/ttyS0 &

I see. So it turns out the "serio" interface finally goes through a
line discipline (N_MOUSE) and consequently also needs a userspace
daemon (inputattach). That doesn't give me any advantage compared
to attaching directly to the line discipline interface, so I'll
stay with the latter approach.

But glad to hear it worked out for you.

Take care,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig70E4B1406181CE4E48DBCF58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGaKKDMdB4Whm86/kRAnOnAJ4xxmE5oM5FDkrzSDxtb2qKEYs42gCeP7Jy
REFRv2XUF9m0Echg7jQn+Og=
=6RIv
-----END PGP SIGNATURE-----

--------------enig70E4B1406181CE4E48DBCF58--
