Return-Path: <linux-kernel-owner+w=401wt.eu-S2993373AbXEBPdy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993373AbXEBPdy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 11:33:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2993375AbXEBPdy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 11:33:54 -0400
Received: from smtpout.hostsharing.net ([83.223.95.15]:58574 "EHLO
	smtpout.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993373AbXEBPdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 11:33:53 -0400
X-Greylist: delayed 1978 seconds by postgrey-1.27 at vger.kernel.org; Wed, 02 May 2007 11:33:53 EDT
Subject: [PATCH] kernel option CONFIG_USB_HIDINPUT_POWERBOOK description
	update
From: =?ISO-8859-1?Q?No=E8l_K=F6the?= <noel@debian.org>
To: linux-usb-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-xput9P+1oRZSuTRGSpSw"
Organization: Debian GNU/Linux, www.debian.org
Date: Wed, 02 May 2007 17:00:15 +0200
Message-Id: <1178118015.4820.26.camel@mbp.domain.lan>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.1 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-xput9P+1oRZSuTRGSpSw
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hello together,

The description of this option needs to be extended to be correct:)

--- /usr/src/linux-2.6.21/drivers/usb/input/Kconfig     2007-04-27 18:02:46=
.000000000 +0200
+++ Kconfig.new 2007-05-02 16:47:56.000000000 +0200
@@ -28,12 +28,12 @@
        depends on USB_HID && INPUT=3Dn
=20
 config USB_HIDINPUT_POWERBOOK
-       bool "Enable support for iBook/PowerBook special keys"
+       bool "Enable support for iBook/PowerBook/MacBook/MacBookPro special=
 keys"
        default n
        depends on USB_HID
        help
          Say Y here if you want support for the special keys (Fn, Numlock)=
 on
-         Apple iBooks and PowerBooks.
+         Apple iBooks, PowerBooks, MacBooks and MacBook Pro's.
=20
          If unsure, say N.

This option is needed on the Apple Intel Laptops, too.
I would suggest to rename USB_HIDINPUT_POWERBOOK because its needed on Appl=
e Laptops.
Maybe USB_HIDINPUT_APPLELAPTOPS or something like this. Is a renaming patch=
 for this welcome?

Thanks for your answer/applying.:)

--=20
No=C3=A8l K=C3=B6the <noel debian.org>
Debian GNU/Linux, www.debian.org

--=-xput9P+1oRZSuTRGSpSw
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGOKd/9/DnDzB9Vu0RAkJkAJ9Q8/zemsWSMO6Al9nEdjyKXb9vvACeL7K4
p1j2x9DiaDli9chtOZm4xnM=
=9Jm1
-----END PGP SIGNATURE-----

--=-xput9P+1oRZSuTRGSpSw--

