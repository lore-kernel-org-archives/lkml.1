Return-Path: <linux-kernel-owner+w=401wt.eu-S1765655AbXF1UlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765655AbXF1UlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2007 16:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758226AbXF1UlG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jun 2007 16:41:06 -0400
Received: from threatwall.zlynx.org ([199.45.143.218]:32998 "EHLO zlynx.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757192AbXF1UlF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2007 16:41:05 -0400
Subject: Re: 2.6.22-rc6-mm1 Intel DMAR crash on AMD x86_64
From: Zan Lynx <zlynx@acm.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ashok.raj@intel.com, shaohua.li@intel.com,
       anil.s.keshavamurthy@intel.com
In-Reply-To: <20070628034321.38c9f12b.akpm@linux-foundation.org>
References: <20070628034321.38c9f12b.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-b8z8SMVyvtgEnqr7BQ7X"
Date: Thu, 28 Jun 2007 14:40:32 -0600
Message-Id: <1183063232.7813.23.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.2 
X-Envelope-From: zlynx@acm.org
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-b8z8SMVyvtgEnqr7BQ7X
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2007-06-28 at 03:43 -0700, Andrew Morton wrote:
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.22-rc6/=
2.6.22-rc6-mm1/

> +intel-iommu-dmar-detection-and-parsing-logic.patch
> +intel-iommu-pci-generic-helper-function.patch
> +intel-iommu-pci-generic-helper-function-fix.patch
> +intel-iommu-clflush_cache_range-now-takes-size-param.patch
> +intel-iommu-iova-allocation-and-management-routines.patch
> +intel-iommu-iova-allocation-and-management-routines-fix.patch
> +intel-iommu-iova-allocation-and-management-routines-fix-2.patch
> +intel-iommu-intel-iommu-driver.patch
> +intel-iommu-intel-iommu-driver-fix.patch
> +intel-iommu-intel-iommu-driver-fix-2.patch
> +intel-iommu-avoid-memory-allocation-failures-in-dma-map-api-calls.patch
> +intel-iommu-intel-iommu-cmdline-option-forcedac.patch
> +intel-iommu-dmar-fault-handling-support.patch
> +intel-iommu-iommu-gfx-workaround.patch
> +intel-iommu-iommu-floppy-workaround.patch
> +intel-iommu-iommu-floppy-workaround-fix.patch
> +intel-iommu-iommu-floppy-workaround-fix-fix.patch
>=20
>  Intel IOMMU support

I believe the above patch set is causing the problem.  On my first try
with rc6-mm1 I said Yes to the CONFIG_DMAR options. (I'm nearly as good
as random option selection :-)

The system panicked during boot, I believe it was trying to detect an
Intel IOMMU.  Later when I have a camera, I will try to post a
screenshot of the backtrace. (I can't seem to get netconsole to work on
boot, only in a module).

When I recompiled without DMAR set, things seem to be working great.  I
seem to be getting better disk read throughput than rc3-mm1, by the way.

This laptop is an AMD Athlon64 on a NForce3 running a 64-bit Gentoo
build.

I'll provide more details on request, and when I get the chance.  This
is a heads-up on the BUG in case someone has an "ah ha!" moment.
--=20
Zan Lynx <zlynx@acm.org>

--=-b8z8SMVyvtgEnqr7BQ7X
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGhBzAG8fHaOLTWwgRAljYAKCqBDMHVv7AsO+OFlO+2RphFsZRiACfeOeP
8Zj8zkR7ffqVrv2iKFluVW8=
=43jF
-----END PGP SIGNATURE-----

--=-b8z8SMVyvtgEnqr7BQ7X--

