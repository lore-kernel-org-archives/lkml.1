Return-Path: <linux-kernel-owner+w=401wt.eu-S1753917AbXFNSKt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753917AbXFNSKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 14:10:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751063AbXFNSKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 14:10:41 -0400
Received: from ns2.uludag.org.tr ([193.140.100.220]:56366 "EHLO uludag.org.tr"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751092AbXFNSKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 14:10:40 -0400
From: "=?utf-8?q?S=2E=C3=87a=C4=9Flar?= Onur" <caglar@pardus.org.tr>
Reply-To: caglar@pardus.org.tr
Organization: =?utf-8?q?T=C3=9CB=C4=B0TAK_/?= UEKAE
To: linux-kernel@vger.kernel.org
Subject: [2.6.22-rc4] kexec failed: invalid argument
Date: Thu, 14 Jun 2007 21:09:41 +0300
User-Agent: KMail/1.9.7
Cc: ebiederm@xmission.com, horms@verge.net.au
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1327821.llpJdEWha9";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706142109.46027.caglar@pardus.org.tr>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1327821.llpJdEWha9
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi;

With current Linus's git tree + current kexec-tools-testing [1] (also with=
=20
kexec-tools-1.101) tree "kexec -e" call on reboot failed with following;

kexec failed: invalid argument

kexec document says its users responsibility to close running softwares,=20
mounting disks in read only mode etc. and it suggest calling "kexec -e" jus=
t=20
before the "reboot" call and talks about future merge with sysvinit's reboo=
t=20
and kexec, and when i did it, it will not starts new kernel and instead gav=
es=20
that error.

But more supringuisly if i try to execute "kexec -e" directly (in init3 wit=
h=20
rw disks and lots of running software) it will starts new kernel without a=
=20
problem.=20

=46or reference im using following kexec line for loading the kernel
kexec -l /boot/kernel-2.6.22-rc4-CFS-v16 --append=3D"root=3D/dev/sda3" --in=
itrd=3D/boot/initramfs-2.6.22-rc4-CFS-v16

I'm not sure this is a regression or my(maybe me or kexec document misses s=
ome=20
point) mistake cause this is my first attempt to use kexec, but i want to=20
report the situation :)

 [1]=20
http://git.kernel.org/?p=3Dlinux/kernel/git/horms/kexec-tools-testing.git;a=
=3Dsummary

Cheers
=2D-=20
S.=C3=87a=C4=9Flar Onur <caglar@pardus.org.tr>
http://cekirdek.pardus.org.tr/~caglar/

Linux is like living in a teepee. No Windows, no Gates and an Apache in hou=
se!

--nextPart1327821.llpJdEWha9
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iD8DBQBGcYRpy7E6i0LKo6YRAqczAKCyJSiNPtQAYYyMh9DMSfjwL2FR4ACfRq/+
rWAmT0TTQJX0qijkehY17nM=
=YUiN
-----END PGP SIGNATURE-----

--nextPart1327821.llpJdEWha9--
