Return-Path: <linux-kernel-owner+w=401wt.eu-S1761793AbXGJA75@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761793AbXGJA75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 20:59:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761585AbXGJA7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 20:59:46 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:52995 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761665AbXGJA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 20:59:45 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: Stefan Seyfried <seife@suse.de>
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Date: Tue, 10 Jul 2007 10:59:57 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, Pavel Machek <pavel@ucw.cz>,
       LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
References: <200706221607.33274.nigel@nigel.suspend2.net> <200707052104.27693.nigel@nigel.suspend2.net> <20070706150451.GA11400@suse.de>
In-Reply-To: <20070706150451.GA11400@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3668132.ho7CGPPmNP";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707101059.57881.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3668132.ho7CGPPmNP
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 07 July 2007 01:04:51 Stefan Seyfried wrote:
> On Thu, Jul 05, 2007 at 09:04:27PM +1000, Nigel Cunningham wrote:
> > >=20
> > > If confusion persist after 4 seconds hard power down... then you h ve
> > > hw/BIOS problem. Complain to whoever is manufacturing that beast.
> >=20
> > Adding i8042.reset=3D1 to the commandline fixed it.
>=20
> Wasn't there a quirk list where workarounds for i8042 on known bad machin=
es
> are stored? Maybe it would be a good idea to get your machine into it ;-)

Unless I'm missing something, it looks like there's no such thing in the i8=
042=20
driver. That's okay. I can cope with adding i8042.reset=3D1 to my=20
commandline :)

Nigel
=2D-=20
Nigel Cunningham
Christian Reformed Church of Cobden
103 Curdie Street, Cobden 3266, Victoria, Australia
Ph. +61 3 5595 1185 / +61 417 100 574
Communal Worship: 11 am Sunday.

--nextPart3668132.ho7CGPPmNP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGktoNN0y+n1M3mo0RAsZVAKDtvNLxWgMzfY0a41/hHJomX6KpxQCg1Z5m
3zJsjEts9aBPKVyVLc+2HZE=
=EeTK
-----END PGP SIGNATURE-----

--nextPart3668132.ho7CGPPmNP--
