Return-Path: <linux-kernel-owner+w=401wt.eu-S1753205AbYLJLcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753205AbYLJLcS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2008 06:32:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751127AbYLJLcH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Dec 2008 06:32:07 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:43505 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750761AbYLJLcF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2008 06:32:05 -0500
Date: Wed, 10 Dec 2008 12:32:03 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Suspend on X200 works on 2.6.28-rc6, but not -rc7
Message-ID: <20081210113203.GB11869@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DKU6Jbt7q3WqK7+M"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc6-wl-denkbrett-21906-g24e8b9a x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DKU6Jbt7q3WqK7+M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

What the last next-trees already showed is now confirmed in -rc7:
Suspend works, on resume the system freezes (screen is partly drawn).

Xorg is always running, without xorg it works on most of the recent kernels.

Working version:

2.6.28-rc6
2.6.28-rc6-wl-21906-g24e8b9a (running this right now)

Crashing versions (at least):

next-20081125
next-20081127
next-20081201
next-20081202
2.6.28-rc7

Just wondering what happened between those versions that it does not work a=
nymore.

Sincerly,

Nico

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--DKU6Jbt7q3WqK7+M
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkk/qLMACgkQuL75KpiFGIyeVQCfesIJeGm8VDdwK82DpRnBqaqt
OkUAoL5KmSf6iOqQ645k2uxfn+RhBVCX
=PiDm
-----END PGP SIGNATURE-----

--DKU6Jbt7q3WqK7+M--
