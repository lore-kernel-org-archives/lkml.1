Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbXLKWpo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbXLKWpo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2007 17:45:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757394AbXLKWoP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Dec 2007 17:44:15 -0500
Received: from ozlabs.org ([203.10.76.45]:53162 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757376AbXLKWoM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2007 17:44:12 -0500
Subject: Re: [2.6 patch] drivers/pci/msi.c: move arch hooks to the top
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Adrian Bunk <bunk@kernel.org>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-pci@atrey.karlin.mff.cuni.cz
In-Reply-To: <20071211221940.GA14204@stusta.de>
References: <20071211221940.GA14204@stusta.de>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-knK7gUhlbuB6J6YC4Qr/"
Date: Wed, 12 Dec 2007 09:44:10 +1100
Message-Id: <1197413050.7276.1.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-knK7gUhlbuB6J6YC4Qr/
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-12-11 at 23:19 +0100, Adrian Bunk wrote:
> This patch fixes the following problem present with older gcc versions:
>=20
> <--  snip  -->
>=20
> ...
>   CC      drivers/pci/msi.o
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:692: warning:=
 weak declaration of `arch_msi_check_device' after first use results in uns=
pecified behavior
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:704: warning:=
 weak declaration of `arch_setup_msi_irqs' after first use results in unspe=
cified behavior
> /home/bunk/linux/kernel-2.6/git/linux-2.6/drivers/pci/msi.c:724: warning:=
 weak declaration of `arch_teardown_msi_irqs' after first use results in un=
specified behavior
> ...
>=20
> <--  snip  -->

They're declared in <linux/msi.h>, I don't see what it's problem is.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-knK7gUhlbuB6J6YC4Qr/
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHXxK6dSjSd0sB4dIRAvyHAJwMaWWtLgge9iKn/J7YEOKUGjUsBgCeJwPB
YwdtsRtf+bczA5L6MYWLHlY=
=CwJh
-----END PGP SIGNATURE-----

--=-knK7gUhlbuB6J6YC4Qr/--

