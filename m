Return-Path: <linux-kernel-owner+w=401wt.eu-S1753479AbYAIKw0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753479AbYAIKw0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2008 05:52:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751211AbYAIKwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jan 2008 05:52:19 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:59790 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751244AbYAIKwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2008 05:52:18 -0500
Message-ID: <4784A74B.3040807@pengutronix.de>
Date: Wed, 09 Jan 2008 11:51:55 +0100
From: Marc Kleine-Budde <mkl@pengutronix.de>
Organization: pengutronix
User-Agent: Icedove 1.5.0.14pre (X11/20071025)
MIME-Version: 1.0
To: tom@kavaga.com
CC: linux-kernel@vger.kernel.org
References: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
In-Reply-To: <39848.76.189.45.79.1199874932.squirrel@webmail.kavaga.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig09756C70B49147169E2D3E40"
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: mkl@pengutronix.de
Subject: Re: Possible 2.6.24-rc7 issue w/respect to pthreads
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig09756C70B49147169E2D3E40
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

tom@kavaga.com wrote:
> To Whom It May Concern,
>=20
> After I patched my 2.6.23 kernel to 2.6.24-rc7 this morning, I noticed
> some odd behavior with respect to POSIX threads in a test program I had=

> written (originally to test epoll.)
>=20
> The behavior is as follows:
>=20
> 1.  main() creates a new thread of execution with pthread_create
> 2.  thread_func() immediately calls pthread_detach(), which is supposed=
 to
> ensure that thread resources are cleaned up when the thread terminates.=

> 3.  The spawned thread sleeps and then prints a message "got here"
> 4.  The main thread calls pthread_join().  According to the POSIX
> documentation, this should suspend execution until the spawned thread h=
as
> terminated.

Quoting the man page of pthread_detach():

After pthread_detach completes, subsequent attempts to perform
pthread_join on th will fail.

regard - Marc
--=20
 Marc Kleine-Budde              Phone: +49-231-2826-924
 Pengutronix - Linux Solutions for Science and Industry
 Vertretung West/Dortmund     http://www.pengutronix.de


--------------enig09756C70B49147169E2D3E40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHhKdTjTAFq1RaXHMRAmd2AJ9wrJu+oFNpsV0YVa5ocfpcDWKxSgCdGkou
mMFzb5pygfxME1pu6XbmHa4=
=vZ32
-----END PGP SIGNATURE-----

--------------enig09756C70B49147169E2D3E40--
