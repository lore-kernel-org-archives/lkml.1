Return-Path: <linux-kernel-owner+w=401wt.eu-S1750797AbXDDUb1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750797AbXDDUb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2007 16:31:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750799AbXDDUb1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Apr 2007 16:31:27 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:44447 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750797AbXDDUbZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2007 16:31:25 -0400
X-Sasl-enc: L9jCXeETb7Vpj+X5m5pUB/koTTnHK03jnaRxtfcfVt1E 1175718684
Message-ID: <46140B98.1080004@imap.cc>
Date: Wed, 04 Apr 2007 22:33:28 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Tilman Schmidt <tilman@imap.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       reiserfs-dev@namesys.com, Oliver Pinter <oliver.pntr@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: 2.6.21-rc5 possible regression: KDE processes die silently
References: <4601B3D0.3060600@imap.cc> <460FCDE2.1080503@imap.cc> <20070402225006.GI14134@stusta.de>
In-Reply-To: <20070402225006.GI14134@stusta.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC5CA55522E14232736A4BBC5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC5CA55522E14232736A4BBC5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.04.2007 00:50 schrieb Adrian Bunk:
> On Sun, Apr 01, 2007 at 05:21:06PM +0200, Tilman Schmidt wrote:
>> I'm sorry to say this has now happened with kernel 2.6.21-rc5, too.
>> [...] it's not reproducible and invariably
>> happens when I'm away from the machine.

I have now finally once seen it happen while I was watching, again
on 2.6.21-rc5. The X display was idle and blanked because I hadn't
touched the keyboard and mouse in a while (it seems to happen only
in that state) but I had "top" running in an ssh session from another
machine so I could see what the machine was doing.

Just before the KDE crash, an "online_update" process appeared. The
KDE processes vanished from "top" more or less together with that
process. Before, the system had been idle except for the screensaver.
"online_update" was most probably started by SuSE's "susewatcher"
applet, and according to its log found some new updates, so perhaps
it did try to emit a sound as Rafael suspects. (The machine doesn't
have speakers connected, so I can't tell.)

> We also have another report of crashes under KDE:
>=20
> Subject    : crashes in KDE
> References : http://bugzilla.kernel.org/show_bug.cgi?id=3D8157
> Submitter  : Oliver Pinter <oliver.pntr@gmail.com>

Could be the same. The report is not detailed enough to say.
Oliver provokes his crash with amarok which would fit in with
the sound hypothesis.

> We also have one bug kwin ran into that got fixed after -rc5:
>=20
> Subject    : kwin dies silently
[...]
> Fixed-By   : Eric W. Biederman <ebiederm@xmission.com>
> Commit     : 14e9d5730adfca26452b3a2838a80af6950556f5

Looks promising. Building -rc5-git12 now. Will test that until
-rc6 arrives.

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
In theory, there is no difference between theory and practice.
In practice, there is.


--------------enigC5CA55522E14232736A4BBC5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD4DBQFGFAugMdB4Whm86/kRAjBoAJi0Cweog6WgLLCF3n29Ivifeoo3AJ9BMW46
UdQ68lAXyS+ExK37KTpChA==
=qRhw
-----END PGP SIGNATURE-----

--------------enigC5CA55522E14232736A4BBC5--
