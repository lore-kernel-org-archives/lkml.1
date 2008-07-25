Return-Path: <linux-kernel-owner+w=401wt.eu-S1755574AbYGYJMX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574AbYGYJMX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 05:12:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753547AbYGYJMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 05:12:14 -0400
Received: from mail.gmx.net ([213.165.64.20]:49995 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753002AbYGYJMO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 05:12:14 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/Wh24bu5bWp2brEmDxDaPXX2MajFhgzp6cphsyQV
	ywEINlIc1VyWA5
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: linux-kernel@vger.kernel.org
Subject: commit a352def21a642 breaks UML
Date: Fri, 25 Jul 2008 11:12:08 +0200
User-Agent: KMail/1.9.9
Cc: alan@redhat.com, Jeff Dike <jdike@addtoit.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart10407095.Jirbiz3eSH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200807251112.10765.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart10407095.Jirbiz3eSH
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hello,

that commit produces a make error at my system:

=2E..
  CC      arch/um/drivers/line.o
arch/um/drivers/line.c: In function 'line_write_interrupt':
arch/um/drivers/line.c:366: error: 'struct tty_ldisc' has no member named '=
write_wakeup'
arch/um/drivers/line.c:367: error: 'struct tty_ldisc' has no member named '=
write_wakeup'
make[1]: *** [arch/um/drivers/line.o] Error 1
make: *** [arch/um/drivers] Error 2

=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart10407095.Jirbiz3eSH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)

iEYEABECAAYFAkiJmOoACgkQhyrlCH22naMp5gCeOayZZOwfLY/5QPg/wwg9BlpV
mYMAnAsmAhhazWclNVrFDryJPoffd/xz
=ace+
-----END PGP SIGNATURE-----

--nextPart10407095.Jirbiz3eSH--
