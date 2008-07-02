Return-Path: <linux-kernel-owner+w=401wt.eu-S1754914AbYGBXIh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754914AbYGBXIh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 19:08:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751862AbYGBXI3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 19:08:29 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:60135 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751712AbYGBXI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 19:08:29 -0400
Subject: Re: b43 locks the machine when resuming after suspend to disk
From: Johannes Berg <johannes@sipsolutions.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Giacomo Mulas <gmulas@ca.astro.it>, linux-kernel@vger.kernel.org,
       debian-kernel@lists.debian.org,
       Broadcom Linux <bcm43xx-dev@lists.berlios.de>
In-Reply-To: <200807030108.37614.rjw@sisk.pl>
References: <alpine.DEB.1.10.0807021830300.32045@capitanata.ca.astro.it>
	 <200807022340.31894.rjw@sisk.pl> <1215039419.13270.18.camel@johannes.berg>
	 <200807030108.37614.rjw@sisk.pl>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-dObWBpH6n9i7e+NpUyUp"
Date: Thu, 03 Jul 2008 01:07:44 +0200
Message-Id: <1215040064.13270.20.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-dObWBpH6n9i7e+NpUyUp
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-07-03 at 01:08 +0200, Rafael J. Wysocki wrote:
> On Thursday, 3 of July 2008, Johannes Berg wrote:
> > On Wed, 2008-07-02 at 23:40 +0200, Rafael J. Wysocki wrote:
> > > On Wednesday, 2 of July 2008, Giacomo Mulas wrote:
> > > > I tried searching on the list for this, before posting, but searchi=
ng the
> > > > mailing list archives with keywords such as b43, suspend, resume...=
 brings
> > > > up such a ludicrous amount of threads that it's not realistic to ch=
eck them
> > > > all, so just tell me what to look for if it's been asked already.
> > > >=20
> > > > Whenever I do a suspend to disk after using b43, the computer freez=
es hard
> > > > as soon as it attempts again to access b43 after resume.
> > > >=20
> > > > Minimal how to reproduce the freeze:
> > > > 1) modprobe b43
> > > > 2) hibernate (using any suspend to disk, which one is irrelevant)
> > > > 3) resume
> > > > 4) ifconfig wlan0 up
> >=20
> > > I think you need the appended patch, but it only applies to linux-nex=
t.
> >=20
> > Rafael, you misled me :) This is a completely different thing.
>=20
> Ah, sorry then.  I was too quick with my response.

No trouble, it reminded me that I wanted to ask stable to pick up that
patch anyway although I don't think we ever ran into the issue there.

This seems very odd though, Giacomo, are you sure it also happens if you
unload the module?

johannes

--=-dObWBpH6n9i7e+NpUyUp
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIbAo8AAoJEKVg1VMiehFYjtoQAMA0MLshpAe0MlM38+Cc+kWl
tvI2uSnmyFv1Lk2Y9UmMg0PrA6EzEbTdAhwLdh4ZMK+Y1AvZ6oW40dR/XAl891B5
RjpSd4lsTU+Gi+1GzBGDgAapmRloWkDckxYnwKJIeFPBcUT5CkKwcTbqVcjjsY95
PoT2R8JUGDmQ4YDgsgqmuJ6xL2uHCpvkkvo+ANTEnkvxJDxfK0l25S7TPBM9N9rl
l43k9vM08ClcVQsAYLgroa9zJ3M6eUmgXrOVO0UW6P7IBA0lHj/dT0Vl4/cGSOGH
E59+YzdhfkHlNLrACFHUbssqSwTjyJuQQdZnnL9voT7eP3LP1hoYSxgyZsMumEpq
+wiDIL7BCpai/YCLNx7SSjMNZNrH8yNLrTSwLOAefIb4+cBsHpQ5Qaz78n2AjzCP
n7LL/mP+2SE4cIM/e/hCG1SAmfoNBb/RsN9WPyMgBc+YnBz32mSe5HlI2JgWSxIQ
8780OqsTJsmu8wEtEVNDWrsohVIADm5nusjXIqJDLREqLLm7bRMK0FXkJXQiBMoQ
a6vjDKRRz+0l9mIU1wFukMOHNDVfOdoGxxykuMh+ToMMq779AfXortc8f0DPUHBb
M4yFVkcufqfnDjS2GFT0aH3Ld9GuUptcZ+aQtnkHIKF7VWGIqV/it7ySw5Okqeoy
YIviCNNTCUyX2OY2YlxG
=DHoo
-----END PGP SIGNATURE-----

--=-dObWBpH6n9i7e+NpUyUp--

