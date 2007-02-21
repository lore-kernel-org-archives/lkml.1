Return-Path: <linux-kernel-owner+w=401wt.eu-S932483AbXBUNMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932483AbXBUNMA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 08:12:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932490AbXBUNMA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 08:12:00 -0500
Received: from mail.sf-mail.de ([62.27.20.61]:49798 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932483AbXBUNL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 08:11:59 -0500
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] EXPORT_SYMBOL() time functions
Date: Wed, 21 Feb 2007 14:12:22 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, john stultz <johnstul@us.ibm.com>,
       Roman Zippel <zippel@linux-m68k.org>,
       Jeremy Fitzhardinge <jeremy@goop.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1912627.2JmqV6VvHL";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702211412.23388.eike-kernel@sf-tec.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1912627.2JmqV6VvHL
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

These functions were inlines before 8b9365d753d9870bb6451504c13570b81923228=
f.
Now EXPORT_SYMBOL() them to allow them to be used in modules again.

Signed-off-by: Rolf Eike Beer <eike-kernel@sf-tec.de>

=2D--
commit 0a543599f4a9ea02b587bda26e0e11ae94774f61
tree aa815eab413d2575925b0964a1fa01d41439b26b
parent 6b8afc66b9d6893d3fa292b75769b58539836ff3
author Rolf Eike Beer <eike-kernel@sf-tec.de> Wed, 21 Feb 2007 14:10:12 +01=
00
committer Rolf Eike Beer <eike-kernel@sf-tec.de> Wed, 21 Feb 2007 14:10:12 =
+0100

 kernel/time.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/kernel/time.c b/kernel/time.c
index c6c80ea..0b351b2 100644
=2D-- a/kernel/time.c
+++ b/kernel/time.c
@@ -635,6 +635,7 @@ timeval_to_jiffies(const struct timeval *value)
 		(((u64)usec * USEC_CONVERSION + USEC_ROUND) >>
 		 (USEC_JIFFIE_SC - SEC_JIFFIE_SC))) >> SEC_JIFFIE_SC;
 }
+EXPORT_SYMBOL(timeval_to_jiffies);
=20
 void jiffies_to_timeval(const unsigned long jiffies, struct timeval *value)
 {
@@ -649,6 +650,7 @@ void jiffies_to_timeval(const unsigned long jiffies, st=
ruct timeval *value)
 	tv_usec /=3D NSEC_PER_USEC;
 	value->tv_usec =3D tv_usec;
 }
+EXPORT_SYMBOL(jiffies_to_timeval);
=20
 /*
  * Convert jiffies/jiffies_64 to clock_t and back.
@@ -723,6 +725,7 @@ u64 nsec_to_clock_t(u64 x)
 #endif
 	return x;
 }
+EXPORT_SYMBOL(nsec_to_clock_t);
=20
 #if (BITS_PER_LONG < 64)
 u64 get_jiffies_64(void)

--nextPart1912627.2JmqV6VvHL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)

iD8DBQBF3EU3XKSJPmm5/E4RAs0MAJoDEw1eIjdxqovH8/xWz9Hjr30WPgCfbQrn
prfcvy00PeqbheFx4p0JrKs=
=QfPU
-----END PGP SIGNATURE-----

--nextPart1912627.2JmqV6VvHL--
