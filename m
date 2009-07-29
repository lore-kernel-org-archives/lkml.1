Return-Path: <linux-kernel-owner+w=401wt.eu-S1754227AbZG2PNG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754227AbZG2PNG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jul 2009 11:13:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752798AbZG2PNF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Jul 2009 11:13:05 -0400
Received: from zelda.netsplit.com ([87.194.19.211]:57562 "EHLO
	zelda.netsplit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbZG2PNF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jul 2009 11:13:05 -0400
Subject: Re: [PATCH] exec: Make do_coredump more robust and safer when
 using pipes in core_pattern
From: Scott James Remnant <scott@canonical.com>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       earl_chew@agilent.com
In-Reply-To: <20090622172818.GB14673@hmsreliant.think-freely.org>
References: <20090622172818.GB14673@hmsreliant.think-freely.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-NOB0l3LGJYr8MTamdPAm"
Date: Wed, 29 Jul 2009 16:13:02 +0100
Message-Id: <1248880382.23840.78.camel@quest>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NOB0l3LGJYr8MTamdPAm
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-06-22 at 13:28 -0400, Neil Horman wrote:

> 2) Allow for the kernel to wait for a core_pattern process to complete.  =
One of
> the things core_pattern processes might do is interrogate the status of a
> crashing process via its /proc/pid directory.  To ensure that that direct=
ory is
> not removed prematurely, we wait for the process to exit prior to cleanin=
g it
> up.
>=20
Would this mean that the kernel would wait for the pattern process to
complete before PANIC in the case of init core dumping?

I'd find that useful :-)

Scott
--=20
Scott James Remnant
scott@canonical.com

--=-NOB0l3LGJYr8MTamdPAm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkpwZv4ACgkQSnQiFMl4yK5FRACfYjhPEtSziIJH7Jydz1w4NmqL
JgsAn1L4se9fWiB2zWaLJiaRUXx1gFcG
=7pe7
-----END PGP SIGNATURE-----

--=-NOB0l3LGJYr8MTamdPAm--

