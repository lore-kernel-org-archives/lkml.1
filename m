Return-Path: <linux-kernel-owner+w=401wt.eu-S1755929AbZKQMrA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755929AbZKQMrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:47:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbZKQMrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:47:00 -0500
Received: from ozlabs.org ([203.10.76.45]:35430 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbZKQMq7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:46:59 -0500
Subject: Re: [PATCH 3/4] powerpc: Only define smp_pSeries_cpu_bootable when
 CONFIG_XICS is set
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
In-Reply-To: <1258459659-11770-4-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
	 <1258459659-11770-4-git-send-email-mel@csn.ul.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-CweUSIc5Y+xPFs3kT+Jg"
Date: Tue, 17 Nov 2009 23:47:04 +1100
Message-ID: <1258462024.24093.79.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-CweUSIc5Y+xPFs3kT+Jg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> If CONFIG_XICS is set, then smp_pSeries_cpu_bootable() is unnecessary.
> As warnings are treated as errors, this fails to build.
>=20
> This patch only defines smp_pSeries_cpu_bootable() when CONFIG_XICS is
> set.

I'm not sure, but I would guess that was just an oversight by whoever
added the cpu_bootable check. By which I mean it should be in the mpic
ops as well - avoiding the need for any ifdefery.

cheers


--=-CweUSIc5Y+xPFs3kT+Jg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksCm0gACgkQdSjSd0sB4dKX1wCfdaDspIvaQjUJD3xjRCf2XNov
xdkAoIrv/pqArTH3GwehfM+QqM8JG2h9
=PO41
-----END PGP SIGNATURE-----

--=-CweUSIc5Y+xPFs3kT+Jg--

