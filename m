Return-Path: <linux-kernel-owner+w=401wt.eu-S1752998AbYIES3p@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998AbYIES3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2008 14:29:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751251AbYIES3g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Sep 2008 14:29:36 -0400
Received: from flock1.newmail.ru ([82.204.219.207]:54603 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751151AbYIES3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2008 14:29:35 -0400
X-Greylist: delayed 562 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Sep 2008 14:29:34 EDT
From: Andrey Borzenkov <arvidjaar@newmail.ru>
To: hpa@zytor.com, Andrew Morton <akpm@linux-foundation.org>
Subject: Ghost EDD devices in /sys again
Date: Fri, 5 Sep 2008 22:19:43 +0400
User-Agent: KMail/1.9.10
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Message-Id: <200809052219.44093.arvidjaar@newmail.ru>
Content-Type: multipart/signed;
  boundary="nextPart17972051.c6SMrpffnh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart17972051.c6SMrpffnh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

This is regression but old enough. Apparently I had for whatever reasons
EDD turned off till recently. This is 2.6.27-rc5 just in case.

In 2006 I fixed ghost devices due to buggy BIOS:

http://marc.info/?l=linux-kernel&m=114087765422490&w=2

Later edd.S has been rewritten in C, and apparently this patch has been
lost:

{pts/1}% ls /sys/firmware/edd
int13_dev80/  int13_dev84/  int13_dev88/  int13_dev8c/
int13_dev81/  int13_dev85/  int13_dev89/  int13_dev8d/
int13_dev82/  int13_dev86/  int13_dev8a/  int13_dev8e/
int13_dev83/  int13_dev87/  int13_dev8b/  int13_dev8f/

But I have just a single disk. This is the same system BTW.

Unfortunately I do not speak asm language of C; if somebody could provide
equivalent fix for current edd.c, I am more than ready to test it.

Thank you

-andrey

--nextPart17972051.c6SMrpffnh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjBeEAACgkQR6LMutpd94zdpwCgvkQVz+XBmGj9EUUkgXdh71DO
YOIAn1NHr4VJoon6+oQRUVKh2nefwVKy
=FQsP
-----END PGP SIGNATURE-----

--nextPart17972051.c6SMrpffnh--
