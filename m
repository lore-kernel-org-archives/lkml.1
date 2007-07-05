Return-Path: <linux-kernel-owner+w=401wt.eu-S1760457AbXGELEh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760457AbXGELEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 07:04:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758849AbXGELEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 07:04:30 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:36146 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795AbXGELEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 07:04:30 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: Failure to properly reinit i8042 post suspend-to-ram
Date: Thu, 5 Jul 2007 21:04:27 +1000
User-Agent: KMail/1.9.6
Cc: LKML <linux-kernel@vger.kernel.org>, dmitry.torokhov@gmail.com
References: <200706221607.33274.nigel@nigel.suspend2.net> <20070705101514.GD3984@ucw.cz>
In-Reply-To: <20070705101514.GD3984@ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2291833.J6fq0YDQxD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707052104.27693.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2291833.J6fq0YDQxD
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Thursday 05 July 2007 20:15:14 Pavel Machek wrote:
> Hi!
>=20
> > I have recently begun to try and use suspend to ram more, and have an=20
> > intermittent problem. Actually, it's a couple of (possibly related)=20
problems,=20
> > but I'll start with the one that's easiest.
> >=20
> > Sometimes, when I resume, the keyboard stops responding. I then need to=
=20
hold=20
> > down the power button for 4 seconds. At the next boot, things are still=
=20
not=20
> > right. The i8042 controller seems to be confused about it's mode, becau=
se=20
I=20
> > get the following differences in dmesg to a 'normal' boot:
>=20
> If confusion persist after 4 seconds hard power down... then you h ve
> hw/BIOS problem. Complain to whoever is manufacturing that beast.

Adding i8042.reset=3D1 to the commandline fixed it.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2291833.J6fq0YDQxD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjNA7N0y+n1M3mo0RAlxZAJ9QFf4tzqPqLcn9gLRO2DME3EDqEQCeJB1s
XQRS8OyAVkQE9h8qsV1lF48=
=hpZf
-----END PGP SIGNATURE-----

--nextPart2291833.J6fq0YDQxD--
