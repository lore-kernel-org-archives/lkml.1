Return-Path: <linux-kernel-owner+w=401wt.eu-S1755386AbYKKE7R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755386AbYKKE7R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2008 23:59:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754574AbYKKE7E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Nov 2008 23:59:04 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57871 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbYKKE7C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2008 23:59:02 -0500
Date: Tue, 11 Nov 2008 15:58:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Valdis.Kletnieks@vt.edu, linux-kernel@vger.kernel.org,
       Ken Chen <kenchen@google.com>, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.28-rc4-mmotm1110 - you gotta be kidding me...
Message-Id: <20081111155844.7414bad8.sfr@canb.auug.org.au>
In-Reply-To: <20081110193713.d94ed39a.akpm@linux-foundation.org>
References: <30622.1226372137@turing-police.cc.vt.edu>
	<20081110193713.d94ed39a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__11_Nov_2008_15_58_44_+1100_9PPmursC.BFKkwS0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Nov_2008_15_58_44_+1100_9PPmursC.BFKkwS0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Nov 2008 19:37:13 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Mon, 10 Nov 2008 21:55:37 -0500 Valdis.Kletnieks@vt.edu wrote:
>=20
> > Somebody's been hitting the phunky pharmaceuticals in the last 4 days,
> > because this ball-of-joy snuck into linux-next.patch sometime between
> > -mmotm1106 and --mmotm1110.
> >=20
> > Seen in a 'make silentallconfig'
> >=20
> >   Single-depth WCHAN output (SCHED_NO_NO_OMIT_FRAME_POINTER) [Y/n/?] (N=
EW) ?
> >=20
> >   Calculate simpler /proc/<PID>/wchan values. If this option
> >   is disabled then wchan values will recurse back to the
> >   caller function. This provides more accurate wchan values,
> >   at the expense of slightly more scheduling overhead.
>=20
> I got lost here.
>=20
> >   If in doubt, say "Y".
> >=20
> > So if I say 'y', is that a request to disable it, or enable it?  And
> > what exactly do I get if I vote *against* 'more accurate wchan values'?
> > Do I get everybody having the same wchan pointing somewhere in the
> > scheduler code, because that's where __builtin_return_address() points?
> >=20
> > And please - a triple negative in the Kconfig variable name?  This has
> > gotta be a winner for poor taste in variable naming...
> >=20
>=20
> Even if that is all sorted out, how the heck is anyone to decide
> whether or not they need this thing?
>=20
> Also, if we really really are so wishy-washy indecisive that we need to
> make the function optional, it should if at all possible be made
> runtime-configurable, not compile-time.

This came from commit a87d091434ed2a34d647979ab12084139ee1fe41 ("x86,
sched: enable wchan config menu item on 64-bit").  We have had
CONFIG_SCHED_NO_NO_OMIT_FRAME_POINTER for some time on various
architectures, this commit just made it available on x86_64 (by changing
its dependency from X86_32 to X86).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Nov_2008_15_58_44_+1100_9PPmursC.BFKkwS0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkZEQQACgkQjjKRsyhoI8y1TwCdE/xpityLPrhe+i9Knk7PcRoO
RIsAoL8CAlGl52VihOwaIO7dvNPZFwi1
=iVMv
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Nov_2008_15_58_44_+1100_9PPmursC.BFKkwS0--
