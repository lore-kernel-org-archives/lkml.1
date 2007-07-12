Return-Path: <linux-kernel-owner+w=401wt.eu-S933205AbXGLOve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205AbXGLOve (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2007 10:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756507AbXGLOv2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jul 2007 10:51:28 -0400
Received: from moutng.kundenserver.de ([212.227.126.188]:57373 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752863AbXGLOv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2007 10:51:27 -0400
Message-ID: <46963FDD.9010900@arcor.de>
Date: Thu, 12 Jul 2007 16:51:09 +0200
From: Sascha Hlusiak <saschahlusiak@arcor.de>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Manually invoke IPv6 router solicitation messages
X-Enigmail-Version: 0.95.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5CA497F56A4FED585E029E2D"
X-Provags-ID: V01U2FsdGVkX1+fR0CmpkQBSST16Lzs957JM8nQnW/xVs0wCp9
 Tqmi2A2R/Pdp1rxcG6sd1Lb6jOcy9RgX/whnIIZvpi0COgXq88
 r4hKeWmKJsRVwNQOrdr2w==
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5CA497F56A4FED585E029E2D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Is there a way to manually make the kernel send IPv6 router solicitation
messages? At the moment the kernel will send a few messages after the
interface is brought up and then never again, no matter if it succeeded
or failed to autoconf the device.

Background:
I use wpa_supplicant to connect to wireless and I use ifplugd/netplug to
manage my wired network.
Both tools bring the interface up and immediately the kernel tries to
autoconfigure them, even the cable is not plugged in or the wireless
connection is not yet established. When the connection is finally
brought up, the autoconfig already failed and I have to wait until the
router is so nice to send a router advertisement message by itself.

Does it make sense to have a syscall or /proc entry that makes the
kernel send such a message, or do you suggest having a userspace tool to
send those messages when needed?


Sascha Hlusiak


(Please CC me, since I'm off-list)



--------------enig5CA497F56A4FED585E029E2D
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.5 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGlj/iOyDtNneHFrMRAiSRAKCXikS9B9hFXikoRHPhtHRA+6ADvgCcCr2u
we7KaDQOa3l3zbdtL1i0g1g=
=w8C+
-----END PGP SIGNATURE-----

--------------enig5CA497F56A4FED585E029E2D--
