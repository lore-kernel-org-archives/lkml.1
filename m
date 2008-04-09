Return-Path: <linux-kernel-owner+w=401wt.eu-S1754643AbYDILJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643AbYDILJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2008 07:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753334AbYDILJp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Apr 2008 07:09:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36423 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752026AbYDILJo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2008 07:09:44 -0400
Date: Wed, 9 Apr 2008 21:09:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Jacek Luczak" <difrost.kernel@gmail.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for April 9
Message-Id: <20080409210936.ec8ea986.sfr@canb.auug.org.au>
In-Reply-To: <d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com>
References: <20080409185309.b94c9d15.sfr@canb.auug.org.au>
	<d711229d0804090400p1c92a158j381b86e207a6f38a@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__9_Apr_2008_21_09_36_+1000_0bgJ191cKsp5fbTF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Apr_2008_21_09_36_+1000_0bgJ191cKsp5fbTF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jacek,

On Wed, 9 Apr 2008 13:00:37 +0200 "Jacek Luczak" <difrost.kernel@gmail.com>=
 wrote:
>
> this tree fails to compile on my box with message:
>   CC      init/version.o
> arch/x86/kernel/traps_32.c: In function 'do_general_protection':
> arch/x86/kernel/traps_32.c:647: error: 'VM_MASK' undeclared (first use in
> this function)
> arch/x86/kernel/traps_32.c:647: error: (Each undeclared identifier is
> reported only once
> arch/x86/kernel/traps_32.c:647: error: for each function it appears in.)
> arch/x86/kernel/traps_32.c: In function 'do_debug':
> arch/x86/kernel/traps_32.c:926: error: 'VM_MASK' undeclared (first use in
> this function)
> arch/x86/kernel/traps_32.c: In function 'do_simd_coprocessor_error':
> arch/x86/kernel/traps_32.c:1098: error: 'VM_MASK' undeclared (first use in
> this function)
>=20
> GCC version:
> $ gcc -v
> Reading specs from /usr/lib/gcc/i686-slackware-linux/4.2.2/specs
> Target: i686-slackware-linux
> Configured with: ../gcc-4.2.2/configure --prefix=3D/usr --enable-shared
> --enable-threads=3Dposix --enable-__cxa_atexit --disable-checking
> --with-gnu-ld --enable-languages=3Dc,c++ --enable-clocale=3Dgnu --verbose
> --disable-multilib --with-tune=3Dprescott --disable-libstdcxx-pch
> --disable-bootstrap --target=3Di686-slackware-linux
> --host=3Di686-slackware-linux
> Thread model: posix
> gcc version 4.2.2

Thanks for the report, can you please send us your .config, please?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__9_Apr_2008_21_09_36_+1000_0bgJ191cKsp5fbTF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH/KP2TgG2atn1QN8RAoA8AKCNaTNEyD/sGCQYd+i5hFWaSw52HwCffZcl
e6aS3Bce3DTwYTAs+on4o4c=
=SEGZ
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Apr_2008_21_09_36_+1000_0bgJ191cKsp5fbTF--
