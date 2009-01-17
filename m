Return-Path: <linux-kernel-owner+w=401wt.eu-S1762746AbZAQQJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762746AbZAQQJE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 11:09:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757213AbZAQQIg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 11:08:36 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:43958 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762818AbZAQQIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 11:08:34 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: e1000-devel@lists.soutceforge.net, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: [2.6.29-rc2 regression] e100: netconsole not functional because of missing firmware
Date: Sat, 17 Jan 2009 19:08:25 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2731052.VCk4V9YsH4";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901171908.28533.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2731052.VCk4V9YsH4
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

[    1.958127] e100 0000:00:0a.0: PCI INT A -> Link[LNKD] -> GSI 11=20
(level, low)
 -> IRQ 11
[    1.986079] e100 0000:00:0a.0: PME# disabled
[    1.987930] e100: eth0: e100_probe: addr 0xf7efd000, irq 11, MAC addr=20
00:00:39:d7:14:a1
[    1.989358] netconsole: local port 6665
[    1.989848] netconsole: local IP 10.0.0.1
[    1.990427] netconsole: interface eth0
[    1.990895] netconsole: remote port 6666
[    1.991382] netconsole: remote IP 10.0.0.2
[    1.991890] netconsole: remote ethernet address 00:17:42:21:27:e4
[    1.992680] netconsole: device eth0 not up yet, forcing it
[    2.008509] e100: eth0: e100_request_firmware: Failed to load=20
firmware "e100/d101m_ucode.bin": -22
[    2.010461] netconsole: failed to open eth0
[    2.010996] netconsole: cleaning up

This has been working all the time without requiring any external=20
firmware to be present. Why it suddenly refuses to work now?


--nextPart2731052.VCk4V9YsH4
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklyAnwACgkQR6LMutpd94xQzgCfbRkub0iY10Od/4WBW95ahIvg
P/EAoLUI8uXRsnZS3ykKEY5baSpr5giQ
=jczN
-----END PGP SIGNATURE-----

--nextPart2731052.VCk4V9YsH4--
