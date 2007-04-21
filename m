Return-Path: <linux-kernel-owner+w=401wt.eu-S1751024AbXDUNFR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751024AbXDUNFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Apr 2007 09:05:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753510AbXDUNFR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Apr 2007 09:05:17 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:55265 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024AbXDUNFP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Apr 2007 09:05:15 -0400
X-Sasl-enc: GBePpw3CoWEvbklUVsaTrs0hU0cUgDQBfNpvd+vcIGZR 1177160715
Message-ID: <462A0CA7.2090908@imap.cc>
Date: Sat, 21 Apr 2007 15:07:51 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Remove "obsolete" label from ISDN4Linux (v3)
References: <Pine.LNX.4.64.0701150634270.1953@CPE00045a9c397f-CM001225dbafb6> <45ABB53C.5030100@imap.cc> <Pine.LNX.4.64.0701151216310.7260@CPE00045a9c397f-CM001225dbafb6> <20070115172912.GA3323@pingi.kke.suse.de>
In-Reply-To: <20070115172912.GA3323@pingi.kke.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig9BFAF6EBC1D1D5616AF5507E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig9BFAF6EBC1D1D5616AF5507E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Tilman Schmidt <tilman@imap.cc>

The "obsolete" label on the ISDN_I4L Kconfig option is not, and
has never been, accurate. It has already prompted repeated attempts
to remove actively used functionality from the kernel without a
working replacement. This patch removes the incorrect label and
corrects the accompanying help text.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

--- a/drivers/isdn/Kconfig	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/isdn/Kconfig	2007-04-21 14:48:54.000000000 +0200
@@ -25,9 +25,9 @@ menu "Old ISDN4Linux"
 	depends on NET && ISDN

 config ISDN_I4L
-	tristate "Old ISDN4Linux (obsolete)"
+	tristate "Old ISDN4Linux subsystem"
 	---help---
-	  This driver allows you to use an ISDN-card for networking
+	  This driver allows you to use an ISDN adapter for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
 	  in AT-compatible modem emulator.  Network devices support autodial,
 	  channel-bundling, callback and caller-authentication without having
@@ -38,8 +38,9 @@ config ISDN_I4L

 	  ISDN support in the linux kernel is moving towards a new API,
 	  called CAPI (Common ISDN Application Programming Interface).
-	  Therefore the old ISDN4Linux layer is becoming obsolete. It is
-	  still usable, though, if you select this option.
+	  Therefore the old ISDN4Linux layer will eventually become obsolete.
+	  It is still available, though, for use with adapters that are not
+	  supported by the new CAPI subsystem yet.

 if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
In theory, there is no difference between theory and practice.
In practice, there is.


--------------enig9BFAF6EBC1D1D5616AF5507E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGKgynMdB4Whm86/kRAmnUAJ9bNVo55dViBt4VxNt4S30/GLEB0ACfS0WG
y73kYX9nlPBgKfWMvtkH9os=
=YZsk
-----END PGP SIGNATURE-----

--------------enig9BFAF6EBC1D1D5616AF5507E--
