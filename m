Return-Path: <linux-kernel-owner+w=401wt.eu-S1759336AbYBRKgU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759336AbYBRKgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 05:36:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759039AbYBRKgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 05:36:04 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:3621 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755895AbYBRKgB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 05:36:01 -0500
Message-ID: <47B95F71.8030306@imap.cc>
Date: Mon, 18 Feb 2008 11:35:29 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Jeff Chua <jeff.chua.linux@gmail.com>
CC: Jiri Slaby <jirislaby@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.25-rc2 regression: LVM cannot find volume group
References: <alpine.LFD.1.00.0802151302210.9496@woody.linux-foundation.org>	 <47B73616.9050303@imap.cc> <20080216201206.1452cfe7@core>	 <47B765B1.1030709@gmail.com> <47B8D80C.8000408@imap.cc> <b6a2187b0802171722o3ceab5eaj50f816fbbd65adfb@mail.gmail.com>
In-Reply-To: <b6a2187b0802171722o3ceab5eaj50f816fbbd65adfb@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigADFBD238B1FBF1C0AE83184C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigADFBD238B1FBF1C0AE83184C
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Am 17.02.2008 schrieb Jeff Chua:
> I faced the same problem, but resolved with ...
>=20
> vgscan
> vgchange -a y

Sorry, I'm not sure what to do with those two commands.
Running them once manually doesn't seem to change anything,
and my initrd already contains them AFAICS.

> Also, ensure you set "write_cache_state =3D 1" in /etc/lvm.conf before
> running the above.

That was already set by default.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigADFBD238B1FBF1C0AE83184C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHuV96Q3+did9BuFsRAkwHAJ4kXuSfHcl2FcvAg5ivMyedRFBigQCfQaYk
b13rWRZ12hzBiLkn+DRKvE8=
=wRye
-----END PGP SIGNATURE-----

--------------enigADFBD238B1FBF1C0AE83184C--
