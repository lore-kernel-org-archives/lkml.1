Return-Path: <linux-kernel-owner+w=401wt.eu-S1753146AbZDGJEa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146AbZDGJEa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 05:04:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbZDGJEA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 05:04:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:48341 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753042AbZDGJD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 05:03:57 -0400
Date: Tue, 7 Apr 2009 11:03:53 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Cc: Luotao Fu <l.fu@pengutronix.de>, gregkh@suse.de, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: serial: add FTDI FT4232H ID
Message-ID: <20090407090353.GA12669@pengutronix.de>
Mail-Followup-To: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>,
	Luotao Fu <l.fu@pengutronix.de>, gregkh@suse.de,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1239090573-11527-1-git-send-email-l.fu@pengutronix.de> <18907.3900.117808.251116@elektron.ikp.physik.tu-darmstadt.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <18907.3900.117808.251116@elektron.ikp.physik.tu-darmstadt.de>
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
X-Uptime: 10:53:14 up 5 days,  1:58,  1 user,  load average: 0.02, 0.07,
	0.16
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 07, 2009 at 10:30:52AM +0200, Uwe Bonnes wrote:
> >>>>> "Luotao" =3D=3D Luotao Fu <l.fu@pengutronix.de> writes:
>=20
>     Luotao> add the ID of FT4232H Hi-Speed quad channel serial converter.
>=20
> This probably isn't enough to make the devices work.
>=20
> The FT2232H and FT4432H are High Speed devices with defaul buffer sizes of
> 512 bytes. A recieve buffer contains two status bytes and then up to 510
> bytes of data against 62 bytes on the old devices.

Shame on me. I did only check whether the device with its four channels are
registered. Since the chip is built-in on our board and I still need some
additional libraries to check the devices connected to it. I haven't done a=
ny
function tests still. Will keep an eye on this. Sounds that it could be a l=
ittle
hairy then. Afais the PID 6001 is e.g. shared by common/high speed devices.=
 I
didn't grab deeper in the ftdi code, probably it'll be some way to work aro=
und
this.

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAknbFvkACgkQiruQY+UyUmG2YACfWbEdmZVKE2KXRt6/q2Cy3WEb
Vn4Ani8kQETKVJ2+0EDFtj83iugGlZdJ
=jL77
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
