Return-Path: <linux-kernel-owner+w=401wt.eu-S1761277AbZAGTgj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761277AbZAGTgj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 14:36:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757133AbZAGTga
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 14:36:30 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:44176 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755544AbZAGTg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 14:36:29 -0500
Date: Wed, 7 Jan 2009 20:35:59 +0100
From: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Cc: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>
Subject: Suspend issues on all latest kernels!
Message-ID: <20090107193559.GA4306@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-20090106@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Suspend fails on Lenovo X200 with

  - 2.6.28-next-20090107-ikn
  - 2.6.28-ikn-06859-gede6f5a

When doing echo mem > /sys/power/state, the
"Suspending consoles..." message appears, the "moon" is blinking,
but the system stays in this state (waited 10 minutes) forever.

At least -next is broken for a longer time (see previous posts on
linux-next).

Now the -wl tree also gained a suspend problem:

With

  - 2.6.28-rc9-wl-ikn-24949-ge98df74

I can suspend (!) and even wake up, but the display is black
(xorg and console) with some strange drawn columns.

Tha last known working version is

  - 2.6.28-rc9-wl-denkbrett-24896-gf4f5c96

Can somebody fix that so upgrading and testing
to a newer kernel is possible again?

Sincerly,

Nico

P.S.: -ikn or -denkbrett is just the hostname; kernels are not patched,
      directly fetched via git.


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkllBB8ACgkQuL75KpiFGIyKZgCg68V0byVow9+Du0UQRpgRvEh+
pn8An1PJ7gIZvcD5htDLK8THVQ0f4owL
=uoFj
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--
