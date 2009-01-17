Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbZAQS1V@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbZAQS1V (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2009 13:27:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764085AbZAQS1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Jan 2009 13:27:03 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:59509 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762761AbZAQS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2009 13:27:01 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kbuild@vger.kernel.org
Subject: Should EXTRA_FIRMWARE include full path to output directory?
Date: Sat, 17 Jan 2009 21:26:15 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1325630.A9ChXFn69Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901172126.29358.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1325630.A9ChXFn69Y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

{pts/1}% LC_ALL=3DC make -C ~/src/linux-git O=3D$HOME/build/linux-2.6.29
make: Entering directory `/home/bor/src/linux-git'
  Using /home/bor/src/linux-git as source for kernel
ln -fsn /home/bor/src/linux-git source
  GEN     /home/bor/build/linux-2.6.29/Makefile
  CHK     include/linux/version.h
  CHK     include/linux/utsrelease.h
  SYMLINK include/asm -> include/asm-x86
  CALL    /home/bor/src/linux-git/scripts/checksyscalls.sh
  CHK     include/linux/compile.h
/home/bor/src/linux-git/firmware/Makefile:156: warning: overriding commands=
=20
for target `firmware/e100/d101m_ucode.bin.gen.S'
/home/bor/src/linux-git/firmware/Makefile:153: warning: ignoring old=20
commands for target `firmware/e100/d101m_ucode.bin.gen.S'
  AS      firmware/e100/d101m_ucode.bin.gen.o
firmware/e100/d101m_ucode.bin.gen.S: Assembler messages:
firmware/e100/d101m_ucode.bin.gen.S:5: Error: file not found:=20
/home/bor/src/linux-git/firmware/e100/d101m_ucode.bin
make[2]: *** [firmware/e100/d101m_ucode.bin.gen.o] Error 1
make[1]: *** [firmware] Error 2
make: *** [sub-make] Error 2
make: Leaving directory `/home/bor/src/linux-git'
{pts/1}% grep e100 ~/build/linux-2.6.29/.config
CONFIG_EXTRA_FIRMWARE=3D"e100/d101m_ucode.bin"


--nextPart1325630.A9ChXFn69Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAklyIsoACgkQR6LMutpd94xMZwCbBPA1h8HQjWKNFBflqJRrwN4t
wPAAnia0u0B7AHpaSb3RcxjQUAf+43GZ
=Cz6u
-----END PGP SIGNATURE-----

--nextPart1325630.A9ChXFn69Y--
