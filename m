Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbYGSNXT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbYGSNXT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2008 09:23:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754493AbYGSNXI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jul 2008 09:23:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53349 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754386AbYGSNXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2008 09:23:06 -0400
Date: Sat, 19 Jul 2008 23:22:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Vegard Nossum" <vegard.nossum@gmail.com>
Cc: "Mariusz Kozlowski" <m.kozlowski@tuxland.pl>,
       "Dave Hansen" <haveblue@us.ibm.com>,
       "Greg Kroah-Hartman" <gregkh@suse.de>, kernel-testers@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       "Pekka Enberg" <penberg@cs.helsinki.fi>
Subject: Re: linux-next: Tree for July 18: warning at kernel/lockdep.c:2068
 trace_hardirqs_on_caller
Message-Id: <20080719232256.f0648c27.sfr@canb.auug.org.au>
In-Reply-To: <19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
References: <20080718195352.e562a00f.sfr@canb.auug.org.au>
	<200807190928.33978.m.kozlowski@tuxland.pl>
	<19f34abd0807190255x304173d4wf2bfabb2d5bce511@mail.gmail.com>
	<19f34abd0807190559y2fe5ebf9h7095793e82de3122@mail.gmail.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__19_Jul_2008_23_22_56_+1000_PquE/liHnRR9wW2v"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__19_Jul_2008_23_22_56_+1000_PquE/liHnRR9wW2v
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Vegard,

On Sat, 19 Jul 2008 14:59:12 +0200 "Vegard Nossum" <vegard.nossum@gmail.com=
> wrote:
>
> Ehe... and this is the reason why: The code was added by this patch:
>=20
> commit 0e3638d1e04040121af00195f7e4628078246489
> Author: Dave Hansen <haveblue@us.ibm.com>
> Date:   Thu Mar 16 17:30:16 2006 -0800
>=20
>     warn when statically-allocated kobjects are used
>=20
> ..which only exists in -next. Is that just a truly ancient patch, or
> did somebody forget to adjust their clock?
>=20
> (Stephen: Maybe this has been answered before, but what's the best way
> to figure out where it came from?)

The easiest way is to ask me to look in my source tree (since I have the
heads of all the branches I merge - at least until the next day and gitk
then makes it easy ...).

In this case, that commit comes from the driver-core tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__19_Jul_2008_23_22_56_+1000_PquE/liHnRR9wW2v
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiB6rAACgkQjjKRsyhoI8xIUwCfel20JjVMLVPcVQuvpKyoy2vR
yQwAnArVN9XMGpG0V+WkYpyjkLgPIYa4
=dHqf
-----END PGP SIGNATURE-----

--Signature=_Sat__19_Jul_2008_23_22_56_+1000_PquE/liHnRR9wW2v--
