Return-Path: <linux-kernel-owner+w=401wt.eu-S1751965AbZLURnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751965AbZLURnR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Dec 2009 12:43:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZLURnQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Dec 2009 12:43:16 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:50264 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbZLURnP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Dec 2009 12:43:15 -0500
From: Ritesh Raj Sarraf <rrs@researchut.com>
Organization: RESEARCHUT
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: 2.6.33-rc1 build failure: copy_from_user() buffer size is not provably correct
Date: Mon, 21 Dec 2009 23:12:58 +0530
User-Agent: KMail/1.12.4 (Linux/2.6.32-trunk-686; KDE/4.3.4; i686; ; )
Cc: Ingo Molnar <mingo@elte.hu>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Arjan van de Ven <arjan@infradead.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
References: <0io307-9ti.ln1@news.researchut.com> <20091221091330.GA22867@elte.hu> <4B2FADC5.3020709@zytor.com>
In-Reply-To: <4B2FADC5.3020709@zytor.com>
X-Face: f->Rbf[[J{vnguEZ~[KiVewkyV<sub[{z7X`jiAw--8?<Bxu6|9{5k8)
 =?utf-8?q?=7ELaeG=7B!=7B=23E=231=26m=0A=09Bc!F4=60CU?=(_*HuAJQ-Hg&)#RE1")sigixu$KY[)NcvLJaOZ*-Zn}b#]Jfbq<
 =?utf-8?q?j=2Eoz-esxTAb=0A=091Qk=27+nbo=7BN4jin0tUESU=3F?=)N%8xqWJdxI6K~@e_6b83P.X.iv13r,7IFuXz2-#7&`XI<
 =?utf-8?q?z=5B!=0A=09u5FK=5BVG=24fDTT=25YDboR+?=>)R._R#}#`Jx~Z6e{oT{c0xZxa8=H>$|DqF@(
 =?utf-8?q?XR7n=7C2D=3Dp7=25oVp=0A=09=3D=5E=3F2729y=5D8A?="Vi8w@V#DwL^XqM(,O^;z~i+@'G-&QIvYnOH
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3537085.z8e2dT16WW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200912212312.58988.rrs@researchut.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3537085.z8e2dT16WW
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Monday 21 Dec 2009 22:47:57 H. Peter Anvin wrote:
> > I've Cc:-ed more folks.
> >=20
>=20
> That is the error report that he is describing.  What version of gcc
> is he using?  It might be dumber than the one I have.
>=20
debian-build:~# gcc --version
gcc (Debian 4.4.2-5) 4.4.2


Regards,
Ritesh
=2D-=20
Ritesh Raj Sarraf
RESEARCHUT - http://www.researchut.com
"Necessity is the mother of invention."

--nextPart3537085.z8e2dT16WW
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJLL7OiAAoJEKY6WKPy4XVpemUQAKS2cleRlfmto5WODbaHJHdO
OzayEh/Xhwb1+Irn6jnfZAHyKJSvI4jALDOfCdIo0boz1l4nQKeaC4GduO3Ro/qd
hckYfDycgqJDVFTC6NRtaK1DvTPnHIltZQ/qzjT+rkrOQ2m1x9UiHXL0YI+dk/rE
s2VlTBEYD5cbqMe8wEdqYVMRDUlswiyMybQpAtxsOR1yyMcviD3w6NwaSTW89/mJ
HqBnOeg3hMJTZF8701soCOqBohmELVrPiQizAqvn0v8KE3pDzFICVk+Ep6FeDi+Y
4+U+Y7hv6iI+VnAVxLAtsSWnHi7TH+sIM1lud/nQD8l0P9PTPPwXyYshO6+wWTNO
Xplga0iRHYCc1DIcl7m9U387bzFAwN47m+iC41TevQvM8musJIMbfeyo3AIfubJi
gBg0gEvyfBJ77ZclnGwfxeQWQ88B9RaXxHKPX8rvjOsz+9a4GczfmbhRApLTl0gi
IU++j6+wKgRghU055RmhGhCTNGwmtxFq69qB3S86pWlGplG7qQGU0r/8r25qNiD6
o/6J8CWjmHWkDV89wqgjvNGNEfyru6l30GrqErjbRMao8oQ8F02GPwEn9WHrjT2R
285oC+7YAPxXMxp/lm8OZkoFTs6CAJgBtM3Mm/9qY0TMmmHkL5QaQr8BQlqZqO5Y
fREEK1V8pNJKCsNPNLW6
=nNCM
-----END PGP SIGNATURE-----

--nextPart3537085.z8e2dT16WW--
