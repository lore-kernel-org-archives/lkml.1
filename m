Return-Path: <linux-kernel-owner+w=401wt.eu-S1755732AbZKQMjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755732AbZKQMjA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Nov 2009 07:39:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755448AbZKQMjA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Nov 2009 07:39:00 -0500
Received: from ozlabs.org ([203.10.76.45]:40374 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185AbZKQMi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Nov 2009 07:38:59 -0500
Subject: Re: [PATCH 0/4] powerpc: Fix minor build issues on 2.6.32-rc7
 without CONFIG_XICS set
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Mel Gorman <mel@csn.ul.ie>
Cc: Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
References: <1258459659-11770-1-git-send-email-mel@csn.ul.ie>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-OEVcSAbbn2FoXtixa0x4"
Date: Tue, 17 Nov 2009 23:39:04 +1100
Message-ID: <1258461544.24093.72.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OEVcSAbbn2FoXtixa0x4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-11-17 at 12:07 +0000, Mel Gorman wrote:
> KConfig doesn't require CONFIG_XICS to be set with CONFIG_PSERIES but if
> it's not set, there are numerous small build errors. This is a small seri=
es
> of patches to allow CONFIG_XICS to be unset in the config.
>=20
> XICS appears to be some sort of interrupt controller but I'm not sure how
> common it is on systems that require CONFIG_PSERIES. If CONFIG_PSERIES
> universally requires CONFIG_XICS, the better path might be to force it to
> be set.

It is indeed 'some sort of interrupt controller' :)

All the virtualised PSERIES systems have, or appear to have, a XICS. So
it's pretty common.

I think the only time you see an MPIC is on older machines, and even
then maybe only if you're running bare metal.

So it is pretty much required for a PSERIES kernel, but perhaps there
are cases where the BML guys want to be able to turn it off.

cheers

--=-OEVcSAbbn2FoXtixa0x4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAksCmWcACgkQdSjSd0sB4dL5rgCgwA5jUM1FBy7giU/Sw8xA+98u
cYMAoIafskHb7D6znFUH0yQ3eg7JYMGh
=YXeu
-----END PGP SIGNATURE-----

--=-OEVcSAbbn2FoXtixa0x4--

