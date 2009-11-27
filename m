Return-Path: <linux-kernel-owner+w=401wt.eu-S1754495AbZK0OKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495AbZK0OKm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Nov 2009 09:10:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752284AbZK0OKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Nov 2009 09:10:41 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:36874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbZK0OKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Nov 2009 09:10:41 -0500
Subject: Re: [Bug #14352] WARNING: at net/mac80211/scan.c:267
From: Johannes Berg <johannes@sipsolutions.net>
To: Sebastian Ott <sebott@linux.vnet.ibm.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
In-Reply-To: <alpine.LFD.2.00.0911271438340.3429@localhost>
References: <GUZt44bIwCE.A.vLF.pSdALB@chimera>
	 <xXQGFmujPl.A.o1.bUdALB@chimera>
	 <8db1092f0911162204i36dbd472w1d2c88411e151acb@mail.gmail.com>
	 <200911172319.49198.rjw@sisk.pl>
	 <alpine.LFD.2.00.0911271438340.3429@localhost>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-cTylexAlDVI3DKO6R6eY"
Date: Fri, 27 Nov 2009 15:10:34 +0100
Message-ID: <1259331034.5428.19.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cTylexAlDVI3DKO6R6eY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-27 at 14:46 +0100, Sebastian Ott wrote:

> [ 5724.754068] iwl3945 0000:03:00.0: Error sending REPLY_SCAN_CMD: time=20
> out after 500ms.

That tells you there's something wrong with the device -- and maybe the
driver is misbehaving by telling mac80211 that it couldn't scan but then
still calling scan_completed().

In any case, driver bug as far as I can tell.

johannes

--=-cTylexAlDVI3DKO6R6eY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJLD93XAAoJEODzc/N7+Qma8X0P/1DfjfPk6uTCNM2FKDrSISeB
cSbofmtR55rBSrgbR4fiy4jftjpoa2hSVWQoTjmZ/5m1vJRiIAkqPUG7rZ/FIIND
X704I+oe/0TfCbuhk56lO+5lo0OpdScZItMK8ZeXgPOJkbzElm2+5wPLdSClXeh/
HQNCzkRhcelqc8fejOQ2VLhopJrx7Kf/xuJCTf2ACbx16lVPyPa8yNQ477J+/KtV
D+lARzdXmKsk52pm0CzyMtXdaJGVYwDrFxmxX0DLfiSW8EenK+DmJVY3Pk/oZw8W
lOjYq3c+vkNHfBVsIf7MeMHbjPahYtZAmWCLmO9Yv7YfewYST1BBQQqq8ZKSN9X6
uYDrx/0fiSUeCRbcYmdycjNTQ6jT39sVtAQWIGADe2bFg9YMZ6kvzeLYPwpVNdL7
3OLUYo4t8yJKc/lFX7/qRPkgDQ3Mbv6Ne5IXFHZsUUPybJutvftek8LD1zsuO7hN
knnLkdEFvD3Ozs0iLanVT+iwR6pymn04e/NoCLBQGcWKtDLR2ElCE6B592M8BtJ2
3MFnM6PZ5IRD4oj5Yhs0kFctE4AG/rvUbXHJweiTs/z3rmixagMKUazeQ7ZI9i5q
ZYfkbh908f+75wlsxm5JPUmu5XFHqKVz1ErlMf3Vi9D7VWEeoouj6ylYgZsqYR/P
BvsUOQdxptVrfOnc3+2y
=OGMK
-----END PGP SIGNATURE-----

--=-cTylexAlDVI3DKO6R6eY--

