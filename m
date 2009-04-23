Return-Path: <linux-kernel-owner+w=401wt.eu-S1753568AbZDWAnw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568AbZDWAnw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 20:43:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751732AbZDWAnn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 20:43:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:41555 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751510AbZDWAnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 20:43:43 -0400
Subject: Re: [PATCH][BUILD FAILURE 03/12] Re: Next April 21 : PPC64
 randconfig [arch/powerpc/kernel/of_platform.o]
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Subrata Modak <subrata@linux.vnet.ibm.com>
Cc: Paul Mackerras <paulus@samba.org>, Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-next <linux-next@vger.kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <20090422161648.9231.76057.sendpatchset@subratamodak.linux.ibm.com>
References: <20090422161648.9231.76057.sendpatchset@subratamodak.linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-B1o7FI5dQRf/Am4VzBbR"
Date: Thu, 23 Apr 2009 10:43:40 +1000
Message-Id: <1240447420.6689.13.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-B1o7FI5dQRf/Am4VzBbR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 21:46 +0530, Subrata Modak wrote:
> On Wed, 2009-04-22 at 00:20 +0530, Subrata Modak wrote:
> > Reported this earlier on 14th April 2009:
> > http://lkml.org/lkml/2009/4/14/480,
> >=20
> > Michael,
> >=20
> > Any fix in sight ?
> > http://lkml.org/lkml/2009/4/14/676,
> >=20
> > CC      arch/powerpc/kernel/of_platform.o
> > arch/powerpc/kernel/of_platform.c: In function 'of_pci_phb_probe':
> > arch/powerpc/kernel/of_platform.c:270: error: implicit declaration of
> > function 'pci_devs_phb_init_dynamic'
> > arch/powerpc/kernel/of_platform.c:279: error: implicit declaration of
> > function 'scan_phb'
> > arch/powerpc/kernel/of_platform.c:295: error: implicit declaration of
> > function 'pci_bus_add_devices'
> > make[1]: *** [arch/powerpc/kernel/of_platform.o] Error 1
> > make: *** [arch/powerpc/kernel] Error 2
> > ---

The problem above is as I said before, that the Cell Kconfig forces on
PPC_OF_PLATFORM_PCI even if PCI is disabled. I think the proper fix is
just to have CELL_NATIVE force on PCI.

I don't know how you got the other errors, both pci_dn.c and pci_dlpar.c
are only built if CONFIG_PCI is enabled, see the Makefiles.

cheers

--=-B1o7FI5dQRf/Am4VzBbR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknvubwACgkQdSjSd0sB4dK05ACeJQN9C83Xbvm+4tBevpwZMA7u
304An3h2zIqTV87H4Q6IeiPNGnfEVsBq
=WXoj
-----END PGP SIGNATURE-----

--=-B1o7FI5dQRf/Am4VzBbR--

