Return-Path: <linux-kernel-owner+w=401wt.eu-S1757367AbZHQIGb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757367AbZHQIGb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Aug 2009 04:06:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757332AbZHQIG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Aug 2009 04:06:28 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42875 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757329AbZHQIGY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Aug 2009 04:06:24 -0400
Date: Mon, 17 Aug 2009 18:06:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: <sfi-devel@simplefirmware.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Feng Tang <feng.tang@intel.com>, Len Brown <len.brown@intel.com>
Subject: linux-next: manual merge of the sfi tree with the acpi tree
Message-Id: <20090817180619.214fb0f0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__17_Aug_2009_18_06_19_+1000_tD_Z+gHztpqGkJdO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__17_Aug_2009_18_06_19_+1000_tD_Z+gHztpqGkJdO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the sfi tree got a conflict in
arch/x86/include/asm/io_apic.h arch/x86/kernel/acpi/boot.c
arch/x86/kernel/apic/io_apic.c between commit
f488a00f3759327c687e17858c07a1b0ea811cf0 ("ACPI, x86: remove ACPI
dependency on some IO-APIC routines") from the acpi tree and commit
2a98e7573b83bac1a79292a428090ee352626216 ("ACPI, x86: expose some IO-APIC
routines when CONFIG_ACPI=3Dn") from the sfi tree.

The latter seems to be a superset of the former (with one name change
uniq_ioapic_id -> io_apic_unique_id).  I fixed it up (using the sfi
trees' versions) and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__17_Aug_2009_18_06_19_+1000_tD_Z+gHztpqGkJdO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqJD3sACgkQjjKRsyhoI8xYNgCfQ9dwK4N1UsLjYIYvA/1kNHRj
0KMAn0GYvcxIQ8dVQYxxPu+hFppl7lp8
=h0A4
-----END PGP SIGNATURE-----

--Signature=_Mon__17_Aug_2009_18_06_19_+1000_tD_Z+gHztpqGkJdO--
