Return-Path: <linux-kernel-owner+w=401wt.eu-S1757298AbYHGAcW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298AbYHGAcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 20:32:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753226AbYHGAa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 20:30:29 -0400
Received: from ozlabs.org ([203.10.76.45]:49813 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753224AbYHGAa2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 20:30:28 -0400
Subject: Re: [patch] PCI: check the return value of
	device_create_bin_file() in pci_create_bus()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Simon Horman <horms@verge.net.au>
Cc: Matthew Wilcox <matthew@wil.cx>, Sven Wegener <sven.wegener@stealer.net>,
       linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>
In-Reply-To: <20080806233018.GG10636@verge.net.au>
References: <20080805101605.GA19382@verge.net.au>
	 <alpine.LNX.1.10.0808051224350.5671@titan.stealer.net>
	 <20080805110006.GA13409@verge.net.au> <20080805111406.GA13899@verge.net.au>
	 <20080805112814.GO26461@parisc-linux.org>
	 <20080805121531.GA29763@verge.net.au>
	 <20080805122639.GP26461@parisc-linux.org>
	 <20080806005718.GE32143@verge.net.au>
	 <20080806131900.GI2055@parisc-linux.org>
	 <20080806232523.GF10636@verge.net.au> <20080806233018.GG10636@verge.net.au>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-7351w0AKCF6Ueqh90zEe"
Date: Thu, 07 Aug 2008 10:30:26 +1000
Message-Id: <1218069026.7900.0.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-7351w0AKCF6Ueqh90zEe
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2008-08-07 at 09:30 +1000, Simon Horman wrote:
> Check the return value of device_create_bin_file in pci_create_bus and
> unwind if necessary. Don't propagate error to caller, as failure to creat=
e
> these files shouldn't prevent PCI from being initialised.
>=20
> Cc: Sven Wegener <sven.wegener@stealer.net>
> Cc: Michael Ellerman <michael@ellerman.id.au>
> Cc: Matthew Wilcox <matthew@wil.cx>
> Signed-off-by: Simon Horman <horms@verge.net.au>

I hate to prolong the pain, but wasn't the plan to print a big fat
warning so that it's clear the system is not 100% happy.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-7351w0AKCF6Ueqh90zEe
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBImkIidSjSd0sB4dIRAoyUAJ9wX9G9VHPqcRF5bIlKCFb6pcpcOQCeOIOs
UIHAqSECkXRs9FvTXIGa2S0=
=dsme
-----END PGP SIGNATURE-----

--=-7351w0AKCF6Ueqh90zEe--

