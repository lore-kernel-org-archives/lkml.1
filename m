Return-Path: <linux-kernel-owner+w=401wt.eu-S1757441AbYKEUMn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757441AbYKEUMn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 15:12:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752127AbYKEUMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 15:12:34 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:56440 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752523AbYKEUMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 15:12:33 -0500
Subject: Re: [RFC] B+Tree library V2
From: Johannes Berg <johannes@sipsolutions.net>
To: =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081105200635.GE6561@logfs.org>
References: <20081026124643.GA1328@logfs.org>
	 <1225449314.3535.23.camel@johannes.berg> <20081031112651.GD18182@logfs.org>
	 <1225452761.3535.28.camel@johannes.berg> <20081031125453.GE18182@logfs.org>
	 <20081101155958.GA28776@logfs.org>
	 <1225915040.3619.155.camel@johannes.berg> <20081105200635.GE6561@logfs.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-Ay3Kli3eBHQ5nlF3Zdtm"
Date: Wed, 05 Nov 2008 21:12:34 +0100
Message-Id: <1225915954.3619.166.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ay3Kli3eBHQ5nlF3Zdtm
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-11-05 at 21:06 +0100, J=C3=B6rn Engel wrote:
> On Wed, 5 November 2008 20:57:20 +0100, Johannes Berg wrote:
> >=20
> > That sounds fair, after all at least it limits the tree size, but I'm
> > too lazy to calculate the worst case right now.
>=20
> Worst case you have a single entry next to a full node, then split the
> full node, etc.  So slightly more than 1/4 populated.

That would be roughly 1/3, no? But it doesn't really matter much.

> > I'd use this as-is for the WIP cfg80211 code that keeps track of BSSes,
> > as a hash-table/list on steroids.
>=20
> Excellent.  With this trojan horse in place I don't have to worry much
> about a competing library with a different interface.  Famous last
> words. :)

:)
How we going to synchronise this? I'm not in a hurry with this scanning
code and I need to work on it still anyway.

johannes

--=-Ay3Kli3eBHQ5nlF3Zdtm
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJJEf4vAAoJEKVg1VMiehFYuIoP/35KmnJa+LV5Bv+9f1OdX6/z
kqVGlgNdNVtjHSSN4CZZTbBFm32ltiOO26q57/NvJinhwZ4FN7YmxSFdQYhevHNP
tRnciqUcJPI13kp9t/wB2r6IufixeuuL8OpfldpTb369GCm7dJJmg3cyebOV2/qj
XXEuuTkTMq4RTmeOYVtB80CKmNBNnWm2lBfTz0X076eaYMI8FJNWWCEgtq8BB00/
TyezlhLHGCoJMxbfRzQkMvF5srCV7LdfO4ioEK75ZIkVVKUI0O4RA4FhoGd6p9s1
S45rnU6NC3jBYFtpz8uDUUqz2DPncbOkkKb7m/mjndJ2bSs2BKVTGUt5V0nAKf20
dMguC5wt+LtdLKsucghe2KNUNRMXWVPgNdj0bNXvILHIhUAGJQgcJtl3mEg9dn5O
YnGcDMnbvIjLTmYeXJsR12O3nMzmk5vxjMdpMxfNO3UZvQNvBMK8QC0ZFBRRU7ho
FesI6c8FwqJdwRZeook+fNkrca/+Mpc1Cxkai+Z3sT9KkQUaxKmKQXnAzS2BFZnG
0+rGqCTXXGiynhIGGxisGteFC3H2SSGBdFoweWtAR67aBDbJiKwz++gcKTBFymeN
oNbyCbq0cfgM0lL9mUW2Qvi2zqupZ72fBzaAX55X3RAeG1WFFtpzbY+Nb0cTvkV+
Jt1wVtXNh/lPtNWsLbyN
=BAUg
-----END PGP SIGNATURE-----

--=-Ay3Kli3eBHQ5nlF3Zdtm--

