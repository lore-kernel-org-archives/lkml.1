Return-Path: <linux-kernel-owner+w=401wt.eu-S1755996AbZFUHw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755996AbZFUHw1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 03:52:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750902AbZFUHwT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 03:52:19 -0400
Received: from mx38.mail.ru ([94.100.176.52]:56307 "EHLO mx38.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750835AbZFUHwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 03:52:18 -0400
X-Greylist: delayed 80368 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2009 03:52:18 EDT
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-kernel@vger.kernel.org
Subject: Why half of slabs are not shown in /proc/slabinfo?
Date: Sun, 21 Jun 2009 11:52:20 +0400
User-Agent: KMail/1.11.90 (Linux/2.6.30-desktop-2mnb; KDE/4.2.90; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6392455.d0U59A7uQp";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200906211152.25100.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: Ok
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6392455.d0U59A7uQp
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Mandriva kernel 2.6.30 using SLUB:

{pts/1}% grep SLUB /boot/config
CONFIG_SLUB_DEBUG=3Dy
CONFIG_SLUB=3Dy
# CONFIG_SLUB_DEBUG_ON is not set
# CONFIG_SLUB_STATS is not set

Some of slabs (e.g. filp) are not shown in /proc/slabinfo; comparing=20
number of entries under /sys and slabinfo results in

{pts/0}% =3Dls -1 /sys/kernel/slab | grep -v : | wc -l
131
{pts/0}% wc -l /proc/slabinfo
68 /proc/slabinfo
{pts/0}%

so almost half of the all entries are missing. Is it expected or there=20
is something wrong here?

--nextPart6392455.d0U59A7uQp
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAko95rUACgkQR6LMutpd94wbwwCdF0MZe8rRpK5gCCI/mcckQhRO
y78AmweLvx0tT6sWAvXH56AYo2e1yjQj
=vleh
-----END PGP SIGNATURE-----

--nextPart6392455.d0U59A7uQp--
