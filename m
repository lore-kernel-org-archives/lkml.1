Return-Path: <linux-kernel-owner+w=401wt.eu-S1754847AbYK0WG5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847AbYK0WG5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2008 17:06:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753807AbYK0WGr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Nov 2008 17:06:47 -0500
Received: from ozlabs.org ([203.10.76.45]:45869 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479AbYK0WGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2008 17:06:47 -0500
Subject: Re: [PATCH 4/5] powerpc: ftrace, use create_branch
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
       Milton Miller <miltonm@bga.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, Steven Rostedt <srostedt@redhat.com>
In-Reply-To: <20081126220423.514020907@goodmis.org>
References: <20081126215821.263324391@goodmis.org>
	 <20081126220423.514020907@goodmis.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-L32+WZgIi6eKd1ws7hX9"
Date: Fri, 28 Nov 2008 09:06:43 +1100
Message-Id: <1227823603.7852.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-L32+WZgIi6eKd1ws7hX9
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-26 at 16:58 -0500, Steven Rostedt wrote:
> plain text document attachment
> (0004-powerpc-ftrace-use-create_branch.patch)
> From: Steven Rostedt <srostedt@redhat.com>
>=20
> Impact: clean up
>=20
> Paul Mackerras pointed out that the code to determine if the branch
> can reach the destination is incorrect. Michael Ellerman suggested
> to pull out the code from create_branch and use that.
>=20
> Simply using create_branch is probably the best.

You're right, that's a lot simpler :)

Acked-by: Michael Ellerman <michael@ellerman.id.au>

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-L32+WZgIi6eKd1ws7hX9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkvGfMACgkQdSjSd0sB4dKb6ACfYZggO3wwd6mhUrzNcncgV1K+
uRwAnRxz5RsGZ8R5iNn4zsQr1gcjq8Ie
=kpKD
-----END PGP SIGNATURE-----

--=-L32+WZgIi6eKd1ws7hX9--

