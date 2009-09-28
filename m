Return-Path: <linux-kernel-owner+w=401wt.eu-S1752837AbZI1Lbe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837AbZI1Lbe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 07:31:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752645AbZI1Lbd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 07:31:33 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:49802 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752672AbZI1Lbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 07:31:32 -0400
Date: Mon, 28 Sep 2009 13:31:12 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: pm list <linux-pm@lists.linux-foundation.org>,
       Linux PCI <linux-pci@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
       LKML <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
       Florian <fs-kernelbugzilla@spline.de>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] PM / PCMCIA: Drop second argument of
	pcmcia_socket_dev_suspend()
Message-ID: <20090928113112.GA5602@pengutronix.de>
References: <200909260122.59030.rjw@sisk.pl> <200909260125.11149.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="opJtzjQTFsWo+cga"
Content-Disposition: inline
In-Reply-To: <200909260125.11149.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--opJtzjQTFsWo+cga
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 26, 2009 at 01:25:11AM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> pcmcia_socket_dev_suspend() doesn't use its second argument, so it
> may be dropped safely.
>=20
> This change is necessary for the subsequent yenta suspend/resume fix.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pcmcia/at91_cf.c        |    2 +-
>  drivers/pcmcia/au1000_generic.c |    2 +-
>  drivers/pcmcia/bfin_cf_pcmcia.c |    2 +-
>  drivers/pcmcia/cs.c             |    2 +-
>  drivers/pcmcia/i82092.c         |    2 +-
>  drivers/pcmcia/i82365.c         |    2 +-
>  drivers/pcmcia/m32r_cfc.c       |    2 +-
>  drivers/pcmcia/m32r_pcc.c       |    2 +-
>  drivers/pcmcia/m8xx_pcmcia.c    |    2 +-
>  drivers/pcmcia/omap_cf.c        |    2 +-
>  drivers/pcmcia/pd6729.c         |    2 +-
>  drivers/pcmcia/pxa2xx_base.c    |    2 +-
>  drivers/pcmcia/sa1100_generic.c |    2 +-
>  drivers/pcmcia/sa1111_generic.c |    2 +-
>  drivers/pcmcia/tcic.c           |    2 +-
>  drivers/pcmcia/vrc4171_card.c   |    2 +-
>  include/pcmcia/ss.h             |    2 +-

Hmm, you are not converting yenta_socket here. Won't that break building the
kernel (git bisect)?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--opJtzjQTFsWo+cga
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkrAnoAACgkQD27XaX1/VRtxegCgmbKC0z7ceG7isafnG6XN5F2q
moYAn2GulkLz/d2S2rD8Z67rVqjUMYPj
=A7hI
-----END PGP SIGNATURE-----

--opJtzjQTFsWo+cga--
