Return-Path: <linux-kernel-owner+w=401wt.eu-S1754167AbXEYCcq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754167AbXEYCcq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 22:32:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752831AbXEYCcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 22:32:39 -0400
Received: from ozlabs.org ([203.10.76.45]:42290 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809AbXEYCci (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 22:32:38 -0400
Subject: Re: [PATCH] msi: Fix the ordering of msix irqs.
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       tom.l.nguyen@intel.com, iss_storagedev@hp.com, jens.axboe@oracle.com
In-Reply-To: <m1hcq2dj5m.fsf_-_@ebiederm.dsl.xmission.com>
References: <20070524160756.GA14083@beardog.cca.cpqcorp.net>
	 <20070524102702.bca37396.akpm@linux-foundation.org>
	 <m1r6p6dn3x.fsf@ebiederm.dsl.xmission.com>
	 <20070524205900.GC14083@beardog.cca.cpqcorp.net>
	 <m1hcq2dj5m.fsf_-_@ebiederm.dsl.xmission.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-9PThvc5lqqLtTBYj+Rt0"
Date: Fri, 25 May 2007 12:32:36 +1000
Message-Id: <1180060356.8203.26.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-9PThvc5lqqLtTBYj+Rt0
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-05-24 at 15:08 -0600, Eric W. Biederman wrote:
> Yours looks more complete then my test patch so:
>=20
> From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> writes:
>=20
> Found what seems the problem with our vectors being listed backward. In
> drivers/pci/msi.c we should be using list_add_tail rather than list_add t=
o
> preserve the ordering across various kernels. Please consider this for
> inclusion.
>=20
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Screwed-up-by: Michael Ellerman <michael@ellerman.id.au>

The sad part is my earlier patches did use list_add_tail(), doh. :(

Thanks for debugging it.

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-9PThvc5lqqLtTBYj+Rt0
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGVkrEdSjSd0sB4dIRAoIBAJ48yi8lg1GvOZ3m/eYWWdPymZtqjQCeOPlx
POem9fQCB69CnsHFv+O7b3I=
=2A5N
-----END PGP SIGNATURE-----

--=-9PThvc5lqqLtTBYj+Rt0--

