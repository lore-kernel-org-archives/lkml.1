Return-Path: <linux-kernel-owner+w=401wt.eu-S1757092AbYLPM14@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757092AbYLPM14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2008 07:27:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755622AbYLPM1f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Dec 2008 07:27:35 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58693 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755510AbYLPM1e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2008 07:27:34 -0500
Date: Tue, 16 Dec 2008 13:27:32 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: hjk@linutronix.de, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: adding of_platform_drivers (was: Re: [RESEND][PATCH] uio: Add
	of_platform_driver to uio_pdrv_genirq)
Message-ID: <20081216122731.GC3275@pengutronix.de>
References: <1229007937-5501-1-git-send-email-w.sang@pengutronix.de> <20081211205033.GA7080@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9Ek0hoCL9XbhcSqy"
Content-Disposition: inline
In-Reply-To: <20081211205033.GA7080@suse.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9Ek0hoCL9XbhcSqy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> > +/* -------------------------------------------------------------------=
--
> > + * OF bus binding
> > + */
> > +
> > +#if defined(CONFIG_OF)
>=20
> Same goes here, don't put #if in .c files please.

So, generally speaking, this means that I should not put a
platform_driver and an of_platform_driver into one source file, but
rather create an of_$DRIVER.c then? I found both ways used in the kernel
and could not find hints about the preferred way to do it. I took this
approach as I hoped it would save some code to directly convert the
of_node to uioinfo without the detour of using a platform_device
inbetween.

Kind regards,

   Wolfram

--=20
  Dipl.-Ing. Wolfram Sang | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry

--9Ek0hoCL9XbhcSqy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklHnrMACgkQD27XaX1/VRtqVgCeNRTrMgtmVHBqkfx84ili+hS7
6IQAnRgwJOng1yxbQ13jzEQPHJvfyRM2
=OZHf
-----END PGP SIGNATURE-----

--9Ek0hoCL9XbhcSqy--
