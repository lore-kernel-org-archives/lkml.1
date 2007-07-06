Return-Path: <linux-kernel-owner+w=401wt.eu-S1761016AbXGFJQf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761016AbXGFJQf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:16:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762923AbXGFJQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:16:20 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52306 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762895AbXGFJQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:16:19 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 19:16:16 +1000
User-Agent: KMail/1.9.6
Cc: oliver@neukum.org, rjw@sisk.pl, nigel@suspend2.net, pavel@ucw.cz,
       benh@kernel.crashing.org, mjg59@srcf.ucam.org,
       linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org
References: <20070703042916.GA17240@srcf.ucam.org> <200707060951.47555.oliver@neukum.org> <E1I6jot-0003U1-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6jot-0003U1-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart8580040.uTIAtyy5Kl";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061916.17590.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart8580040.uTIAtyy5Kl
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 19:09:43 Miklos Szeredi wrote:
> > > > Moreover, if FUSE implements syncing, then the sync from within the=
=20
freezer
> > > > will almost certainly deadlock.
> > >=20
> > > Rafael, think positively: by the time fuse implements sync(), the
> > > freezer will be long gone ;)
> >=20
> > Now you are entering really dangerous territory.
> > If you can implement a meaningfull sync method, you must have dirty
> > pages in the page cache. That means you are in the page freeing path
> > of the vm. Then we are in real trouble. Don't even think about it.
>=20
> VM induced deadlocks are real nasty.  I have thought about them a lot
> already.  Suspend shouldn't introduce any big surprises.

Suspend isn't introducing the surprises. Fuse is. It creates the potential=
=20
deadlocks simply by existing (this isn't suspend or hibernate specific).

Nigel

--nextPart8580040.uTIAtyy5Kl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjghhN0y+n1M3mo0RAqueAJ9O6KMD1i4aV8jCQlPzl/DH0awBZwCg0KFs
ByEuy78qc8ls5c0jPjFkEgA=
=NZlk
-----END PGP SIGNATURE-----

--nextPart8580040.uTIAtyy5Kl--
