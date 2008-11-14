Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYKNNkg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYKNNkg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 08:40:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYKNNkY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 08:40:24 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:56390 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbYKNNkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 08:40:23 -0500
Date: Fri, 14 Nov 2008 12:54:51 +0100
From: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>
To: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: 2.6.28-rc4 suspend issues on Lenovo X200
Message-ID: <20081114115451.GB4877@denkbrett.schottelius.org>
Mail-Followup-To: Nico -telmich- Schottelius <nico-linux-next@schottelius.org>,
	linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="i0/AhcQY5QxfSsSZ"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.28-rc4-denkbrett x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--i0/AhcQY5QxfSsSZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

Using 2.6.28-rc4 and *NO* acpi_sleep=3Ds3_bios:

   - suspend and wakeup on console works (!)
      -> this is new, before screen was black after wakeup
   - suspend on x11 works
     wakeup on x11 freezes, causes automatic reboot
   - switch away from x11 to console,
     suspend on console:
         wakeup -> works
         switch to x11 -> freeze & reboot

It would be nice, if someone could CC me to

   'nico-linux-lenovox200-suspend at schottelius.org'

if there is some progress made. Currently it's just getting
me tired always having to fsck the filesystem after a suspend
try.

Sincerly,

Nico


--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--i0/AhcQY5QxfSsSZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkdZwsACgkQuL75KpiFGIwQQQCg4YfiAsOSBaOhOWMZd30kLpOw
Xu8AoOzKqR3Bfg4YaUipWoe6mUa9EwVQ
=Sxya
-----END PGP SIGNATURE-----

--i0/AhcQY5QxfSsSZ--
