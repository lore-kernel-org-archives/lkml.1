Return-Path: <linux-kernel-owner+w=401wt.eu-S1753556AbYIXCtV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556AbYIXCtV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 22:49:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751415AbYIXCtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 22:49:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:14295 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751128AbYIXCtN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 22:49:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,297,1220252400"; 
   d="asc'?scan'208";a="339774994"
Subject: Re: [PATCH 0/4] x86: UV runtime bios calls
From: Huang Ying <ying.huang@intel.com>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>
In-Reply-To: <20080922210644.GC222374@sgi.com>
References: <20080922210644.GC222374@sgi.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-U5T91BVer4N8wy6s+hKT"
Date: Wed, 24 Sep 2008 10:49:10 +0800
Message-Id: <1222224550.23099.99.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U5T91BVer4N8wy6s+hKT
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Russ,

This seems to include a extension to EFI runtime services. Why not also
discuss that on UEFI forum? You can get some information about UEFI
forum from http://www.uefi.org/.

Best Regards,
Huang Ying

On Mon, 2008-09-22 at 16:06 -0500, Russ Anderson wrote:
> [PATCH 0/4] x86: UV runtime bios calls
>=20
> Purpose:=20
> 	Create an interface to allow calls into bios to return platform
> 	specific information.  The interface uses EFI SAL table entry.
> 	EFI provides a mechanism for defining function pointers to=20
> 	firmware routines.  This patchset builds on the EFI mechanism
> 	to provide access to those firmware routines.
>=20
> Patches:
> 	uv_efi_bios:	Look for SAL entry in EFI tables.
>=20
> 	uv_bios_common:	Add the EFI callback function using the EFI table
> 			entry.  Create associated wrapper code.  Initialize
> 			SAL system table entry info at boot time.
>=20
> 	uv_bios_call_partition: Add call to get partitioning related info.
>=20
> 	uv_sysfs:	Create sysfs entrys in /sys/firmware/sgi_uv/ for
> 			partitioning related information.
>=20
> Implementation comments:
>=20
> 	This patch uses sal_systab.  sal_systab is used on ia64, but was
> 	not used on x86.  An alternative would be to create a new
> 	EFI entry type (uv_systab), though that would require adding=20
> 	to struct efi.
>=20
> 	The location in sysfs (/sys/firmware/sgi_uv/) is based on
> 	community feedback.
>=20
> 	If EFI is not configured (CONFIG_EFI), the calls will return -ENOSYS.
> 	If run on a system with a bios that does not supportes EFI SAL, the
> 	calls will return -ENOSYS.
>=20
> 	Paul Jackson assisted in the development of this code.
> =09

--=-U5T91BVer4N8wy6s+hKT
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjZqqIACgkQKhFGF+eHlpg0LQCgn2Eq/jcQ23O8VMJgfyw4aSul
JjIAnj/tJntAvlwpSQclx6gpI8JKj5ZJ
=vH9L
-----END PGP SIGNATURE-----

--=-U5T91BVer4N8wy6s+hKT--

