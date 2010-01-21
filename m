Return-Path: <linux-kernel-owner+w=401wt.eu-S1754128Ab0AUCTb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754128Ab0AUCTb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jan 2010 21:19:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753196Ab0AUCTS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 Jan 2010 21:19:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:43128 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752299Ab0AUCTR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jan 2010 21:19:17 -0500
Date: Thu, 21 Jan 2010 13:19:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christian Hofstaedtler <ch@zeha.at>
Subject: linux-next: acpi tree build warning
Message-Id: <20100121131908.fd4c91a3.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Jan_2010_13_19_08_+1100_bFqW4quhASsVGUGs"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Jan_2010_13_19_08_+1100_bFqW4quhASsVGUGs
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

arch/x86/kernel/reboot.c: In function 'native_machine_emergency_restart':
arch/x86/kernel/reboot.c:575: warning: enumeration value 'BOOT_UNDECIDED' n=
ot handled in switch

Introduced by commit 42b6f08e3f79a802332db1ce4a343923e690fc32 ("Default
to ACPI reboots on newish X86 hardware").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Jan_2010_13_19_08_+1100_bFqW4quhASsVGUGs
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktXuZwACgkQjjKRsyhoI8wvgACgpozV3gae5FvtIq4pq8AqBlUn
BcwAoKfbJc6CK9VhaTnPCEvApwv5TBnJ
=sndd
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Jan_2010_13_19_08_+1100_bFqW4quhASsVGUGs--
