Return-Path: <linux-kernel-owner+w=401wt.eu-S1752248AbYKREeU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248AbYKREeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 23:34:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbYKREeH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 23:34:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:38465 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371AbYKREeE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 23:34:04 -0500
Date: Tue, 18 Nov 2008 15:33:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Christoph Lameter <cl@linux-foundation.org>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
       Haavard Skinnemoen <hskinnemoen@atmel.com>
Subject: linux-next: cpu_alloc tree patch (Was: Re: next-20081106: undefined
 reference to `__per_cpu_start')
Message-Id: <20081118153346.62bf9c11.sfr@canb.auug.org.au>
In-Reply-To: <Pine.LNX.4.64.0811071235040.5387@quilx.com>
References: <20081106173645.e7e79071.sfr@canb.auug.org.au>
	<20081106183939.GA26925@x200.localdomain>
	<Pine.LNX.4.64.0811061310350.6009@quilx.com>
	<20081107162114.2a41c623.sfr@canb.auug.org.au>
	<Pine.LNX.4.64.0811071235040.5387@quilx.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Nov_2008_15_33_46_+1100_kXC4YmWP5Q.i567_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Nov_2008_15_33_46_+1100_kXC4YmWP5Q.i567_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Fri, 7 Nov 2008 12:40:17 -0600 (CST) Christoph Lameter <cl@linux-foundat=
ion.org> wrote:
>
> All of these have no invocation of the PERCPU macro from
> asm-generic/vmlinus.lds.h in their arch vmlinux.lds.S. Thus the symbols
> are missing. They are kind of irrelevant since we are only interested in
> the difference between those...
>=20
> Either we add the PERCPU() macro invocations to each arches vmlinux.lds.S
> file or we need to special case each time __per_cpu_end/__start is used.
> The only use added for the cpu allocator is in include/linux/percpu.h
>=20
> Make it conditional on CONFIG_SMP
>=20
> Signed-off-by: Christoph Lameter <cl@linux-foundation.org>

I have applied this to linux-next today.  It is not clear to me if this
is a fix for the cpu_alloc tree or the zero-based per_cpu area patches or
a combination of both.  If the first, please apply this to the cpu_alloc
tree or I will have to drop the tree.  Otherwise, let me know where it
belongs.

Also, considering the "discussions" between Rusty and yourself, I may
need to drop the cpu_alloc tree until they are resolved.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Nov_2008_15_33_46_+1100_kXC4YmWP5Q.i567_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkiRaoACgkQjjKRsyhoI8xJ4wCgplAd8nliX3IFFQVuJaO43BLg
prgAoJxv/neUJ+RZVOCnfotcMucv40RX
=42A4
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Nov_2008_15_33_46_+1100_kXC4YmWP5Q.i567_--
