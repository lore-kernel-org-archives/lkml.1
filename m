Return-Path: <linux-kernel-owner+w=401wt.eu-S965781AbXC1Wy0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965781AbXC1Wy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 18:54:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965773AbXC1WyZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 18:54:25 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:36245 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965781AbXC1WyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 18:54:24 -0400
X-Sasl-enc: TZ+9YeEVbKiON94nQ0pmCEgyl5mrPITFkWeMffL51e/4 1175120170
Message-ID: <460AE9A4.70905@imap.cc>
Date: Thu, 29 Mar 2007 00:18:12 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: [Repost][PATCH] Remove "obsolete" label from ISDN4Linux
References: <Pine.LNX.4.64.0701150634270.1953@CPE00045a9c397f-CM001225dbafb6> <45ABB53C.5030100@imap.cc> <Pine.LNX.4.64.0701151216310.7260@CPE00045a9c397f-CM001225dbafb6> <20070115172912.GA3323@pingi.kke.suse.de>
In-Reply-To: <20070115172912.GA3323@pingi.kke.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6FD796A30DCA926FB0175473"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6FD796A30DCA926FB0175473
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

From: Tilman Schmidt <tilman@imap.cc>

Remove incorrect "obsolete" label from ISDN4Linux.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

--- a/drivers/isdn/Kconfig	2006-11-29 22:57:37.000000000 +0100
+++ b/drivers/isdn/Kconfig	2007-02-21 01:19:19.000000000 +0100
@@ -25,7 +25,7 @@ menu "Old ISDN4Linux"
 	depends on NET && ISDN

 config ISDN_I4L
-	tristate "Old ISDN4Linux (obsolete)"
+	tristate "Old ISDN4Linux subsystem"
 	---help---
 	  This driver allows you to use an ISDN-card for networking
 	  connections and as dialin/out device.  The isdn-tty's have a built
@@ -38,8 +38,8 @@ config ISDN_I4L

 	  ISDN support in the linux kernel is moving towards a new API,
 	  called CAPI (Common ISDN Application Programming Interface).
-	  Therefore the old ISDN4Linux layer is becoming obsolete. It is
-	  still usable, though, if you select this option.
+	  The old ISDN4Linux layer is still available for use with cards
+	  that are not supported by the new CAPI subsystem yet.

 if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
In theory, there is no difference between theory and practice.
In practice, there is.


--------------enig6FD796A30DCA926FB0175473
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGCumkMdB4Whm86/kRAtTSAJ9UM2FDMLCeRogp8mRgjCtgUAh1KgCfYxyL
PLI7cDCtr6JW5QbMUNBSFGA=
=dli0
-----END PGP SIGNATURE-----

--------------enig6FD796A30DCA926FB0175473--
