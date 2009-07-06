Return-Path: <linux-kernel-owner+w=401wt.eu-S1757295AbZGFGTN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757295AbZGFGTN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:19:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752943AbZGFGS7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:18:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:51438 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752730AbZGFGS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:18:58 -0400
Date: Mon, 6 Jul 2009 16:18:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: linux-next: acpi tree build failure
Message-Id: <20090706161859.2d644aa7.sfr@canb.auug.org.au>
In-Reply-To: <20090630131645.68c81f0b.sfr@canb.auug.org.au>
References: <20090630131645.68c81f0b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__6_Jul_2009_16_18_59_+1000_zA0YY4bR8akT9gd4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__6_Jul_2009_16_18_59_+1000_zA0YY4bR8akT9gd4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Tue, 30 Jun 2009 13:16:45 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next build (powerpc ppc64_defconfig) failed like this:
>=20
>   GEN     /scratch/sfr/powerpc_ppc64_defconfig/Makefile
> drivers/platform/x86/Kconfig:353:error: found recursive dependency: EEEPC=
_LAPTOP -> HOTPLUG_PCI -> EEEPC_LAPTOP
>=20
> Caused by commit 6af05c22969dce2776375953131b56e9f4282848 ("eeepc-laptop:
> Register as a pci-hotplug device") interacting with commit
> 44b3615b8cb3b016a49eb7ef4236e77a77793cec ("eeepc-laptop: Fix build
> failure with HOTPLUG_PCI && !SYSFS") from Linus' tree.  Commit 6af05c2
> from the acpi tree is the same as commit
> 2b121bc262fa03c94e653b2d44356c2f86c1bcdc in Linus' tree that 44b3615b is
> fixing, so I have reverted the drivers/platform/x86/Kconfig part of
> 6af05c2 for today.

This is still happening ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__6_Jul_2009_16_18_59_+1000_zA0YY4bR8akT9gd4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpRl1MACgkQjjKRsyhoI8xXVACeJxX9pVoLKKtj8NB+WVIGWurn
8Q0AoLW7s2j4NjoLy8bRNNOKn5iBWhlO
=FCkz
-----END PGP SIGNATURE-----

--Signature=_Mon__6_Jul_2009_16_18_59_+1000_zA0YY4bR8akT9gd4--
