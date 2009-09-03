Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbZICT5y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbZICT5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 15:57:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756268AbZICT5x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 15:57:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44727 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756265AbZICT5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 15:57:52 -0400
Date: Thu, 3 Sep 2009 21:57:53 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Frans Pop <elendil@planet.nl>,
       Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>,
       linux-kernel@vger.kernel.org, linux-pcmcia@lists.infradead.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090903195753.GC11097@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909021953.02190.elendil@planet.nl> <200909030042.45081.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090903193709.GA11097@pengutronix.de> <alpine.LFD.2.00.0909031539070.3200@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="5G06lTa6Jq83wMTw"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.0909031539070.3200@localhost>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--5G06lTa6Jq83wMTw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

>   the pcmcia ioctl has been listed as removable since 2005:
>=20
> http://lkml.org/lkml/2007/5/1/124
>=20
> and is still listed that way in Doc/feature-removal-schedule.txt, you
> can't say i didn't try.

I read the thread in which you tried. I will have my try, too. This time, I
want to convert the existing users first and then throw the interface away.=
 To
me, it looks like there is only one prominent user left, Debian's discover.
Even though the PCMCIA-information it collects is hardly useful, I converted
it:

http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D382425

Still working on getting any response from the maintainers :)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--5G06lTa6Jq83wMTw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqgH8EACgkQD27XaX1/VRs8bgCfcRxoy2pdEW5wk3bxXwCU4MKn
eVIAn0BXws6IpqH9PHMNPgydDJ3NH6wc
=WcGM
-----END PGP SIGNATURE-----

--5G06lTa6Jq83wMTw--
