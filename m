Return-Path: <linux-kernel-owner+w=401wt.eu-S1753810AbZAEUoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753810AbZAEUoU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 15:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753708AbZAEUnu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 15:43:50 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:40862 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753384AbZAEUns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 15:43:48 -0500
Date: Mon, 5 Jan 2009 21:43:45 +0100
From: Luotao Fu <l.fu@pengutronix.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Luotao Fu <l.fu@pengutronix.de>, video4linux-list@redhat.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] remove duplicated defines in pxa_camera.c
Message-ID: <20090105204345.GA7248@pengutronix.de>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	Luotao Fu <l.fu@pengutronix.de>, video4linux-list@redhat.com,
	linux-kernel@vger.kernel.org
References: <1231175487-3293-1-git-send-email-l.fu@pengutronix.de> <Pine.LNX.4.64.0901052125480.8605@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="zhXaljGHf11kAtnf"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0901052125480.8605@axis700.grange>
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
X-Uptime: 21:39:13 up 23 days,  1:01,  7 users,  load average: 0.02, 0.17,
	0.09
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:219:66ff:fe5b:d0e3
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--zhXaljGHf11kAtnf
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 05, 2009 at 09:27:35PM +0100, Guennadi Liakhovetski wrote:
> On Mon, 5 Jan 2009, Luotao Fu wrote:
>=20
> > Defines for CIR Registers have been moved to pxa_camera.h. So remove th=
em from
> > pxa_camera.c to avoid compiler warnings.
> >=20
> > Signed-off-by: Luotao Fu <l.fu@pengutronix.de>
> > ---
> >  drivers/media/video/pxa_camera.c |   13 -------------
> >  1 files changed, 0 insertions(+), 13 deletions(-)
> >=20
> > diff --git a/drivers/media/video/pxa_camera.c b/drivers/media/video/pxa=
_camera.c
> > index cb8c5e1..4eda750 100644
> > --- a/drivers/media/video/pxa_camera.c
> > +++ b/drivers/media/video/pxa_camera.c
> > @@ -44,19 +44,6 @@
> >  #define PXA_CAM_VERSION_CODE KERNEL_VERSION(0, 0, 5)
> >  #define PXA_CAM_DRV_NAME "pxa27x-camera"
> > =20
> > -/* Camera Interface */
> > -#define CICR0		0x0000
> > -#define CICR1		0x0004
> > -#define CICR2		0x0008
> > -#define CICR3		0x000C
> > -#define CICR4		0x0010
> > -#define CISR		0x0014
> > -#define CIFR		0x0018
> > -#define CITOR		0x001C
> > -#define CIBR0		0x0028
> > -#define CIBR1		0x0030
> > -#define CIBR2		0x0038
> > -
> >  #define CICR0_DMAEN	(1 << 31)	/* DMA request enable */
> >  #define CICR0_PAR_EN	(1 << 30)	/* Parity enable */
> >  #define CICR0_SL_CAP_EN	(1 << 29)	/* Capture enable for slave mode */
> > --=20
> > 1.5.6.5
>=20
> NAK. Please, see an earlier patch from Eric Miao, a correct fix for this=
=20
> is in the queue.

Ah ok. I checked the mainline git tree and video4linux tree as well as did =
some
search in a/lkml before I made this patch. I was indeed wondering why such
obvious thing stays unfixed. I'll take a look for the patch by Eric Miao th=
en.

Thanks for the information

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--zhXaljGHf11kAtnf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFJYnEBiruQY+UyUmERAghYAJ9pME4l3DC99FnbJmC/FCZxjgP8/gCgkvdT
v75UuwIMyNk/nuGVRErVp5Q=
=JW+g
-----END PGP SIGNATURE-----

--zhXaljGHf11kAtnf--
