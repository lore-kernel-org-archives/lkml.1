Return-Path: <linux-kernel-owner+w=401wt.eu-S1751385AbXB1EDr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbXB1EDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Feb 2007 23:03:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751453AbXB1EDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Feb 2007 23:03:47 -0500
Received: from iucha.net ([209.98.146.184]:54122 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751385AbXB1EDr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Feb 2007 23:03:47 -0500
Date: Tue, 27 Feb 2007 22:03:46 -0600
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.21-rc1: CIFS cheers, NFS4 jeers
Message-ID: <20070228040345.GL29073@iucha.net>
References: <20070226064500.GZ29073@iucha.net> <45E4EAA7.2090007@tmr.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bnUi9GzdSM4S/DMA"
Content-Disposition: inline
In-Reply-To: <45E4EAA7.2090007@tmr.com>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--bnUi9GzdSM4S/DMA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 27, 2007 at 09:36:23PM -0500, Bill Davidsen wrote:
> Florin Iucha wrote:
> >Hello, it's me and my 70 GB of photos again.
> >
> >I have tested both CIFS and NFSv4 clients in kernel 2.6.20-rc1 . CIFS
> >passed with flying colors and NFSv4 stalled after 7 GB.

> Neil has been diddling NFS, I did some light testing with 2.6.20-git14=20
> with 190GB of mp3 and mpg files (library of congress folk music) without=
=20
> hangs. Just "did it work" tests, copy 20-30GB to server, do md5 on the=20
> data pulled back from the server.
>=20
> Didn't hang, performance testing later.

2.6.20-rcX used to copy all files then hang on certain operations that
I think used the VFS.  2.6.21-rc1 stalls the NFS transfer itself after
several GB.  The data was never corrupted.

Have you tried copying _ALL_ 190 GB to the server?

florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--bnUi9GzdSM4S/DMA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFF5P8hND0rFCN2b1sRAvqYAKCrPaxlu19dGvzMEe/1A1uGRxzKgQCfZW//
F8Q5m50RKRppM70klTEk/ww=
=PmUe
-----END PGP SIGNATURE-----

--bnUi9GzdSM4S/DMA--
