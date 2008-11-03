Return-Path: <linux-kernel-owner+w=401wt.eu-S1754889AbYKCIKq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889AbYKCIKq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 03:10:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754548AbYKCIKh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 03:10:37 -0500
Received: from mx6.mail.ru ([194.67.23.26]:20291 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754453AbYKCIKg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 03:10:36 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: USB list <linux-usb@vger.kernel.org>
Subject: 2.6.28-rc3: usb_hcd_poll_rh_status: array subscript is above array bounds
Date: Mon, 3 Nov 2008 11:10:29 +0300
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart122575260.e37YCUGl8D";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200811031110.31115.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart122575260.e37YCUGl8D
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

  CC [M]  drivers/usb/core/hcd.o
/home/bor/src/linux-git/drivers/usb/core/hcd.c: In function =E2=80=98usb_hc=
d_poll_rh_status=E2=80=99:
/home/bor/src/linux-git/arch/x86/include/asm/string_32.h:75: warning: array=
 subscript is above array bounds

It is likely that issue is actually in string_32.h as similar errors are
in oher places as well.

--nextPart122575260.e37YCUGl8D
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkOsfYACgkQR6LMutpd94w52ACgt1hXFMIqlpw1fXOuLxXywby0
cNkAoIMBsYOf7ii+ANT0XtX8XYKe/D6s
=J33l
-----END PGP SIGNATURE-----

--nextPart122575260.e37YCUGl8D--
