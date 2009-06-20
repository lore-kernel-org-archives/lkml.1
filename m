Return-Path: <linux-kernel-owner+w=401wt.eu-S1753805AbZFTJi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753805AbZFTJi3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jun 2009 05:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750836AbZFTJiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Jun 2009 05:38:21 -0400
Received: from mx4.mail.ru ([94.100.176.18]:24684 "EHLO mx4.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZFTJiU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jun 2009 05:38:20 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: Number of open files scalability?
Date: Sat, 20 Jun 2009 13:32:47 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-2mnb; KDE/4.2.90; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1733811.ZDn1R8zzzZ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906201332.51953.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1733811.ZDn1R8zzzZ
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,

we have a customer that requires large number of open files. Basically,=20
it is SAP with large Oracle database with relatively large number of=20
concurrent connections from worker processes. Right now the amount=20
permanently opened files is above 128000; with current trends of DB and=20
load growth it could easily rocket up to and above of 1000000.

So the questions are

=2D is there any per-process or per-user limit for number of open files=20
imposed by kernel (except of course set by rlimits)?

=2D is there any fs/file-max limit except imposed by data type (int)?

=2D finally, how scalable is the implementation? Will having one million=20
of open files impose any noticeable slowdown? If yes, what operations=20
are affected? I.e. opening new files/creating new process is not that=20
important; but having to search 1000000 files for every operation would=20
be fatal.

The platform is x86_64, SLES 9 with likely update to SLES10.

Thank you!

=2Dandrey

--nextPart1733811.ZDn1R8zzzZ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko8rMAACgkQR6LMutpd94wnqQCgg7qbZcJSnQmFNreKaLxskEjO
l8MAniiqGfsuKr/xQ06+zL0xMU6Hm5or
=lkky
-----END PGP SIGNATURE-----

--nextPart1733811.ZDn1R8zzzZ--
