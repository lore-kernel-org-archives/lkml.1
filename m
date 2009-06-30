Return-Path: <linux-kernel-owner+w=401wt.eu-S1758244AbZF3HTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758244AbZF3HTu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 03:19:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752909AbZF3HTm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 03:19:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58658 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750802AbZF3HTm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 03:19:42 -0400
Date: Tue, 30 Jun 2009 17:19:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: sfi tree build failure
Message-Id: <20090630171937.75f64662.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Jun_2009_17_19_37_+1000_R_vQQaDg=kY4xDj."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Jun_2009_17_19_37_+1000_R_vQQaDg=kY4xDj.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next build (powerpc ppc64_defconfig) failed like this:

In file included from include/acpi/platform/acenv.h:141,
                 from include/acpi/acpi.h:56,
                 from include/linux/acpi.h:38,
                 from init/main.c:27:
include/acpi/platform/aclinux.h:64:22: error: asm/acpi.h: No such file or d=
irectory
In file included from include/acpi/platform/aclinux.h:130,
                 from include/acpi/platform/acenv.h:141,
                 from include/acpi/acpi.h:56,
                 from include/linux/acpi.h:38,
                 from init/main.c:27:
include/acpi/actypes.h:130: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'UINT64'
include/acpi/actypes.h:131: error: expected '=3D', ',', ';', 'asm' or '__at=
tribute__' before 'INT64'
include/acpi/actypes.h:910: error: expected ')' before '*' token
include/acpi/actypes.h:913: error: expected ')' before '*' token

and it went downhill from there :-(

I have dropped the sfi tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Jun_2009_17_19_37_+1000_R_vQQaDg=kY4xDj.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpJvIkACgkQjjKRsyhoI8wfyQCdETijduQEysCTGRBalS5tRu2V
hC8An2QlF3+kk4HQOs1KE4BWfb2RmYJ3
=5f9g
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Jun_2009_17_19_37_+1000_R_vQQaDg=kY4xDj.--
