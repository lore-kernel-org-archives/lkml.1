Return-Path: <linux-kernel-owner+w=401wt.eu-S1760686AbXEKLwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760686AbXEKLwK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 07:52:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757701AbXEKLv6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 07:51:58 -0400
Received: from mx.laposte.net ([81.255.54.16]:43047 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756055AbXEKLv5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 07:51:57 -0400
Subject: Re: [Bug 8464] New: autoreconf: page allocation failure. order:2,
	mode:0x84020
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: Mel Gorman <mel@skynet.ie>
Cc: Christoph Lameter <clameter@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org,
       "bugme-daemon@kernel-bugs.osdl.org" 
	<bugme-daemon@bugzilla.kernel.org>
In-Reply-To: <20070511090823.GA29273@skynet.ie>
References: <Pine.LNX.4.64.0705101447120.12874@schroedinger.engr.sgi.com>
	 <20070510220657.GA14694@skynet.ie>
	 <Pine.LNX.4.64.0705101510500.13404@schroedinger.engr.sgi.com>
	 <20070510221607.GA15084@skynet.ie>
	 <Pine.LNX.4.64.0705101522250.13504@schroedinger.engr.sgi.com>
	 <20070510224441.GA15332@skynet.ie>
	 <Pine.LNX.4.64.0705101547020.14064@schroedinger.engr.sgi.com>
	 <20070510230044.GB15332@skynet.ie>
	 <Pine.LNX.4.64.0705101601220.14471@schroedinger.engr.sgi.com>
	 <1178863002.24635.4.camel@rousalka.dyndns.org>
	 <20070511090823.GA29273@skynet.ie>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iSS1avLJLEBtnoji0oiw"
Organization: Adresse perso
Date: Fri, 11 May 2007 13:51:23 +0200
Message-Id: <1178884283.27195.1.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 (2.10.1-4.fc7.nim.2) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iSS1avLJLEBtnoji0oiw
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Le vendredi 11 mai 2007 =C3=A0 10:08 +0100, Mel Gorman a =C3=A9crit :

> > seems to have cured the system so far (need to charge it a bit longer t=
o
> > be sure)
> >=20
>=20
> The longer it runs the better, particularly under load and after
> updatedb has run. Thanks a lot for testing

After a few hours of load testing still nothing in the logs, so the
revert was probably the right thing to do

--=20
Nicolas Mailhot

--=-iSS1avLJLEBtnoji0oiw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZEWLYACgkQI2bVKDsp8g1nawCgsLzbk5Wc4/0Gfey+//uNHEPA
kCoAn0HmY/aR2wKW5wizivptFnvVQfmY
=Hm2+
-----END PGP SIGNATURE-----

--=-iSS1avLJLEBtnoji0oiw--
