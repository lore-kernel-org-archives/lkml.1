Return-Path: <linux-kernel-owner+w=401wt.eu-S1752961AbXE3JiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752961AbXE3JiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2007 05:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751387AbXE3JiR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 30 May 2007 05:38:17 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:1540 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXE3JiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2007 05:38:16 -0400
Message-ID: <465D45FC.3080804@imap.cc>
Date: Wed, 30 May 2007 11:38:04 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de> <4655C554.7030000@imap.cc> <4655C93D.40005@gmx.de> <Pine.LNX.4.61.0705241927410.31549@yvahk01.tjqt.qr> <4655E463.7000201@gmx.de> <465B0BC9.2040502@imap.cc> <465D22A6.4090107@gmx.de> <465D2BEC.2090008@gmx.de>
In-Reply-To: <465D2BEC.2090008@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD105BE09782A47C38784DF49"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD105BE09782A47C38784DF49
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Lars K.W. Gohlke schrieb:
> Lars K.W. Gohlke schrieb:
>> Tilman Schmidt schrieb:
[...]
>>> d) use the serio interface (described by Ying Huang):
>>>    potentially cleaner conceptually and seems to work without a
>>>    userspace daemon, but apparently not documented anywhere
>>>    except in the source files drivers/input/serio/serport.c
>>>    and linux/drivers/input/mouse/sermouse.c
>>>
>>> Now it's your turn to decide.
>=20
>> When I'm chosing option d) can smb. help me step by step? There are so=

>> many pieces of code I don't understand.

That was Ying Huang's suggestion, so he might be best able to help
you. But I see you haven't included him in the recipient list of
your mail.

>> my kernel source base is : ubuntu-lts 6.06 and 2.6.15-7
>> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-2.6.15.y.git;=
a=3Dtree;f=3Ddrivers/input/serio;

Perhaps it would be better to use a current kernel? It's always an
additional difficulty if one has to go back in history.

> [linux/drivers/input/mouse/sermouse.c]
>=20
> Where can I see, which serial line is used to get data stream from?
>=20
> The mouse is plugged in. Where is the decision made, that maybe port0 i=
s
>   used?

I have no idea. As I said, I have used a different interface and
this one is essentially undocumented. If I had to use it I would
probably try to follow the flow of control from the
serio_register_driver() call in sermouse_init() in order to see
where the .connect method ends up being called. But again, Ying
Huang was the one who suggested that interface, so hopefully he
might be able to tell you more.

HTH
T.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigD105BE09782A47C38784DF49
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGXUYDMdB4Whm86/kRAiAUAJoCzvmYLwMeYLyGJX+a60Aej/5N1ACeIwHg
iBsjhMDFBN74Jjbe+EqGtic=
=RS5g
-----END PGP SIGNATURE-----

--------------enigD105BE09782A47C38784DF49--
