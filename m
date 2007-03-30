Return-Path: <linux-kernel-owner+w=401wt.eu-S932750AbXC3WiX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932750AbXC3WiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2007 18:38:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932470AbXC3WiX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Mar 2007 18:38:23 -0400
Received: from mx.laposte.net ([81.255.54.16]:7737 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932764AbXC3WiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2007 18:38:21 -0400
Subject: RE: [PATCH 1/5] RT kernel: force detect HPET from PCI space
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Mikko Tiihonen <mikko.tiihonen@iki.fi>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
References: <Pine.OSF.4.64.0703310049090.412261@kosh.hut.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6nkQJWmk107VTrtZBykN"
Organization: Adresse perso
Date: Sat, 31 Mar 2007 00:38:08 +0200
Message-Id: <1175294288.32441.6.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.0 (2.10.0-5.fc7) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6nkQJWmk107VTrtZBykN
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le samedi 31 mars 2007 =C3=A0 01:09 +0300, Mikko Tiihonen a =C3=A9crit :
> > Anyone got the same thing for CK804? I had my hopes high, and then I sa=
w
> > the DECLARE_PCI_FIXUP_HEADER values [and the thread title was misleadin=
g]
>=20
> I have an A8N-E motherboard with AthlonX2 and the ACPI definitions are=20
> missing the HPET (standard feature of Asus motherboards).
>=20
> I too got interested to get my motherboard working. Luckily I found this=20
> http://lkml.org/lkml/2006/12/17/69=20

Oh, is looks so close to my system

00:01.0 ISA bridge: nVidia Corporation CK804 ISA Bridge (rev a3)
        Subsystem: Giga-byte Technology GA-K8N Ultra-9 Mainboard
        Control: I/O+ Mem+ BusMaster+ SpecCycle+ MemWINV- VGASnoop-
ParErr- Stepping- SERR- FastB2B-
        Status: Cap- 66MHz+ UDF- FastB2B+ ParErr- DEVSEL=3Dfast >TAbort-
<TAbort- <MAbort- >SERR- <PERR-
        Latency: 0
00: de 10 50 00 0f 00 a0 00 a3 00 01 06 00 00 80 00
10: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
20: 00 00 00 00 00 00 00 00 00 00 00 00 58 14 11 0c
30: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
40: 58 14 11 0c 00 f0 ff fe fa 3e ff 00 fa 3e ff 00
                ^^^^^^^^^^^
                Usual HPET base address
50: fa 3e ff 00 00 5a 62 02 00 00 00 01 00 00 ff ff
60: 01 10 00 00 01 14 00 00 01 18 00 00 00 00 f9 ff
70: 10 00 ff ff c1 00 00 00 00 00 04 19 18 d2 80 0d
                ^^
                c1 =3D> HPET disabled (according to your reference)

I don't have an HPET toggle in my bios

> from which I generated the following patch:

I'd love to test it, but what kernel baseline did you use?
2.6.21-rc5-mm2?

--=20
Nicolas Mailhot

--=-6nkQJWmk107VTrtZBykN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkYNkUsACgkQI2bVKDsp8g21FACfZGKk1XwPQpoSrVlVFrP525tO
1hIAoObcLUUmdYF3G/ptd5b/oqiGGjbH
=TNSd
-----END PGP SIGNATURE-----

--=-6nkQJWmk107VTrtZBykN--
