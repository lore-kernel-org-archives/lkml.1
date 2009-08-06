Return-Path: <linux-kernel-owner+w=401wt.eu-S1756280AbZHFVCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280AbZHFVCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Aug 2009 17:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756239AbZHFVCc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Aug 2009 17:02:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:56361 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753617AbZHFVCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Aug 2009 17:02:32 -0400
Date: Thu, 6 Aug 2009 23:02:31 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Oliver Hartkopp <oliver@hartkopp.net>, Luotao Fu <l.fu@pengutronix.de>,
       socketcan-users@lists.berlios.de,
       Michael Olbrich <m.olbrich@pengutronix.de>,
       linux-kernel@vger.kernel.org
Subject: Re: [Socketcan-users] [PATCH] CAN: make checking in can_rcv less
	restrictive
Message-ID: <20090806210230.GA22418@pengutronix.de>
Mail-Followup-To: Oliver Hartkopp <oliver@hartkopp.net>,
	Luotao Fu <l.fu@pengutronix.de>, socketcan-users@lists.berlios.de,
	Michael Olbrich <m.olbrich@pengutronix.de>,
	linux-kernel@vger.kernel.org
References: <1249572295-7801-1-git-send-email-l.fu@pengutronix.de> <4A7B0957.5020808@hartkopp.net> <20090806201740.GA7067@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PNTmBPCT7hxwcZjr"
Content-Disposition: inline
In-Reply-To: <20090806201740.GA7067@pengutronix.de>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Peiner Strasse
	6-8, 31137 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-5555 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 22:59:03 up 1 day,  8:18,  7 users,  load average: 1.54, 1.27,
	1.12
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PNTmBPCT7hxwcZjr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Oliver (again ;-)),

On Thu, Aug 06, 2009 at 10:17:40PM +0200, Luotao Fu wrote:
> Hi Oliver,
>=20
> On Thu, Aug 06, 2009 at 06:48:23PM +0200, Oliver Hartkopp wrote:
> >=20
=2E...
> > When this BUG() triggers, someone provided a definitely broken *CAN* ne=
twork
> > driver, and this needsfp to be fixed on that level.=20
>=20
> In our case a sender (a FPGA) generates correct can frames carrying
> wrong dlc length. This way the can driver on our side runs into the bug
> though the driver itself is allright. The opposite needed to be fixed,
> not our side.  Though we do suffer a system crash only because the
> sender sends trash into the can network. This is imo quite bad.
>=20

/me answering myself
had a closer look again. Seemed you are right. The can driver should
have get the can_dlc right prior to passing the message a level higher.

cheers
Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--PNTmBPCT7hxwcZjr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkp7ROYACgkQiruQY+UyUmHH8wCfVviSkMf0L71g0IKQaolp9Ecy
mBgAoKDKoGAeCuyA8F3lK6Iv6xWBdZeX
=bzSr
-----END PGP SIGNATURE-----

--PNTmBPCT7hxwcZjr--
