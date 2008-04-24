Return-Path: <linux-kernel-owner+w=401wt.eu-S1755541AbYDXJ2S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541AbYDXJ2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 05:28:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751396AbYDXJ2G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 05:28:06 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:36326 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298AbYDXJ2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 05:28:05 -0400
Subject: Re: cpu_clock confusion
From: Johannes Berg <johannes@sipsolutions.net>
To: David Miller <davem@davemloft.net>
Cc: mingo@elte.hu, benh@ozlabs.org, linuxppc-dev@ozlabs.org, arndb@de.ibm.com,
       linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <20080424.022404.151729194.davem@davemloft.net>
References: <1207240450.3797.22.camel@johannes.berg>
	 <20080404144641.GA15844@elte.hu> <1209028912.3357.52.camel@johannes.berg>
	 <20080424.022404.151729194.davem@davemloft.net>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-KgKVwN7fyWIfBjxIeN7E"
Date: Thu, 24 Apr 2008 11:27:37 +0200
Message-Id: <1209029257.3357.55.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KgKVwN7fyWIfBjxIeN7E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-04-24 at 02:24 -0700, David Miller wrote:
> From: Johannes Berg <johannes@sipsolutions.net>
> Date: Thu, 24 Apr 2008 11:21:52 +0200
>=20
> > Hmm. Why is that whole cpu_clock stuff in place anyway? powerpc has
> > perfectly synchronised time across processors with dirt cheap access to
> > it as well, so why build all this code that only messes it up on top of
> > it?
>=20
> Same on sparc64.  These changes add more bugs than they fix.

I tend to think all this clock business should be done local to those
arches that aren't capable of providing cheap, useful synchronised and
accurate clocks themselves. Or be a lib that they can link in if needed.
As it stands, it seems to me that it all just penalises those
architectures that have decent clocks.

johannes

--=-KgKVwN7fyWIfBjxIeN7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUASBBSiKVg1VMiehFYAQKZYhAAvu79aDQ29ZuybMzVS719na1/mYCbzePU
VdD3W9mJ/vGgNTXOcNwbQ5a7R6R+Qr4Uc6brltUVVOGLbm3fRvKAOLNlxhGKs6Tp
xO3DMPM6J2ZyULCcBSvjTgI9zKMrqkJvEkwvaUD6KHocPrGjev3DHsgDXZA3kbHG
NJc+xR3w67D27l06YLAa1SPZdXjSQ7elEnNksw4P3GuC/Qx5GSpNOwgkxdUTyfu+
DTMzja+erUATFsDid86sZI09/UZ5D0X8ox1N0tSKmuuQsmwlOaf83FnBEoLx2S1i
OQMDzJjVIyCmfeyR5f7jYZd1K4sqm78is7WlOxnqT9Y9MTqp5NgBMCqAg1fD5i8n
6qUZqyElpxxcsbK8y9aBzgdCezPmsbUkNqHxGTYZmncmyUJE1o90G5ZrtLjYU8w5
i9kq/VaxZZM9CIlOgl/boFjbCbZFJoDkmZat6Ifv1LcDSOLI31ZuaNkdafdoUevl
QsK0jHIVYfxeMvKm+l4KX45sJldNePNrnTk7NPSWTKikelCgREt4qeyzKYS5xb4m
i5Kan05KzACSLCRm+wt0AJTtQCNY56uXVqatn47p2zwyajkVqhF8pWnNrX5H94jw
rJd1jOv9c0+9WlRfWawkZ5xmdu8fmW32VVft6Rv3toCvXozS4EJPn26gpzGV9ZPG
RvTNTGbqIYk=
=18oW
-----END PGP SIGNATURE-----

--=-KgKVwN7fyWIfBjxIeN7E--

