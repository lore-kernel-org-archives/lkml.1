Return-Path: <linux-kernel-owner+w=401wt.eu-S1754746Ab0ALUUu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab0ALUUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 15:20:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754206Ab0ALUUt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 15:20:49 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56925 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754191Ab0ALUUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 15:20:49 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: linux-kernel@vger.kernel.org
Subject: unable to build util-linux-2.17 on glibc-2.10 due to fallocate64
Date: Tue, 12 Jan 2010 15:20:55 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.32.2; KDE/4.3.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2029577.Mfj6NGZ0te";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201001121520.55886.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2029577.Mfj6NGZ0te
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

glibc-2.10 has an error in it where it forgot to export the fallocate64 sym=
bol=20
for 32bit users.  the current util-linux configure script does a link test =
for=20
fallocate, but this is the same thing as the fallocate code which uses a bu=
nch=20
of defines when including the prototypes and so it ends up linking to=20
fallocate64.  long story short, util-linux fails to build on 32bit glibc-2.=
10=20
systems.  any ideas on how to address this ?  a link time test for fallocat=
e64=20
would suck as it only gets used on 32bit linux hosts ...
=2Dmike

--nextPart2029577.Mfj6NGZ0te
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLTNmnAAoJEEFjO5/oN/WBQPIQAMpT7O3mF/JoxbXOQUcgMeBz
wNxDDTAXtdY51izTmr4JX/e0XdZsH2XyhL3k9uTvpDyZyp1qAJRNXXgP2UylVtqn
12s+HFkkKkoOmhrz/xuiAwHue5IzasEIaFaiOn/cWfY+Rjhes4wg8E6EqymQX6Vz
hLzylvyAaOrKFsC5d1vgT/9wdRjytTMdOI721DKR3/Rn8YXNHUHitVR9tsz8cnZr
Wrs4Hieaw9LYhXPKFdFCjI5dS21dAqJp9BwaMhQjyUosUM5STEjSaF/iPNZSpnOT
kQv7zuz5U6lx1K3UWl8fhfXK69Um2yoWty40dJsqBTZfm8Mu0sICwT7C/1FAqjFY
sR8tHg2i25P3+NP8Tf74Y5ME0qpjmQNJQH4h7bf/Ol5yWum3d788JwBknuIDrZxc
8DFgpC5ONhPm65jFDEaqo+aArSsWhZbdh+mYUDXROboa+qsTas1MELplmJHHI9dM
SJ0Rq513otfzc81/DSYsuUPxasIbrAmqnEsV/D4J2wwnEwNsdCy3PDND0AtKRgYy
YYMll2TPBvMrL6KYvf4fZkFMzqNnJvS8+mCMeqggwIEfG9o2zqZ9FvqUZcD7LZHj
qGeTQw8nw64CM24DVBiznX7a4lGur32ICrb1ZV9dC49yVGzSSpX/48zcvXO9RZZh
k00HLoMcW0ddQpum6R2b
=1r1j
-----END PGP SIGNATURE-----

--nextPart2029577.Mfj6NGZ0te--
