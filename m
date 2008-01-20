Return-Path: <linux-kernel-owner+w=401wt.eu-S1757216AbYATUQh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757216AbYATUQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 15:16:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756795AbYATUQ1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 15:16:27 -0500
Received: from mail.gmx.net ([213.165.64.20]:46666 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755846AbYATUQ0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 15:16:26 -0500
X-Authenticated: #815327
X-Provags-ID: V01U2FsdGVkX1+GkPAt13SGvPx/PIkWvAI45pWTJlTUIcxaIvcGjo
	eyc+2OrUvhFitC
Date: Sun, 20 Jan 2008 21:16:19 +0100
From: Malte =?UTF-8?B?U2NocsO2ZGVy?= <maltesch@gmx.de>
To: Andi Kleen <ak@suse.de>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.24 regression: reference count leak in PPPoE
Message-ID: <20080120211619.11535a95@highlander.home.lan>
In-Reply-To: <200801202053.30386.ak@suse.de>
References: <200801202053.30386.ak@suse.de>
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/g6_XeXJ.s1ma5V6oZSrcPja";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/g6_XeXJ.s1ma5V6oZSrcPja
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, 20 Jan 2008 20:53:30 +0100
Andi Kleen <ak@suse.de> wrote:

>=20
> My workstation running 2.6.24-rc8 just hung during shutdown with an endle=
ss=20
> (or rather I didn't wait more than a few minutes) loop of=20
>=20
> unregister_netdev: waiting for ppp-device to become free. Usage count =3D=
 1
>=20
> ppp-device was an active PPPoE device.
>=20
> No more information currently.

Now that you mention it, this happened to me too this morning. My
system stops the ppp interface (pppoe) and starts it again (my provider
shuts down the link every 24 hours, I want that to happen during the
night, so I do a ifdown ppp0).




--=20
---------------------------------------
Malte Schr=C3=B6der
MalteSch@gmx.de
ICQ# 68121508
---------------------------------------


--Sig_/g6_XeXJ.s1ma5V6oZSrcPja
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHk6wW4q3E2oMjYtURAibFAJ9nbk8VJfK626vw3LuH/J3SxiBqGACgqkDt
XC9CmrOpuhZhSwRlobcfs+U=
=Ngof
-----END PGP SIGNATURE-----

--Sig_/g6_XeXJ.s1ma5V6oZSrcPja--
