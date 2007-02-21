Return-Path: <linux-kernel-owner+w=401wt.eu-S965297AbXBUA1y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965297AbXBUA1y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Feb 2007 19:27:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965313AbXBUA1y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Feb 2007 19:27:54 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:56771 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965297AbXBUA1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Feb 2007 19:27:53 -0500
X-Sasl-enc: uMB9GOx45CNo/5mv/TcLFkXomABCdszBaRN9YWduRWht 1172017739
Message-ID: <45DB924F.2010505@imap.cc>
Date: Wed, 21 Feb 2007 01:29:03 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>, kkeil@suse.de,
       i4ldeveloper@listserv.isdn4linux.de
Subject: [PATCH] Remove "obsolete" label from ISDN4Linux (was: any value to
 fixing apparent bugs in old ISDN4Linux?)
References: <Pine.LNX.4.64.0701150634270.1953@CPE00045a9c397f-CM001225dbafb6> <45ABB53C.5030100@imap.cc> <Pine.LNX.4.64.0701151216310.7260@CPE00045a9c397f-CM001225dbafb6> <20070115172912.GA3323@pingi.kke.suse.de>
In-Reply-To: <20070115172912.GA3323@pingi.kke.suse.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC59AFF543B81AC66F4C4D455"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC59AFF543B81AC66F4C4D455
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.01.2007 18:29 schrieb Karsten Keil:
> On Mon, Jan 15, 2007 at 12:17:37PM -0500, Robert P. J. Day wrote:
>> [...] but if
>> it's still in actual use, then it really should be re-labelled from
>> "obsolete" to "deprecated," no?
>=20
> Good point.

May I?

From: Tilman Schmidt <tilman@imap.cc>

Remove incorrect "obsolete" label from ISDN4Linux

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
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigC59AFF543B81AC66F4C4D455
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF25JPMdB4Whm86/kRAvjtAJ91DVffGJcRAV4qyP9j+PxnsJ1SmwCdEHxV
n6to1Om8RlbIBafC+zW7xN0=
=yrhq
-----END PGP SIGNATURE-----

--------------enigC59AFF543B81AC66F4C4D455--
