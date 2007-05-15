Return-Path: <linux-kernel-owner+w=401wt.eu-S1759922AbXENWDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759922AbXENWDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbXENWDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:03:12 -0400
Received: from moutng.kundenserver.de ([212.227.126.183]:49876 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751187AbXENWDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:03:11 -0400
From: Hubertus Grobbel <hubertus@grobbel.net>
To: Linux List <linux-kernel@vger.kernel.org>
Subject: O_DIRECT for FAT
Date: Tue, 15 May 2007 01:02:51 +0100
User-Agent: KMail/1.9.5
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1240943.f1y4PAg3eh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705150103.02398.hubertus@grobbel.net>
X-Provags-ID: V01U2FsdGVkX188MQMhFEG9wyg3qKkmNfH60bz7k3flSt5GzFV
 3AugXEjJhbK4YejxjEoLAYYME/ELAQRq0biTZZwRN++9/sWHGN
 GfIyvKfg0kCybs9oiPHIK0Ri4qNDhqc
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1240943.f1y4PAg3eh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi,

I found out, that the option O_DIRECT for opening a file on a fat-
filesystem successfully completes. But reading and writing to that
file leads to EINVAL errors (using kernel 2.6.18).

I would like to access on certain files on a flash-disk without cache
usage, whereas the rest of the filesystem shall be accessed normally/cached.
I am aware of the previous discussion. My application is not targetting on =
a=20
pure file usage (I can live with the existing features for that), but also=
=20
for a side-channel IO to interact with the device.=20

Do you see a way to solve my problem by any workaround? Is O_DIRECT
support for fat-fs feasible in future?

Grateful for any response.

Thanks in advance
Hubi

--nextPart1240943.f1y4PAg3eh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGSPi1AB1de4oeNLkRAibcAJ9+pKpbuWA7V16ecDbfuWwT8lkMuQCfd/fK
z4+iwwh6vg71N7ytoJGIoSU=
=uC/5
-----END PGP SIGNATURE-----

--nextPart1240943.f1y4PAg3eh--
