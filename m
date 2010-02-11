Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955Ab0BKUiu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Feb 2010 15:38:50 -0500
Received: from nn7.de ([85.214.94.156]:38882 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756901Ab0BKUit (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Feb 2010 15:38:49 -0500
Subject: Brightness control for MacBook Pro - Nvidia 9400
From: Soeren Sonnenburg <sonne@debian.org>
To: mjg@redhat.com
Cc: nicolas@boichat.ch, felipe_alfaro@linuxmail.org,
       Julien BLACHE <jb@jblache.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-7UHgAHNm8CcMsa9puVbB"
Date: Thu, 11 Feb 2010 21:38:45 +0100
Message-ID: <1265920725.7103.7.camel@no>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7UHgAHNm8CcMsa9puVbB
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Dear all,

I am booting a MacBookPro5,3 using elilo and efifb. Now I'd like to use
pommed to control display brightness (which won't work). Digging around
in mbp_nvidia_bl.c I figured out that tries to control the geforce 9600M
instead of the currently active geforece 9400m

02:00.0 VGA compatible controller: nVidia Corporation G96 [GeForce 9600M GT=
] (rev a1)
03:00.0 VGA compatible controller: nVidia Corporation C79 [GeForce 9400M] (=
rev b1)

Does anyone have an idea which bytes to tweak to change brightness
levels for the 9400? Seems like 0x52f does not work - at least
setpci -s 03:00.0 0x52f.B=3D10 fails...

Thanks!
Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-7UHgAHNm8CcMsa9puVbB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABAgAGBQJLdGrPAAoJEH82z1Wqh6p3FfYQANPPtkAM+IgTxd2u5AfRBFsm
SnR646AnuSV6xSwvHeXZlX1WOLG63AyVvudo1XOvIvs7wqbmoD3ndP2c67EmTthW
odtGukpdhPuRd4MJH0Ggb790o4iZMrgCQpigpMMg+OTaZ9MdVVh/DEmC6rY9dRN3
dKfn4/WWzJr82Jt9VG9ciqsVxAwPrtou+k+PJw7dMe2Bo77u+HxWgiJvkRyhHyNX
1xhnOHTwWUFOS92LpsWT7AHd4XvbCTnidmlnUoadtR9mFPE7B+qWo5fy/V/F3A2Z
2Gz8NWFmK9TNSwlT9+X9bNhHNSTkISUuYP5ZxZ9cPKgUxTtoz10ZpRE5Mbb63TZF
Pt/4fU3kc8RgkrPdmxI93xLTJ5HIAHtgW0HROtpkodxfmbOiytpHx6vtmQEiSJ6F
m5FcMsSBQAv+WHDMQ9oeFs7c8bjBUSfZSUwb0NA1g+GBrq+RSTqZJERxv7svE5Fd
1tcJmwbRYSnJiwzucyPUJF+FomUZ2iNGmHp869ASFdVq8iBzqXlcMIXHIAE58tLb
u24zRk0xEqbx9F3LOLawKJq7ufVEoMD7Oj2O5vxRT+yU3OXyzwO1sVDpCsOyds/Q
YAQp4YD53bnmhXp561CShyyMX8UY77+zXFjL3YTUjk0fUofaPHcolcLd16MnerKG
wTx6dHtByf/b+vFIDm0B
=yYB0
-----END PGP SIGNATURE-----

--=-7UHgAHNm8CcMsa9puVbB--
