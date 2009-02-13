Return-Path: <linux-kernel-owner+w=401wt.eu-S1755202AbZBMJeN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755202AbZBMJeN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Feb 2009 04:34:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750705AbZBMJd6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Feb 2009 04:33:58 -0500
Received: from mx3.schottelius.org ([77.109.138.221]:45224 "EHLO
	mx3.schottelius.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZBMJd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Feb 2009 04:33:57 -0500
Date: Fri, 13 Feb 2009 10:33:54 +0100
From: Nico Schottelius <nico-linux-20090213@schottelius.org>
To: LKML <linux-kernel@vger.kernel.org>
Subject: X200: Brightness broken since 2.6.29-rc4-58-g4c098bc
Message-ID: <20090213093354.GA10175@denkbrett.schottelius.org>
Mail-Followup-To: Nico Schottelius <nico-linux-20090213@schottelius.org>,
	LKML <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1yeeQ81UyVL57Vl7"
Content-Disposition: inline
User-Agent: echo $message | gpg -e $sender  -s | netcat mailhost 25
X-Unix-Info: http://unix.schottelius.org/
X-Netzseite: http://nico.schottelius.org/
X-System-Info: ikn (Linux 2.6.29-rc4-ikn-00211-g37bed90 x86_64)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1yeeQ81UyVL57Vl7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello!

When using
  - vmlinuz-2.6.29-rc4-ikn-00058-g4c098bc or
  - vmlinuz-2.6.29-rc4-ikn-00211-g37bed90

the brightness of the LCD is almost off (lowest level),
although kernel reports otherwise:

[10:31] ikn:~% cat /proc/acpi/video/VID/LCD0/brightness=20
levels:  20 25 30 35 40 45 50 55 60 65 70 75 80 85 90 100
current: 100

Changing the brightness via echo 20 > /proc/acpi/video/VID/LCD0/brightness
only changes the value displayed, the display always keeps the same
brightness.

The last time I saw it working was vmlinuz-2.6.29-rc4-ikn-00001-gd5b5623.

Sincerly,

Nico

ps: please CC on reply

--=20
Think about Free and Open Source Software (FOSS).
http://nico.schottelius.org/documentations/foss/the-term-foss/

PGP: BFE4 C736 ABE5 406F 8F42  F7CF B8BE F92A 9885 188C

--1yeeQ81UyVL57Vl7
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkmVPoEACgkQuL75KpiFGIw2+QCgoCDrx6txU60mdytoHzLoYZ/i
Xp8AnA7YYTg1F+iVAg/xg2UvmcwhOerX
=cTrM
-----END PGP SIGNATURE-----

--1yeeQ81UyVL57Vl7--
