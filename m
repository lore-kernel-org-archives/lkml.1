Return-Path: <linux-kernel-owner+w=401wt.eu-S1752893AbZLULJY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752893AbZLULJY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 06:09:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751724AbZLULJX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 06:09:23 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:37429 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbZLULJW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 06:09:22 -0500
From: Ritesh Raj Sarraf <rrs@researchut.com>
Organization: RESEARCHUT
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not provably correct
Date: Mon, 21 Dec 2009 16:39:05 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <0io307-9ti.ln1@news.researchut.com> <20091221180537.089C.A69D9226@jp.fujitsu.com> <20091221091330.GA22867@elte.hu>
In-Reply-To: <20091221091330.GA22867@elte.hu>
X-Face: f->Rbf[[J{vnguEZ~[KiVewkyV<sub[{z7X`jiAw--8?<Bxu6|9{5k8)
 =?utf-8?q?=7ELaeG=7B!=7B=23E=231=26m=0A=09Bc!F4=60CU?=(_*HuAJQ-Hg&)#RE1")sigixu$KY[)NcvLJaOZ*-Zn}b#]Jfbq<
 =?utf-8?q?j=2Eoz-esxTAb=0A=091Qk=27+nbo=7BN4jin0tUESU=3F?=)N%8xqWJdxI6K~@e_6b83P.X.iv13r,7IFuXz2-#7&`XI<
 =?utf-8?q?z=5B!=0A=09u5FK=5BVG=24fDTT=25YDboR+?=>)R._R#}#`Jx~Z6e{oT{c0xZxa8=H>$|DqF@(
 =?utf-8?q?XR7n=7C2D=3Dp7=25oVp=0A=09=3D=5E=3F2729y=5D8A?="Vi8w@V#DwL^XqM(,O^;z~i+@'G-&QIvYnOH
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2357049.JtC0A0Dr5b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912211639.05887.rrs@researchut.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2357049.JtC0A0Dr5b
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Monday 21 Dec 2009 14:43:30 Ingo Molnar wrote:
> hm, the one mm/migrate.c fix we had is already in -rc1:
>=20
>  b9255850: mm: Adjust do_pages_stat() so gcc can see copy_from_user() is
>  safe
>=20
> I've Cc:-ed more folks.
>=20

I have verified the build tree and am building from -rc1 only. The fix you'=
ve=20
mentioned above is also part of it.

debian-build:/tmp/all-yes-config/2.6.33-rc1# cat Makefile |grep EXTRAVERSION
EXTRAVERSION =3D -rc1

Must be a newer bug then.


Regards,
Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--nextPart2357049.JtC0A0Dr5b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJLL1dRAAoJEKY6WKPy4XVp2qMP/1d8Ntm7KxvtsqAg0sxs+FUx
k98A9WOVQH9I+Ve/u18eJZIr5p+2PJ1xGc2V61Thv+z7+DX48lHC2xsikahGseci
5e7K93GxbME2SFLaX4z0v9nYCqf9hqiFgYQJc8rCnLvuQdB+2gNSmDhoWCt2rvsg
5aD15/Q5daGES4Z6osMG67GxISd7ioOmXZHni4KnB8JbV8Q6BB1kXkfhQ40Ud1Um
yZUhPUcTgtjc9YoJQmEwT6WHHpnBZdJzpZb4/CzTtDL9jas2fXkgcbBVwzg0j0zC
SmBecxG+WvlPTb2VaJOgv4iwj4ztDQsrS9S8yv+Fy+zD6Tl+VrzY14Hk4oz44N4e
Zf4ZMoc1JI4ahiBlclXRBUvrDDuXpRCYlxmYwEis1WJbXXpZ8E783wvArZz5+XPR
Cxe4FaO82lznVJriWgWadzMkCrcbGARiA0da8jRyA1pHH2ldOS10/Lm1Lpa4KsJ3
rXqjmBv7Kj26Ut0tJxRHAOipmCaEXV74Kpx0KSRrM8vtgdghCm6TupiZOR1iDo8o
QZqFNBUtLhJZNb2k7E7ZNDR3FTDmnHROpSFV1MqzRcd2ADKS3ha2HhEAJjx0RY+e
s3yQxubP/RB5NNyd4E3kQtlE+W7E2XWEKc9clgUmsVnQ0HfC7wOGhsvsrgM0bgyK
qEfWRL0dKnuJJKYqoBFT
=Y5bT
-----END PGP SIGNATURE-----

--nextPart2357049.JtC0A0Dr5b--
