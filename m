Return-Path: <linux-kernel-owner+w=401wt.eu-S1755841AbYG2CFX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755841AbYG2CFX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2008 22:05:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756292AbYG2CE4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jul 2008 22:04:56 -0400
Received: from SpacedOut.fries.net ([67.64.210.234]:60718 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbYG2CEz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2008 22:04:55 -0400
Date: Mon, 28 Jul 2008 21:04:33 -0500
From: David Fries <david@fries.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Evgeniy Polyakov <johnpol@2ka.mipt.ru>
Subject: [PATCH 0/30] W1: w1 core fixes, ds2490 updates, strong pullup
Message-ID: <20080729020433.GA24424@spacedout.fries.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mP3DRpeJDSE+ciuQ"
Content-Disposition: inline
User-Agent: Mutt/1.5.4i
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-3.0 (SpacedOut.fries.net [127.0.0.1]); Mon, 28 Jul 2008 21:04:39 -0500 (CDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mP3DRpeJDSE+ciuQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

What follows is a long list of fixes and enhancements to the one wire
system, and even some documentation.

I no longer have any deadlocks, a thread was eliminated (along with
its one second wakeup interval), the cpu and time overhead are much
reduced for one wire accesses.  The time for the ds2490 to read a
temperature sensor went from 3.91 seconds (.002s user, 3.001s system)
to 0.860 seconds (0.004s user, 0.004s system).  I also added support
for the strong pullup to provide more current when requested.

Note, only the documentation patch 29 differs from the previous set of
patches sent July 11th.

--=20
David Fries <david@fries.net>
http://fries.net/~david/ (PGP encryption key available)

--mP3DRpeJDSE+ciuQ
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIjnqxAI852cse6PARAuWDAKCro5CverUoDl76pXayU7KCFRe/XwCfY1pp
2CR01qsBO0GkTj6+7teLXuw=
=59Tt
-----END PGP SIGNATURE-----

--mP3DRpeJDSE+ciuQ--
