Return-Path: <linux-kernel-owner+w=401wt.eu-S1754822AbXLVU0G@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754822AbXLVU0G (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2007 15:26:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753084AbXLVUZz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Dec 2007 15:25:55 -0500
Received: from host-89-228-135-37.gorzow.mm.pl ([89.228.135.37]:63731 "EHLO
	astralstorm.puszkin.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572AbXLVUZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2007 15:25:54 -0500
X-Greylist: delayed 308 seconds by postgrey-1.27 at vger.kernel.org; Sat, 22 Dec 2007 15:25:54 EST
Date: Sat, 22 Dec 2007 21:20:35 +0100
From: Radoslaw Szkodzinski (AstralStorm) <lkml@astralstorm.puszkin.org>
To: Benny Amorsen <benny+usenet@amorsen.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Trailing periods in kernel messages
Message-ID: <20071222212035.5c942b62@astralstorm.puszkin.org>
In-Reply-To: <m33atu25cv.fsf@ursa.amorsen.dk>
References: <E1J5ecS-0008UX-00@gondolin.me.apana.org.au>
	<Pine.LNX.4.64.0712211104080.21721@fbirervta.pbzchgretzou.qr>
	<20071221114103.GA801@gondor.apana.org.au>
	<Pine.LNX.4.64.0712211254160.21721@fbirervta.pbzchgretzou.qr>
	<20071221160125.GJ2310@csclub.uwaterloo.ca>
	<m33atu25cv.fsf@ursa.amorsen.dk>
X-Mailer: Claws Mail 3.1.0 (GTK+ 2.12.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/0SWFxXnpKm8FO/rzTJpq_N1";
 protocol="application/pgp-signature"; micalg=PGP-SHA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0SWFxXnpKm8FO/rzTJpq_N1
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Dec 2007 15:04:16 +0100
Benny Amorsen <benny+usenet@amorsen.dk> wrote:
> It is a bit of a mystery why the kernel is ordering me to initialize
> the current offset of xfs_file_readdir though. I don't know how to do
> that, so I guess it's lucky that I don't use XFS. Who knows what would
> happen if I didn't correctly initialize xfs_file_readdir.

I thinks it's not the kernel ordering you, it's the developer ordering
the kernel to initialize that variable - presumably, because when it
didn't do that, things broke.

--Sig_/0SWFxXnpKm8FO/rzTJpq_N1
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQFHbXGaBlhXA0ALOYMRAqljAJ4qxAxAeNZcPfk/H+QUDGxmpxKopgCgvexJ
ekO+9xK2F2/x4eyqZbK9Nwg=
=QHqM
-----END PGP SIGNATURE-----

--Sig_/0SWFxXnpKm8FO/rzTJpq_N1--
