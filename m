Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbZCCWoV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbZCCWoV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 17:44:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754959AbZCCWoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 17:44:08 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54209 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbZCCWoH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 17:44:07 -0500
Date: Wed, 4 Mar 2009 09:43:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Bob Moore <robert.moore@intel.com>, Len Brown <len.brown@intel.com>,
       Lin Ming <ming.m.lin@intel.com>
Subject: Re: linux-next: Tree for March 3 (cpufreq)
Message-Id: <20090304094350.f18f2925.sfr@canb.auug.org.au>
In-Reply-To: <49AD5F03.2050409@oracle.com>
References: <20090303182633.4ad7831b.sfr@canb.auug.org.au>
	<49AD5F03.2050409@oracle.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__4_Mar_2009_09_43_50_+1100_JoLmaP3x1GG_/ZMd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__4_Mar_2009_09_43_50_+1100_JoLmaP3x1GG_/ZMd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Tue, 03 Mar 2009 08:46:59 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> arch/x86/kernel/cpu/cpufreq/longhaul.c:308: error: implicit declaration o=
f function 'acpi_set_register'
>=20
> I can't find any such function in the linux-next tree.

Looks like this is due to commit bcf80648ccbb7524acb457aef7feb4bc83a9ba14
("ACPICA: Rename ACPI bit register access functions") from the acpi tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__4_Mar_2009_09_43_50_+1100_JoLmaP3x1GG_/ZMd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmtsqYACgkQjjKRsyhoI8zOUwCfW5i3r/v6dcuZEGXklLUV2mGA
7zsAn1J/+CmehdJ4VPM3Bk163aaKDgpY
=My1Q
-----END PGP SIGNATURE-----

--Signature=_Wed__4_Mar_2009_09_43_50_+1100_JoLmaP3x1GG_/ZMd--
