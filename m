Return-Path: <linux-kernel-owner+w=401wt.eu-S1753036AbZIHAkV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753036AbZIHAkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 20:40:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752888AbZIHAkU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 20:40:20 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51454 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752876AbZIHAkU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 20:40:20 -0400
Date: Tue, 8 Sep 2009 10:40:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>,
       Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: security-testing tree build failure
Message-Id: <20090908104012.ff4bd25f.sfr@canb.auug.org.au>
In-Reply-To: <20090907234331.58140be8.sfr@canb.auug.org.au>
References: <20090907234028.6728eb5e.sfr@canb.auug.org.au>
	<20090907234331.58140be8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__8_Sep_2009_10_40_12_+1000_tMufThmRZIczMM4l"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__8_Sep_2009_10_40_12_+1000_tMufThmRZIczMM4l
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James, David,

On Mon, 7 Sep 2009 23:43:31 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Mon, 7 Sep 2009 23:40:28 +1000 Stephen Rothwell <sfr@canb.auug.org.au>=
 wrote:
> >
> > Today's linux-next build (arm lots of configs) failed like this:
> >=20
> > arch/arm/kernel/signal.c: In function 'do_notify_resume':
> > arch/arm/kernel/signal.c:701: error: implicit declaration of function '=
tracehook_notify_resume'
> >=20
> > Caused by commit d0420c83f39f79afb82010c2d2cafd150eef651b ("KEYS: Extend
> > TIF_NOTIFY_RESUME to (almost) all architectures [try #6]").  Presumably
> > the include of linux/tracehook.h is missing.
>=20
> The avr32 defconfig build fails the same way as well.  Thee may be
> others, that is as far as we have gone so far.

This also broke the alpha and mips builds.  I am going to use the version
of the security-testing tree from next-20090902 (the latest version I
have before the above commit was added) for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__8_Sep_2009_10_40_12_+1000_tMufThmRZIczMM4l
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqlp+wACgkQjjKRsyhoI8wQmgCghL5RBpQw6fVWISQwmi0Cdaeu
dS8An25ud5cq48x3kf2c7JJVu7W9bGDG
=cDZ8
-----END PGP SIGNATURE-----

--Signature=_Tue__8_Sep_2009_10_40_12_+1000_tMufThmRZIczMM4l--
