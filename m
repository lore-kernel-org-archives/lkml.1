Return-Path: <linux-kernel-owner+w=401wt.eu-S933352AbYCEXTH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbYCEXTH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:19:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933963AbYCEXRk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:17:40 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51365 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933954AbYCEXRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:17:39 -0500
Date: Thu, 6 Mar 2008 10:17:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Badari Pulavarty <pbadari@gmail.com>, Matthew Wilcox <willy@debian.org>,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25-rc3-mm1 ppc64 boot hang
Message-Id: <20080306101722.ea2428f3.sfr@canb.auug.org.au>
In-Reply-To: <20080305135425.c8ebf8e4.akpm@linux-foundation.org>
References: <20080304011928.e8c82c0c.akpm@linux-foundation.org>
	<1204752855.7939.42.camel@dyn9047017100.beaverton.ibm.com>
	<20080305135425.c8ebf8e4.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__6_Mar_2008_10_17_22_+1100_9YzGf63F54Gqejo="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Mar_2008_10_17_22_+1100_9YzGf63F54Gqejo=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Wed, 5 Mar 2008 13:54:25 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> The semaphore consolidation code enables interrupts early in boot, when it
> shouldn't.  This tends to make powerpc blow up.  Could be that this is wh=
at
> you're hitting.
>=20
> Matthew, is this ging to be fixed soon?

There is a new version of these patches in the current linux-next tree ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__6_Mar_2008_10_17_22_+1100_9YzGf63F54Gqejo=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHzyoNTgG2atn1QN8RAh3oAJ0ehwJJuuzTm8suvAXRZqm2fTfFiwCeOAGZ
AwHV7VwMg0KY6ucf3X0OGpo=
=IdnR
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Mar_2008_10_17_22_+1100_9YzGf63F54Gqejo=--
