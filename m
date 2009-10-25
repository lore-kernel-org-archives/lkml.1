Return-Path: <linux-kernel-owner+w=401wt.eu-S1753850AbZJYRmr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850AbZJYRmr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Oct 2009 13:42:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753840AbZJYRmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 25 Oct 2009 13:42:46 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:56543 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753838AbZJYRmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Oct 2009 13:42:46 -0400
X-Greylist: delayed 523 seconds by postgrey-1.27 at vger.kernel.org; Sun, 25 Oct 2009 13:42:46 EDT
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: udev in kernel source?
Date: Sun, 25 Oct 2009 18:33:55 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31.5-tp42-toi-3.0.1-04850-g4eddd0d; KDE/4.3.2; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4644437.GuuxQE9nTG";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200910251834.06321.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4644437.GuuxQE9nTG
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi!

Would that qualify as a reason to put it there and have make-kpkg / make=20
deb / make rpm spit out a udev package as well?

shambhala:/var/log> grep -i deprecated syslog | grep udev
Oct 25 09:41:22 shambhala udevd[21078]: udev: missing sysfs features;=20
please update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED=20
option; udev may fail to work correctly                                    =
                       =20
Oct 25 09:41:37 shambhala kernel: <3>udev: missing sysfs features; please=20
update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option;=20
udev may fail to work correctly
Oct 25 13:35:10 shambhala kernel: <3>udev: missing sysfs features; please=20
update the kernel or disable the kernel's CONFIG_SYSFS_DEPRECATED option;=20
udev may fail to work correctly

It seems that nothing critical is not working, but I only found this by=20
closely watching the boot process at all.

Granted, for a long time I did not see any udev/kernel version mismatch or=
=20
configuration option mismatch issues, but back in udev early days I were=20
hit several times by those annoyances.

Ironically I was about to disable CONFIG_SYSFS_DEPRECATED when it was=20
introduced, but then HAL didn't work.

There should be an easy way to figure out whether kernel and deeply related=
=20
userspace tools are matching each other.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart4644437.GuuxQE9nTG
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkrkjAMACgkQmRvqrKWZhMdbDwCePiGXMXNarOCLmREjc2GsqcxM
xpIAn2RLzEl0DINRGJFXlnUXm/sKvBes
=+It9
-----END PGP SIGNATURE-----

--nextPart4644437.GuuxQE9nTG--
