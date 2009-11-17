Return-Path: <linux-kernel-owner+w=401wt.eu-S1755823AbZKQMkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755823AbZKQMkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:40:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753319AbZKQMkG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:40:06 -0500
Received: from ozlabs.org ([203.10.76.45]:41254 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbZKQMkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:40:05 -0500
Subject: Re: [PATCH 1/4] powerpc: Add Kconfig dependency for PCI_MSI as
 needed by XICS
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1258459659-11770-2-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258459659-11770-2-git-send-email-mel@csn.ul.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-sZ52rn806U0XDPxqubVz"
Date: Tue, 17 Nov 2009 23:40:10 +1100
Message-ID: <1258461610.24093.74.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-sZ52rn806U0XDPxqubVz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> It's possible to set CONFIG_XICS without CONFIG_PCI_MSI. When that
> happens, the kernel fails to build with
>=20
> arch/powerpc/platforms/built-in.o: In function `.xics_startup':
> xics.c:(.text+0x12f60): undefined reference to `.unmask_msi_irq'
> make: *** [.tmp_vmlinux1] Error 1
>=20
> This patch adds the dependency in KConfig.

Actually we should ifdef the code instead, XICS doesn't require MSI -
that code chunk just needs to be conditional.

cheers

--=-sZ52rn806U0XDPxqubVz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksCmakACgkQdSjSd0sB4dKS2gCgmcX8gR4CJhHXWGzg/YpM/XqV
qMQAniqmAKEbm0IDB5u85Rgf9iSmymdo
=v1gr
-----END PGP SIGNATURE-----

--=-sZ52rn806U0XDPxqubVz--

