Return-Path: <linux-kernel-owner+w=401wt.eu-S1756078AbZINQZF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078AbZINQZF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Sep 2009 12:25:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756043AbZINQZB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Sep 2009 12:25:01 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56221 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016AbZINQZA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Sep 2009 12:25:00 -0400
Date: Mon, 14 Sep 2009 18:24:57 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Marek Vasut <marek.vasut@gmail.com>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm: remove unused code in delay.S
Message-ID: <20090914162457.GE3164@pengutronix.de>
References: <20090913230008.GC30169@n2100.arm.linux.org.uk> <20090914002100.GD30621@shareable.org> <20090914081001.GB14519@n2100.arm.linux.org.uk> <94a0d4530909140558nd8d2c47lc9954563c80a574f@mail.gmail.com> <20090914140059.GC21580@n2100.arm.linux.org.uk> <94a0d4530909140738t7e4d646r134cfd884da21348@mail.gmail.com> <20090914144028.GG21580@n2100.arm.linux.org.uk> <94a0d4530909140814w36f7f5f0td2c25db07fbd4e57@mail.gmail.com> <20090914153616.GD3164@pengutronix.de> <94a0d4530909140906v72865664w3976766e57bf2aa3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4Epv4kl9IRBfg3rk"
Content-Disposition: inline
In-Reply-To: <94a0d4530909140906v72865664w3976766e57bf2aa3@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4Epv4kl9IRBfg3rk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> The minority that would make use of this code is theoretical, and
> these users by definition know they need this code, therefore, if the
> code is not there, they'll notice,

I'm not sure everyone knows in advance what is going on. I imagine the case
where something is inadeqaute, one starts looking at the code and _after_
reading the #if 0-block, understands the problem and realizes that the bloc=
k is
needed in this rare case. So, it's like some kind of documentation. This is=
 why
I'd still favour the comment; if there is a chance for such a patch, I'd ma=
ke
it BTW.

> If it turns out nobody complains about removing this code you would
> have made the linux kernel 16 lines cleaner for free.

I'd think we lose a bit of information. (Yeah, it is in the history, but ha=
rder
to find there.)

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--4Epv4kl9IRBfg3rk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqublkACgkQD27XaX1/VRsRCQCgujuQ5nun7vKY8/+8LC078mDc
k58Anij6Tq1h0CAdoFVGB+AVOkr8XdMn
=OsQm
-----END PGP SIGNATURE-----

--4Epv4kl9IRBfg3rk--
