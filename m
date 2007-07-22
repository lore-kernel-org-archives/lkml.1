Return-Path: <linux-kernel-owner+w=401wt.eu-S1754535AbXGVBzF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535AbXGVBzF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 21:55:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750859AbXGVByz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 21:54:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46131 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750854AbXGVByy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 21:54:54 -0400
Date: Sun, 22 Jul 2007 11:55:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Mackerras <paulus@samba.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Don't compile the PMU power driver on 64-bit PowerPC
Message-Id: <20070722115503.909f746f.sfr@canb.auug.org.au>
In-Reply-To: <18082.43262.487474.356610@cargo.ozlabs.ibm.com>
References: <18082.43262.487474.356610@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__22_Jul_2007_11_55_03_+1000_L1hXU0TRBC_BKsDi"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__22_Jul_2007_11_55_03_+1000_L1hXU0TRBC_BKsDi
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Jul 2007 10:46:54 +1000 Paul Mackerras <paulus@samba.org> wrote:
>
> As reported by Stephen Rothwell, an allmodconfig build on 64-bit
> PowerPC reports these errors:
>=20
> ERROR: "pmu_batteries" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_battery_count" [drivers/power/pmu_battery.ko] undefined!
> ERROR: "pmu_power_flags" [drivers/power/pmu_battery.ko] undefined!
>=20
> This fixes the problem by not building pmu_battery.ko on ppc64.  There
> are no battery-powered ppc64 machines with an Apple PMU, and we can be
> reasonably confident there never will be.
>=20
> Signed-off-by: Paul Mackerras <paulus@samba.org>

That fixes it.
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
for what its worth :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__22_Jul_2007_11_55_03_+1000_L1hXU0TRBC_BKsDi
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGorj7TgG2atn1QN8RAmBbAJ4nmQDXKBol1jyT1eY+8aP/Lczb5gCfVE90
Us5gX044vOpEspkIOw6+68s=
=25zN
-----END PGP SIGNATURE-----

--Signature=_Sun__22_Jul_2007_11_55_03_+1000_L1hXU0TRBC_BKsDi--
