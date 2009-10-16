Return-Path: <linux-kernel-owner+w=401wt.eu-S1757644AbZJPI6Z@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757644AbZJPI6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Oct 2009 04:58:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757598AbZJPI6Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Oct 2009 04:58:25 -0400
Received: from k66.ru ([87.224.128.21]:49854 "EHLO k66.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757516AbZJPI6R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Oct 2009 04:58:17 -0400
Date: Fri, 16 Oct 2009 14:57:39 +0600
From: Andrey Rahmatullin <wrar@altlinux.org>
To: linux-kernel@vger.kernel.org
Subject: Re: drivers/staging/rt2860 doesn't compile
Message-ID: <20091016085738.GG19095@wrars-comp.wrarsdomain>
References: <20091014063824.GD6298@wrars-comp.wrarsdomain>
 <20091014182729.GC19095@wrars-comp.wrarsdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DNUSDXU7R7AVVM8C"
Content-Disposition: inline
In-Reply-To: <20091014182729.GC19095@wrars-comp.wrarsdomain>
X-Operating-System: ALT Linux Sisyphus
X-Jabber-Id: wrar@altlinux.org
User-Agent: Mutt/1.5.20 (2009-06-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DNUSDXU7R7AVVM8C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 15, 2009 at 12:27:29AM +0600, Andrey Rahmatullin wrote:
> Even after trivial fix (including <linux/sched.h> into
> drivers/staging/rt2860/rt_linux.h) the driver doesn't compile:
>=20
> drivers/staging/rt2860/rt_main_dev.c: In function 'rt_ieee80211_if_setup':
> drivers/staging/rt2860/rt_main_dev.c:691: error: 'struct net_device' has
> no member named 'wireless_handlers'
For the archives: it just means that CONFIG_WIRELESS_EXT should be enabled.


--=20
WBR, wRAR (ALT Linux Team)

--DNUSDXU7R7AVVM8C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJK2DWCAAoJEOih81koZvPBDrUH+QE1w3IBWXNDAT/WqgG4Y/KU
9ApUFWCPNKHCBd611aatXt5jJ66V1U+WFM7QpmsgSEpflHXNWpE1WU3F/+oy33Im
wfuMaye3I1+0PYK8sjpRhKdSPAyWHT2H73BHsea4cZB7NGECQ7//Anwx8injxod9
e6SfPVbTJQOoT7kMVf614HLAfbBAV+UrpMbZt/k+k5EyngEgJUbzwlYpRHFexREQ
EalM6IF2ZghLknAwxMrVguijVF7VeGdI0kV/QAhOhD3idm6FIgYRqGwk0vscMHVm
K88c2Tc7USCBIwaqsfHq3ymVKQbhi2iauEFAQZmDnUKI9JdlsqSs1of2zAb8Zbs=
=k33L
-----END PGP SIGNATURE-----

--DNUSDXU7R7AVVM8C--
