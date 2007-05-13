Return-Path: <linux-kernel-owner+w=401wt.eu-S1757989AbXEMIRl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989AbXEMIRl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 04:17:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756797AbXEMIR3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 04:17:29 -0400
Received: from mx.laposte.net ([81.255.54.16]:8421 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756163AbXEMIR0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 04:17:26 -0400
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
	mode:0x84020
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
In-Reply-To: <20070512192408.GA5769@skynet.ie>
References: <20070511090823.GA29273@skynet.ie>
	 <1178884283.27195.1.camel@rousalka.dyndns.org>
	 <20070511173811.GA8529@skynet.ie>
	 <1178905541.2473.2.camel@rousalka.dyndns.org>
	 <1178908210.4360.21.camel@rousalka.dyndns.org>
	 <20070511203610.GA12136@skynet.ie>
	 <1178957491.4095.2.camel@rousalka.dyndns.org>
	 <20070512164237.GA2691@skynet.ie>
	 <1178993343.6397.1.camel@rousalka.dyndns.org>
	 <1178996310.6397.3.camel@rousalka.dyndns.org>
	 <20070512192408.GA5769@skynet.ie>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NKrDV9V5AI6xZUB7Ra1U"
Organization: Adresse perso
Date: Sun, 13 May 2007 10:16:42 +0200
Message-Id: <1179044203.4802.0.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.nim.2) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NKrDV9V5AI6xZUB7Ra1U
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le samedi 12 mai 2007 =C3=A0 20:24 +0100, Mel Gorman a =C3=A9crit :
> On (12/05/07 20:58), Nicolas Mailhot didst pronounce:
> > Le samedi 12 mai 2007 =C3=A0 20:09 +0200, Nicolas Mailhot a =C3=A9crit =
:
> > > Le samedi 12 mai 2007 =C3=A0 17:42 +0100, Mel Gorman a =C3=A9crit :
> > >=20
> > > > order-2 (at least 19 pages but more are there) and higher pages wer=
e free
> > > > and this was a NORMAL allocation. It should also be above watermark=
s so
> > > > something screwy is happening
> > > >=20
> > > > *peers suspiciously*
> > > >=20
> > > > Can you try the following patch on top of the kswapd patch please? =
It is
> > > > also available from http://www.csn.ul.ie/~mel/watermarks.patch

> > And this one failed testing too=20
>=20
> And same thing, you have suitable free memory. The last patch was
> wrong because I forgot the !in_interrupt() part which was careless
> and dumb.  Please try the following, again on top of the kswapd patch -
> http://www.csn.ul.ie/~mel/watermarks-v2.patch

This one survived 12h of testing so far.

Regards,

--=20
Nicolas Mailhot

--=-NKrDV9V5AI6xZUB7Ra1U
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZGyWUACgkQI2bVKDsp8g38igCgmZiajmiYCDhcevIbkYpgDFjt
M08AoIAZVpPExDV2pR3rwXycygCgRcHo
=i80C
-----END PGP SIGNATURE-----

--=-NKrDV9V5AI6xZUB7Ra1U--
