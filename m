Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZKJCIm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZKJCIm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 21:08:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751869AbZKJCIl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 21:08:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:50263 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750981AbZKJCIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 21:08:40 -0500
Date: Tue, 10 Nov 2009 13:08:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Masami Hiramatsu <mhiramat@redhat.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for October 29 (x86 posttest)
Message-Id: <20091110130841.81d76a4b.sfr@canb.auug.org.au>
In-Reply-To: <4AF8B66B.3010405@redhat.com>
References: <20091029182919.4d6ec52c.sfr@canb.auug.org.au>
	<20091029090627.7857ed08.rdunlap@xenotime.net>
	<4AE9C74C.2040309@redhat.com>
	<20091106085954.39eb2789.rdunlap@xenotime.net>
	<4AF8B66B.3010405@redhat.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__10_Nov_2009_13_08_41_+1100_bNvrzhJDjKYQ7wKD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Nov_2009_13_08_41_+1100_bNvrzhJDjKYQ7wKD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 09 Nov 2009 19:40:11 -0500 Masami Hiramatsu <mhiramat@redhat.com> w=
rote:
>
> Randy Dunlap wrote:
> > On Thu, 29 Oct 2009 12:48:12 -0400 Masami Hiramatsu wrote:
> >
> >> Randy Dunlap wrote:
> >>>
> >>> I'm getting this on x86_64:
> >>>
> >>>     TEST    posttest
> >>> Error: ffffffff810299e2:	f2 41 0f 28 52 b0    	repnz movaps -0x50(%r1=
0),%xmm2
> >>> Error: objdump says 6 bytes, but insn_get_length() says 4 (attr:0)
> >>> make[2]: *** [posttest] Error 2
> >>
> >> Ah, that's should be fixed by AVX support patch which I've posted.
> >> http://git.kernel.org/tip/e0e492e99b372c6990a5daca9e4683c341f1330e
> >
> > Has that been merged into linux-next?
> > I'm still seeing this failure in linux-next-20091106.
>=20
> I checked it has been merged.
> So, it should disappear from linux-next-20091109. :-)

That commit (e0e492e99b372c6990a5daca9e4683c341f1330e "x86: AVX
instruction set decoder support") has been in linux-next since
next-20091104, so if Randy's problem still existed in next-20091106, then
it may be a different problem.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__10_Nov_2009_13_08_41_+1100_bNvrzhJDjKYQ7wKD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkr4yykACgkQjjKRsyhoI8zmAACeMhKgjK3Nq1DyCry0Dz12lTz2
6lUAoI/8iWexzU3oM6wlW7ICG1Nx9j6l
=oVHa
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Nov_2009_13_08_41_+1100_bNvrzhJDjKYQ7wKD--
