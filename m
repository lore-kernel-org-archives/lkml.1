Return-Path: <linux-kernel-owner+w=401wt.eu-S1762808AbXGFFZc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762808AbXGFFZc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 01:25:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755390AbXGFFZX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 01:25:23 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:33199 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756719AbXGFFZW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 01:25:22 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH] Remove process freezer from suspend to RAM pathway
Date: Fri, 6 Jul 2007 15:25:16 +1000
User-Agent: KMail/1.9.6
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
       linux-pm@lists.linux-foundation.org,
       Alan Stern <stern@rowland.harvard.edu>
References: <20070703042916.GA17240@srcf.ucam.org> <200707061403.15932.nigel@nigel.suspend2.net> <1183696901.3388.119.camel@localhost.localdomain>
In-Reply-To: <1183696901.3388.119.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2227406.DxAaQg50xy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061525.18412.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2227406.DxAaQg50xy
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 14:41:40 Benjamin Herrenschmidt wrote:
>=20
> > I/O from swsusp and suspend2 use bios directly, so the page cache isn't=
 an=20
> > issue for them (apart from the fact that Suspend2 saves the page cache=
=20
> > separately so it can get a full image). Not sure about uswsusp.
> >=20
> > Only having half the amount of memory doesn't sound like a big limitati=
on=20
for=20
> > modern desktops & laptops, but don't forget that there are embedded guy=
s=20
> > wanting to hbernate too :)
>=20
> Wait wait wait ... uses the BIOS ? what do you mean ?

You misread me, Ben. Sorry for not being clearer. bios as in struct bio.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2227406.DxAaQg50xy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjdI+N0y+n1M3mo0RAn+XAKDjmtdqcIfth3ZlY3b3I7ymJJ7SYACgtTQI
m4wU5zhG5dUsnc9DVnm+n3A=
=TxDF
-----END PGP SIGNATURE-----

--nextPart2227406.DxAaQg50xy--
