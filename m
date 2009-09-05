Return-Path: <linux-kernel-owner+w=401wt.eu-S1752229AbZIEOaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752229AbZIEOaW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Sep 2009 10:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbZIEOaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Sep 2009 10:30:22 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36800 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751936AbZIEOaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Sep 2009 10:30:21 -0400
Date: Sat, 5 Sep 2009 16:30:22 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Christian =?iso-8859-15?Q?Kr=E4mer?= <christian@kraemer-eu.de>
Cc: linux-pcmcia@lists.infradead.org, Frans Pop <elendil@planet.nl>,
       Peter Stuge <peter@stuge.se>, linux-kernel@vger.kernel.org
Subject: Re: yenta_socket: PCMCIA-Cards are not recognised by kernel
Message-ID: <20090905143022.GD3171@pengutronix.de>
References: <200909021856.29565.christian@kraemer-eu.de> <200909031927.19590.elendil@planet.nl> <20090904043025.2774.qmail@stuge.se> <200909042239.17180.christian@kraemer-eu.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W5WqUoFLvi1M7tJE"
Content-Disposition: inline
In-Reply-To: <200909042239.17180.christian@kraemer-eu.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W5WqUoFLvi1M7tJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


(As a first note: The dmesg output suffers from linebreaks. Please make sure
your MUA doesn't split up the logs.)

> Even I installed gentoo with the 2.6.30.5 downloaded from kernel.org.

Good. The sysfs-errors went away, too.

> [    0.000000] IBM Thinkpad 600 Series 2645 detected: force use of acpi=
=3Dnoirq

Uh oh. Which BIOS version do you have?

[...]
> [    1.179419] ACPI: ACPI Dock Station Driver: 1 docks/bays found

Well, looks like you are using a docking station. Does it work without the
docking station? What is its name? There seem to be more problems with thos=
e,
for example:

http://bugzilla.kernel.org/show_bug.cgi?id=3D10805

> [    1.183173] * Found PM-Timer Bug on the chipset. Due to workarounds fo=
r a bug,
> [    1.183191] * this clock source is slow. Consider trying other clock s=
ources

Wow, there seem to be quite some issues with this laptop...

To make sure: Do regular PC Cards (non-CardBus) work with/without the docki=
ng
station? (I would assume that...)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--W5WqUoFLvi1M7tJE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqidf4ACgkQD27XaX1/VRur5gCfXWBvImvjeP7RdpeLkjV6ecix
D+UAn2kLa5456o93kmQmsyog3bcLIJ11
=MWnm
-----END PGP SIGNATURE-----

--W5WqUoFLvi1M7tJE--
