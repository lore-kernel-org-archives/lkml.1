Return-Path: <linux-kernel-owner+w=401wt.eu-S1757904AbZDOBhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904AbZDOBhi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Apr 2009 21:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757822AbZDOBhL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Apr 2009 21:37:11 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:56959 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757851AbZDOBhJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Apr 2009 21:37:09 -0400
Subject: Re: [BUILD FAILURE 02/12] Next April 14 : PPC64 randconfig
 [arch/powerpc/kernel/of_platform.c]
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: subrata@linux.vnet.ibm.com
Cc: Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       sachinp <sachinp@linux.vnet.ibm.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-next <linux-next@vger.kernel.org>,
       Alexander Beregalov <a.beregalov@gmail.com>
In-Reply-To: <1239733694.5344.74.camel@subratamodak.linux.ibm.com>
References: <1239733694.5344.74.camel@subratamodak.linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-C56sA11F81bV6PHagl9g"
Date: Wed, 15 Apr 2009 11:37:04 +1000
Message-Id: <1239759424.6552.3.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-C56sA11F81bV6PHagl9g
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-04-14 at 23:58 +0530, Subrata Modak wrote:
> Observed the following build error:
> ---
> arch/powerpc/kernel/of_platform.c: In function =E2=80=98of_pci_phb_probe=
=E2=80=99:
> arch/powerpc/kernel/of_platform.c:270: error: implicit declaration of
> function =E2=80=98pci_devs_phb_init_dynamic=E2=80=99
> arch/powerpc/kernel/of_platform.c:279: error: implicit declaration of
> function =E2=80=98scan_phb=E2=80=99
> arch/powerpc/kernel/of_platform.c:295: error: implicit declaration of
> function =E2=80=98pci_bus_add_devices=E2=80=99
> make[1]: *** [arch/powerpc/kernel/of_platform.o] Error 1
> make: *** [arch/powerpc/kernel] Error 2
> ---
>=20
> I saw some discussion(s) happening last year, but could not find out if
> some fixes are already available:
> http://www.mail-archive.com/linuxppc-dev@ozlabs.org/msg26215.html,

It's a different problem.

You have CONFIG_PPC_OF_PLATFORM_PCI=3Dy but CONFIG_PCI=3Dn.

That's because PPC_CELL_NATIVE selects PLATFORM_PCI, without regard to
whether PCI is enabled.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-C56sA11F81bV6PHagl9g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknlOkAACgkQdSjSd0sB4dKdvwCeNza0BCxAlZpKDjbrB+WWjZsZ
+YcAnRH6DrWI+DhUvfBcj1N3kggIlsfj
=tj4p
-----END PGP SIGNATURE-----

--=-C56sA11F81bV6PHagl9g--

