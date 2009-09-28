Return-Path: <linux-kernel-owner+w=401wt.eu-S1753319AbZI1WGJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753319AbZI1WGJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 18:06:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752981AbZI1WGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 18:06:08 -0400
Received: from gold.linx.net ([195.66.232.40]:42760 "EHLO gold.linx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836AbZI1WGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 18:06:08 -0400
Subject: Re: [PATCH] percpu: fix unit_map[] verification in
 pcpu_setup_first_chunk()
From: Tony Vroon <tony@linx.net>
To: Tejun Heo <tj@kernel.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Lameter <cl@linux-foundation.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <4AC0E201.2020006@kernel.org>
References: <4ABAC2F1.3020302@kernel.org>
	 <1254055797.2756.1.camel@localhost>  <4AC0E201.2020006@kernel.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-jfTicep30mG8alvmaeGX"
Organization: London Internet Exchange (LINX; AS5459)
Date: Mon, 28 Sep 2009 23:07:42 +0100
Message-Id: <1254175662.2783.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-jfTicep30mG8alvmaeGX
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-09-29 at 01:19 +0900, Tejun Heo wrote:
> pcpu_setup_first_chunk() incorrectly used NR_CPUS as the impossible
> unit number while unit number can equal and go over NR_CPUS with
> sparse unit map.  This triggers BUG_ON() spuriously on machines which
> have non-power-of-two number of cpus.  Use UINT_MAX instead.
>=20
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Tony Vroon <tony@linx.net>
Tested-by: Tony Vroon <tony@linx.net>

> Erghh... stupid mistake.  This should fix it.  Can you please verify?

Confirmed fixed. Thank you Tejun.

Regards,
Tony V.

--=-jfTicep30mG8alvmaeGX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEABECAAYFAkrBM64ACgkQp5vW4rUFj5riPACgu0vknqRao0ssNCrRwv+SA+n5
vA0AmgPfvLtE4jz7HrsFPsZbYHG2qUG9
=iswG
-----END PGP SIGNATURE-----

--=-jfTicep30mG8alvmaeGX--

