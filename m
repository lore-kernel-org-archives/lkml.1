Return-Path: <linux-kernel-owner+w=401wt.eu-S933992AbZHWQwR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992AbZHWQwR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Aug 2009 12:52:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933949AbZHWQwQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Aug 2009 12:52:16 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:33888 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933947AbZHWQwP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Aug 2009 12:52:15 -0400
X-Sasl-enc: ic/mjUppqF0fHhSK/slarrVBxsTZBffnu48Fm29cbRao 1251046337
Message-ID: <4A9173B5.10603@imap.cc>
Date: Sun, 23 Aug 2009 18:52:05 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.22 (X11/20090605)
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Kconfig Q: expressing a modularity dependency
References: <49E5E8D0.1090505@imap.cc> <4A8448B7.6030007@imap.cc> <20090814163250.GD1626@ucw.cz>
In-Reply-To: <20090814163250.GD1626@ucw.cz>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig86BE2751FE4206DA0C283F64"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig86BE2751FE4206DA0C283F64
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Pavel Machek schrieb:

>> So I'll just put a notice in the help text then, warning people
>> not to set CONFIG_ISDN_DRV_GIGASET=3Dy if their ISDN subsystem
>> is built as a module. If anybody has a better idea I'll be
>> glad to hear it.
>=20
> That will break randconfig testing, AFAICT.

I don't think so. Ignoring the warning will not result in a build
failure, just in reduced functionality, and AFAIK that isn't an
issue in randconfig testing.

> AFAIK Kconfig supports if statement just fine, so can you just
>=20
> if something
> 	bool GIGASET
> else
> 	tristate GIGASET

Interesting idea. I'll try that. It'll probably not make it into my
submission for 2.6.32 anymore, but perhaps it can be retrofitted
later.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig86BE2751FE4206DA0C283F64
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKkXO+Q3+did9BuFsRAjnBAJ4/gPlPygaJgqiMmoZ++0UR48myHACfXL1z
24vpXiHNxY888mKO2Zcfc3E=
=2enh
-----END PGP SIGNATURE-----

--------------enig86BE2751FE4206DA0C283F64--
