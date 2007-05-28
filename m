Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbXE1Q3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbXE1Q3j (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756991AbXE1Q3b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:29:31 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60543 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750746AbXE1Q3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:29:30 -0400
X-Sasl-enc: M/bP6J+vZcer3dy+13nHPvP0RKIaxw+eiq93Ww10IbwT 1180369769
Message-ID: <465B0438.60203@imap.cc>
Date: Mon, 28 May 2007 18:32:56 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Linux kernel mailing list <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] ISDN4Linux: fix maturity label (v4)
References: <Pine.LNX.4.64.0701150634270.1953@CPE00045a9c397f-CM001225dbafb6> <45ABB53C.5030100@imap.cc> <Pine.LNX.4.64.0701151216310.7260@CPE00045a9c397f-CM001225dbafb6> <20070115172912.GA3323@pingi.kke.suse.de>
In-Reply-To: <20070115172912.GA3323@pingi.kke.suse.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CFA9EB02C8D1EC08DFE53CA"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CFA9EB02C8D1EC08DFE53CA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Seeing that the discussion about this has ebbed out but the last version
of this patch has disappeared again from the -mm tree, permit me another
attempt to get this fixed:

From: Tilman Schmidt <tilman@imap.cc>

According to the definitions recently posted on LKML, the maturity label
for the ISDN4Linux subsystem is wrong. This patch corrects it and also
clarifies the accompanying help text a bit.

Signed-off-by: Tilman Schmidt <tilman@imap.cc>

---

--- a/drivers/isdn/Kconfig	2007-02-04 19:44:54.000000000 +0100
+++ b/drivers/isdn/Kconfig	2007-05-28 14:48:54.000000000 +0200
@@ -25,9 +25,9 @@ menu "Old ISDN4Linux"
 	depends on NET && ISDN

 config ISDN_I4L
-	tristate "Old ISDN4Linux (obsolete)"
+	tristate "Old ISDN4Linux (deprecated)"
 	---help---
-	  This driver allows you to use an ISDN-card for networking
+	  This subsystem allows you to use an ISDN adapter for networking
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




--------------enig5CFA9EB02C8D1EC08DFE53CA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGWwQ4MdB4Whm86/kRAv6EAJ0a7tyJXcCXVsv0Y5p5cDLri85DqQCeIDla
HMtHvXgXGDaeR26sXU705TQ=
=KwFz
-----END PGP SIGNATURE-----

--------------enig5CFA9EB02C8D1EC08DFE53CA--
