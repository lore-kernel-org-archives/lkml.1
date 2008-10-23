Return-Path: <linux-kernel-owner+w=401wt.eu-S1754574AbYJWPOT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754574AbYJWPOT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Oct 2008 11:14:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751612AbYJWPOK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Oct 2008 11:14:10 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59960 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751318AbYJWPOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Oct 2008 11:14:08 -0400
Subject: Re: How do I printk <type> correctly?
From: Johannes Berg <johannes@sipsolutions.net>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081023114133.GA30187@x200.localdomain>
References: <20081023114133.GA30187@x200.localdomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RQrmLC3SoWU/V48mhxgo"
Date: Thu, 23 Oct 2008 17:13:26 +0200
Message-Id: <1224774806.6002.42.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-RQrmLC3SoWU/V48mhxgo
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> u64 SHOULD be printed with %llu/%llx, (unsigned long long):
>=20
> 	printk("%llu", (unsigned long long)u64_var);
>=20
> s64 SHOULD be printed with %lld/%llx, (long long):
>=20
> 	printk("%lld", (long long)s64_var);

out of curiosity, why are there platforms that use an "unsigned long"
for u64? An "unsigned long long" is 64-bits too even on 64-bit
platforms, so why the difference? Are there any differences like
alignment on some platforms?

johannes

--=-RQrmLC3SoWU/V48mhxgo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJAJSSAAoJEKVg1VMiehFYLfQQAJLVwAdUO4V+hUY7iVEk/Xm3
6qi24r+ZeQxCh5S35sY50+db0d1OkBm2Z4u/4oNLrE2SBaV+2gdUmHHgqKG36GCl
4hTX66PZjCQVWF8SnwFcmrupiTKfDnvNUliQleV5c8gATGyWgb9pNTcE6XjdDbvz
HCC2WwjAsTAynEqYsVsP5TyCpO3rGAug1K47bQnApEYHVPVjz9ffgNuWnJ8fT/l4
ZHwIVVzhXACvt2vTV8puJXvB3MqNgPlY1ejDJkyicT3q4hMqnbSt2ACpdix7cXuH
TRuDgZoJSwlgvKdGuwjm2RNEpBFi10k2nj6LwUxjkQr8Qb9DlCTkUFskeFfyckp7
6qcrmzJaTVwkJi4jpf3f57k9I5xdkAW3ukqV6aL7u1ul5hh14PAESChieKVoiC9h
p4TGkj/Lb3IhvC2BA/j4/D2kb/hxSJb/PCHaSEzWKrXrU3B0YOmqE4FHGrhendbQ
b3huWtUDgor0bLQVH4tqzZGEp2oo5Cmtr/Miwc9JARRVaSzHTUt/PKV4q63Op24P
Efcuzi6+nOA4Lr0zhf/fciC92PTqquPxFnyHiiNqEuMPIA5oAc9jrpC9r5i1IKWh
tQLzWNkR/PZyPAw9hp+aWQ8gEiIrTMgZYtuoCIpQh0ZQF0d3eWkAPP9RrzdFNfq/
8sOnWgelJGT9wMAVciF/
=6yH/
-----END PGP SIGNATURE-----

--=-RQrmLC3SoWU/V48mhxgo--

