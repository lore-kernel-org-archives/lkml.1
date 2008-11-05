Return-Path: <linux-kernel-owner+w=401wt.eu-S1757338AbYKEUZf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757338AbYKEUZf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:25:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753546AbYKEUZZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:25:25 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:52883 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYKEUZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:25:24 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081105202158.GF6561@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org>
	 <1225915040.3619.155.camel@johannes.berg> <20081105200635.GE6561@logfs.org>
	 <1225915954.3619.166.camel@johannes.berg> <20081105202158.GF6561@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-SjXLbkhBNaDuZ891cf2T"
Date: Wed, 05 Nov 2008 21:25:24 +0100
Message-Id: <1225916724.3619.175.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-SjXLbkhBNaDuZ891cf2T
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 21:21 +0100, J=C3=B6rn Engel wrote:
> On Wed, 5 November 2008 21:12:34 +0100, Johannes Berg wrote:
> > On Wed, 2008-11-05 at 21:06 +0100, J=C3=B6rn Engel wrote:
> > > On Wed, 5 November 2008 20:57:20 +0100, Johannes Berg wrote:
> > > >=20
> > > > That sounds fair, after all at least it limits the tree size, but I=
'm
> > > > too lazy to calculate the worst case right now.
> > >=20
> > > Worst case you have a single entry next to a full node, then split th=
e
> > > full node, etc.  So slightly more than 1/4 populated.
> >=20
> > That would be roughly 1/3, no? But it doesn't really matter much.
>=20
> When entries/node approaches infinity it is 1/4.  With 4 entries/node,
> which is the smallest useful number, it is 3/8.

Ah, right.

> > How we going to synchronise this? I'm not in a hurry with this scanning
> > code and I need to work on it still anyway.
>=20
> I could create a git tree and ask for inclusion in -next.  Or you could
> combine it with your code.  I slightly favor the latter, as a library
> without any users is somewhat... useless.

I can do that, though I can't promise right now when I'll actually be
able to solve the remaining problems with that code. And I also thought
you already had another user in mind :)

johannes

--=-SjXLbkhBNaDuZ891cf2T
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEgExAAoJEKVg1VMiehFYD9wP/27DH2jAIl4ATemuMx5nBdgM
6m1XOv1B/jWvn7pnnun1eGmwZLPBgGLRWvbfbVcnqGlYtJ0H6lHDuqVpClTPvFZV
a2A1XDlOpwlfZqaxtoYgCr7Ui6OEY/Y43hgBuQQ0LwWmoqHGcgpcjzYeVBFS+6jQ
DserG3zHpOvk2FARAdSNdGdES6cHeL1FUxzshBA4VznfdOkO8xt6BEk2tsD3RVrK
NHiEzYE0F0Zzy0mnVivskjPJXZzAxFPIyVA3gSy8ouJMhgWtH5ElIUkAxR5ABGvg
1jmpttEWTGJtHYpzixM+ALmF/1TZ5GrQyXBItsQam2KLWv/Jo/BTbk+lBDar1WeH
tw+kZPJp+UMllEldxeKkkTXrd46400Cb3Key8zEsAU9JPTli7wQfSE/8JhAP05sB
hmdFTSRjG69/KHqvyZh4udno6/AWIxo8gkjmF6p+WXV5cO7tdDE9pMLk3UA1jnfv
7RDMXH78qIcNo7NbVb8hb/Y7sqpOsfBQTV3Ub7SOnNoEkvNbCSPojAfHOTrocN0F
YI2sLZsIA8Gs4JDYRYjRLjcbYn8Poc8a89Wk08pHMcx+yjOa+bX2dXGhjpBW4t9w
aqTccqIDclyLN0bg8w9cXmT/FreMNrNzIA5wo7goLzEz6k4zZjNPnrqJj4lnkvJX
V21u+U28mOei/ww9eckJ
=5Nq6
-----END PGP SIGNATURE-----

--=-SjXLbkhBNaDuZ891cf2T--

