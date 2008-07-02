Return-Path: <linux-kernel-owner+w=401wt.eu-S1758776AbYGBW5x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758776AbYGBW5x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 18:57:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752195AbYGBW5o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 18:57:44 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:48601 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057AbYGBW5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 18:57:43 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Giacomo Mulas <gmulas@ca.astro.it>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200807022340.31894.rjw@sisk.pl>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-1vAczl1SQ2K3ISLGpcqp"
Date: Thu, 03 Jul 2008 00:56:59 +0200
Message-Id: <1215039419.13270.18.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-1vAczl1SQ2K3ISLGpcqp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2008-07-02 at 23:40 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 2 of July 2008, Giacomo Mulas wrote:
> > I tried searching on the list for this, before posting, but searching t=
he
> > mailing list archives with keywords such as b43, suspend, resume... bri=
ngs
> > up such a ludicrous amount of threads that it's not realistic to check =
them
> > all, so just tell me what to look for if it's been asked already.
> >=20
> > Whenever I do a suspend to disk after using b43, the computer freezes h=
ard
> > as soon as it attempts again to access b43 after resume.
> >=20
> > Minimal how to reproduce the freeze:
> > 1) modprobe b43
> > 2) hibernate (using any suspend to disk, which one is irrelevant)
> > 3) resume
> > 4) ifconfig wlan0 up

> I think you need the appended patch, but it only applies to linux-next.

Rafael, you misled me :) This is a completely different thing.

johannes

--=-1vAczl1SQ2K3ISLGpcqp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbAe3AAoJEKVg1VMiehFYNmIP/3bgzcpcY0nWfzV2oWT5fFCO
yJXahwR46SB3zlzwUbEJf5/Mg7vnApolX4Mc/ohBNVX99GeE56CRvD80BsSF5RLg
MyqBxe81usVXFZDHaUNM/DGQamACetPjDLYxgSUhFSLsgfhclEKGfGNwtV2VbOpA
NSSKnJeb3mlFqlldLdKBsmit0+POKrkgNWANqnQgiIDQX8i/Ze2IMrNpwfPTquNS
A3geEPXFvtSl18140ATudYlcOWavzCBt6o5wYuIiUcw3pyW2nRiBH81o/XS4pAar
z2rdYjHtFL+FfoWXRiAiE/KD5OT/o2aGimo936Upmus9EBoYpgKAO66mOhnsXvep
/3dFlvKDDNgSUSsyMEUyQrGJN7B9CmPtKsIUT9Akl+qLbG1ggNmHLTwpMhyEt8me
/9I8BT0eUaPODNcAW9cCKKhpkcIWkvaBT6DbevK86vK99HJfjeglCtlIYQv6z0My
QkQ/e7emfynuFdFzVOZU/xYXTTdPSY9A26HfmvPtBx6Sx2pLouknrwYiIa0LKHu9
tPeCi4nPXTHy2ziklhkELp7i42qn3H8ZQSlSElRz7vBqDoah/BVGW9P1WL4+slBN
yYhrrgjHVhjtBHiNsRybX7+07aexGoWBDQzuY1jM+g14+1Tewd1nNZld/xTmtgQo
h3mstRIBOQOy+HRlgIQY
=tF8e
-----END PGP SIGNATURE-----

--=-1vAczl1SQ2K3ISLGpcqp--

