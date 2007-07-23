Return-Path: <linux-kernel-owner+w=401wt.eu-S1764149AbXGWNZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764149AbXGWNZt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2007 09:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757015AbXGWNZk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jul 2007 09:25:40 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:46205 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbXGWNZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2007 09:25:39 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH 0/5] Dynamically allocated pageflags.
Date: Mon, 23 Jul 2007 23:25:38 +1000
User-Agent: KMail/1.9.6
References: <200707232305.12364.nigel@nigel.suspend2.net>
In-Reply-To: <200707232305.12364.nigel@nigel.suspend2.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1237057.SyK5z3i2Xr";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707232325.38380.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1237057.SyK5z3i2Xr
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Bah.

Sorry for sending it twice. Fun with figuring out Kmail encoding.

Anyway, I forgot to include the stats in the previous message. Here they are.

[   20.667431] Dynpageflags testing...
[   20.667433] Set page 1...Ok.
[   20.667440] Test memory hotplugging #1 ...Ok.
[   20.667442] Test memory hotplugging #2 ...Ok.
[   21.935293] input: AT Translated Set 2 keyboard as /class/input/input1
[   22.188954] Dyn: 98 iterations of setting & clearing all 253935 flags took 152 jiffies.
[   24.584302] Real flags: 98 iterations of setting & clearing all 253935 flags took 240 jiffies.
[   25.644460] Dyn: 25000000 iterations of setting & clearing all one flag took 106 jiffies.
[   25.797906] Real pageflag: 25000000 iterations of setting & clearing all one flag took 15 jiffies.

Nigel

--nextPart1237057.SyK5z3i2Xr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGpKxSN0y+n1M3mo0RAlWPAJ4i2285YRCGwiXTLVLSMN0muyK4ZwCeJDqo
MXfdzvi/mFcI3Gjn/shnOh0=
=1jUj
-----END PGP SIGNATURE-----

--nextPart1237057.SyK5z3i2Xr--
