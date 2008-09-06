Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbYIFHIs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbYIFHIs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2008 03:08:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752040AbYIFHIk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Sep 2008 03:08:40 -0400
Received: from mx38.mail.ru ([194.67.23.16]:56512 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751929AbYIFHIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2008 03:08:39 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: toshiba_acpi@memebeam.org, linux-acpi@vger.kernel.org
Subject: ACPI video.c brightness handler conflicts with toshiba_acpi
Date: Sat, 6 Sep 2008 11:08:33 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2252413.r5CaEfOAYS";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809061108.34877.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2252413.r5CaEfOAYS
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

I have now two different devices that refer to the same hardware:

lrwxrwxrwx 1 root root 0 2008-09-06 11:04 acpi_video0 -> ../../devices/virtual/backlight/acpi_video0/
lrwxrwxrwx 1 root root 0 2008-09-06 11:04 toshiba -> ../../devices/virtual/backlight/toshiba/

Unfortunately, due to ACPI implementation the acpi_video0 one is much
inferior (as it provides only effectively two levels instead of 8);
and user level tools are apparently quite confused which one to select.

Is there any mechanism that would allow tochiba_acpi to claim brightness
for internal LCD screen that video would not attempt to grab it too?

Of course manually disabling brightness handling in video is always possible,
still is nice for this to be handled automatically.

--nextPart2252413.r5CaEfOAYS
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjCLHIACgkQR6LMutpd94xXFQCglGVBpMj9Zdu9E38vRrUY/Yex
300AoLJS3yQgCd9nNK1FjXJcHdgLeTyC
=An21
-----END PGP SIGNATURE-----

--nextPart2252413.r5CaEfOAYS--
