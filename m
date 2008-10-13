Return-Path: <linux-kernel-owner+w=401wt.eu-S1760786AbYJMKSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786AbYJMKSV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2008 06:18:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932449AbYJMKN4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Oct 2008 06:13:56 -0400
Received: from postman.teamix.net ([194.150.191.120]:42149 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762576AbYJMKNy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2008 06:13:54 -0400
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: tuxonice-devel@lists.tuxonice.net, linux-kernel@vger.kernel.org
Subject: safe resuming: automatically invalidating an outdated hibernate snapshot
Date: Mon, 13 Oct 2008 12:13:45 +0200
User-Agent: KMail/1.9.9
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart12128081.gHDvybuEXQ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810131213.51317.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart12128081.gHDvybuEXQ
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Cc to linux-kernel: This is mainly for tuxonice, but it might also be relev=
ant=20
for other hibernate implementations. Maybe some general mechanism for=20
checking whether an on disk snapshot of the system is current would be good=
 -=20
as also the resume parameter could be missing or wrong or whatnot.


Hi!

Is there a way to automatically invalidate the tuxonice snapshot when a non=
=20
tuxonice kernel is booted accidentally? I.e. could tuxonice recognize when=
=20
the swap partition has been accessed *after* the snapshot has been written?

It happened here several times that someone booted the wrong kernel and the=
n=20
someone else booted the right one again. TuxOnIce would then resume from a=
=20
snapshot that it not up-to-date anymore. This leads to filesystem breakage =
as=20
the filesystem slab objects and other in memory structures would not=20
represent the current state of the filesystem on disk. xfs_repair did a=20
marvellous job on these occassions and I already changed menu.lst to hide t=
he=20
GRUB boot menu by default, but it would be better if this case of =20
maloperation can be intercepted.

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart12128081.gHDvybuEXQ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjzH1oACgkQHhDFkwOZrpBfiwCfW0h0DgHJI1YxFMRk+1Z1xaaL
pLcAn3h7g8VHJHbI1YGS18K6/ddWorZ6
=r5e+
-----END PGP SIGNATURE-----

--nextPart12128081.gHDvybuEXQ--
