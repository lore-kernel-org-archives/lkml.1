Return-Path: <linux-kernel-owner+w=401wt.eu-S1757156AbXETLep@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757156AbXETLep (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 07:34:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755212AbXETLei
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 07:34:38 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:59515 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755124AbXETLeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 07:34:37 -0400
Date: Sun, 20 May 2007 13:04:19 +0200
From: Elimar Riesebieter <riesebie@lxtec.de>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Subject: 2.6.22-rc2 built on ppc (1)
Message-ID: <20070520110419.GB3253@aragorn.home.lxtec.de>
Mail-Followup-To: gregkh@suse.de, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="/NkBOFFp2J2Af1nK"
Content-Disposition: inline
Organization: LXTEC
X-Editor: VIM - Vi IMproved 7.1 (2007 May 12, compiled May 15 2007 21:24:37)
User-Agent: Mutt/1.5.15+lxtec (2007-05-02)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--/NkBOFFp2J2Af1nK
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

FYI, building 2.6.22-rc2 with
gcc (GCC) 4.1.3 20070514 (prerelease) (Debian 4.1.2-7)
on my powerbook (PPC) gives:

=2E..
arch/powerpc/kernel/pci_32.c: In function 'pcibios_assign_resources':
arch/powerpc/kernel/pci_32.c:562: warning: ignoring return value of 'pci_as=
sign_resource', declared with attribute warn_unused_result
arch/powerpc/kernel/pci_32.c: In function 'pcibios_add_platform_entries':
arch/powerpc/kernel/pci_32.c:1053: warning: ignoring return value of 'devic=
e_create_file', declared with attribute warn_unused_result
arch/powerpc/mm/mem.c: In function 'paging_init':
arch/powerpc/mm/mem.c:313: warning: passing argument 1 of 'pmd_offset' from=
 incompatible pointer type
arch/powerpc/mm/mem.c:316: warning: passing argument 1 of 'pmd_offset' from=
 incompatible pointer type
=2E..
drivers/base/core.c: In function 'device_add':
drivers/base/core.c:714: warning: ignoring return value of 'sysfs_create_li=
nk', declared with attribute warn_unused_result
drivers/base/core.c:719: warning: ignoring return value of 'sysfs_create_li=
nk', declared with attribute warn_unused_result
drivers/base/core.c:722: warning: ignoring return value of 'sysfs_create_li=
nk', declared with attribute warn_unused_result
drivers/base/core.c: In function 'device_rename':
drivers/base/core.c:1197: warning: ignoring return value of 'sysfs_create_l=
ink', declared with attribute warn_unused_result
drivers/base/dd.c:211: warning: 'device_probe_drivers' defined but not used
=2E..
drivers/ide/setup-pci.c: In function 'ide_scan_pcibus':
drivers/ide/setup-pci.c:879: warning: ignoring return value of '__pci_regis=
ter_driver', declared with attribute warn_unused_result
drivers/pci/search.c: In function 'pci_find_slot':
drivers/pci/search.c:99: warning: 'pci_find_device' is deprecated (declared=
 at include/linux/pci.h:477)
drivers/pci/search.c: At top level:
drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated (declare=
d at drivers/pci/search.c:241)
drivers/pci/search.c:433: warning: 'pci_find_device' is deprecated (declare=
d at drivers/pci/search.c:241)
=2E..

If more info is needed, please contact me via PM, as I am not
subscribed.

Thanks for your patience
Elimar

--=20
  Never make anything simple and efficient when a way
  can be found to make it complex and wonderful ;-)

--/NkBOFFp2J2Af1nK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGUCsz3Ig8bsVPf7ARAh7yAJ9nRx9fEo4W9NsN93cS6XtMzJFriACeJ3V6
lFKd4s6txpm01bsvQWHlCuo=
=wvqe
-----END PGP SIGNATURE-----

--/NkBOFFp2J2Af1nK--
