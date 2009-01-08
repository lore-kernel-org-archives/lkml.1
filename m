Return-Path: <linux-kernel-owner+w=401wt.eu-S1760815AbZAHQuM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760815AbZAHQuM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 11:50:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758125AbZAHQth
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 11:49:37 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:33256 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687AbZAHQtg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 11:49:36 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20090108162429.GA24884@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org> <1231376241.3545.96.camel@johannes>
	 <20090108162429.GA24884@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-jpPGhEJuW5hT5kJ/u0nj"
Date: Thu, 08 Jan 2009 17:50:04 +0100
Message-Id: <1231433404.8398.1.camel@johannes>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jpPGhEJuW5hT5kJ/u0nj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> Maybe it should be renamed to btree_get_prev_key().  I never noticed how
> confusing it was because my head was busy with other problems.  The code
> is currently burried within my logfs tree:
> http://logfs.org/git?p=3Dlogfs;a=3Dsummary

I see this:


- * Second trick is to special-case the key "0" or NUL.  As seen above, thi=
s
- * value indicates an unused slot, so such a value should not be stored in=
 the
- * tree itself.  Instead it is stored in the null_ptr field in the btree_h=
ead.

Does that mean that wasn't true, and I can store a 0 key?

johannes

--=-jpPGhEJuW5hT5kJ/u0nj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIbBAABAgAGBQJJZi65AAoJEKVg1VMiehFYKJsP90HsRrlFYE/a6beUsLNq4vxU
7r7FYfxgbxmrPH+5qZdyQg2mWVDACq/nBGDyH3r4Gz1G9Z4O5NUDAUiZyqWtnRLq
RGnFfYLKpXKaCg9dPvv5AhXBFexPuzRW41xXTpLO7sKanl7sHvNmLfRfOQCkgnJN
3MKpWJbs7cVHOeM4NF0buUrVwT2vaQHIKbMvxTuypk/vtauDox1AiL3jh8RHAn0W
UYSn2sHwf1xIIzC8zwLo2kfzmBKL5z5UUAW9F569V2X0ssXtJF12AFh+ylNTgPzC
vj8H2opegHhSpNKzaaYMrXvZZ0/k5gagwxWMb5fDxYvJbapRGWtg29Amvu1wklMO
UbQT/Oe/omvWf+IN42dK5H/OQEKBnD3jB57fCvWrRoppiVyhBMJuEy2AkNsXdj6+
3HQj01Lp2hmDUx18r56/w4F8xhBnoeT5AcU9Vcju3xuDg50BrQ05wUBMHTQkOg3L
xFs9DSBrKV/dSmzOqpiAwocqa6IFz4HmD2Zb0stJwrIPmboNXOfhfnaEwoZmNJjN
M8NVkbHCf+uPCdqJYSZcVCk7Q7CN5V/+MlLrAtua1eZpkcAFWtiyCixm8Utdfbtp
6hwh4NwlZS7w0iazMn9u9ca9XPcHSoBE2I/NiVuTQGQhMJA6hJvTIxDVl4gT+BxC
4pz1lZPE18Nb39u0KK8=
=PDXk
-----END PGP SIGNATURE-----

--=-jpPGhEJuW5hT5kJ/u0nj--

