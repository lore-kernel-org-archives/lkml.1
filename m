Return-Path: <linux-kernel-owner+w=401wt.eu-S1752850AbYLCPTf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850AbYLCPTf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 10:19:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751246AbYLCPT0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 10:19:26 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40368 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751243AbYLCPTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 10:19:23 -0500
Date: Wed, 3 Dec 2008 16:19:20 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Luotao Fu <l.fu@pengutronix.de>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]  remove isa stuff from smc91x driver
Message-ID: <20081203151919.GD5559@pengutronix.de>
Mail-Followup-To: Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Luotao Fu <l.fu@pengutronix.de>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1228315701-17240-1-git-send-email-l.fu@pengutronix.de> <20081203145235.05e1f461@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="48TaNjbzBVislYPb"
Content-Disposition: inline
In-Reply-To: <20081203145235.05e1f461@lxorguk.ukuu.org.uk>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Entwicklungszentrum Nord - Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Impressum: Pengutronix - Linux Solutions for Science and Industry
	Handelsregister:  Amtsgericht Hildesheim, HRA 2686 Hannoversche
	Str. 2, 31134 Hildesheim, Germany Phone: +49-5121-206917-0 |  Fax:
	+49-5121-206917-9 Inhaber: Dipl.-Ing. Robert Schwebel
X-Message-Flag: See Message Headers for Impressum
X-Uptime: 16:15:42 up 1 day,  3:57,  1 user,  load average: 0.00, 0.01, 0.00
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d078
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--48TaNjbzBVislYPb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 03, 2008 at 02:52:35PM +0000, Alan Cox wrote:
> On Wed,  3 Dec 2008 15:48:21 +0100
> Luotao Fu <l.fu@pengutronix.de> wrote:
>=20
> > From: Luotao Fu <lfu@pengutronix.de>
> >=20
> > ISA support in smc91x is incomplete. I doubt there're any smc91x isa ca=
rd.
> > This driver is greatly used on arm pxa platforms. Hence we remove the
> > isa stuff from smc91x driver.
>=20
> This makes no sense. It is protected by an ifdef anyway so doesn't affect
> ARM

The isa part in smc91x does nothing at all. Get you a unused variable warni=
ng if
you turn ISA on and compile it. The io table is defined and not used at all.
Neither does the io address and irq by parameter. I think that these are wa=
ste
code and should be removed.

Cheers
Luotao Fu
--=20
   Dipl.-Ing. Luotao Fu | Phone: +49-5121-206917-5004
Pengutronix - Linux Solutions for Science and Industry
Entwicklungszentrum Nord     http://www.pengutronix.de


--48TaNjbzBVislYPb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJNqN3iruQY+UyUmERAt+ZAJ4tvdZxWreSNa5CT3QLOgVuec+7+gCeIGzq
TEVkR6eUO8HA5BgCIkeaBn4=
=Xt3q
-----END PGP SIGNATURE-----

--48TaNjbzBVislYPb--
