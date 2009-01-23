Return-Path: <linux-kernel-owner+w=401wt.eu-S1757756AbZAWTaJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757756AbZAWTaJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 14:30:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754180AbZAWT3y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 14:29:54 -0500
Received: from flock1.newmail.ru ([82.204.219.207]:37971 "HELO
	flock1.newmail.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753589AbZAWT3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 14:29:53 -0500
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-crypto@vger.kernel.org
Subject: Clarification of allowed context for crypto routines
Date: Fri, 23 Jan 2009 22:29:46 +0300
User-Agent: KMail/1.11.0 (Linux/2.6.29-rc2-1avb; KDE/4.1.96; i686; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1351120.y7ki5iFoNh";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200901232229.47885.arvidjaar@mail.ru>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1351120.y7ki5iFoNh
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

According to Documentation/crypto/api-intro.txt:

DEVELOPER NOTES

Transforms may only be allocated in user context, and cryptographic
methods may only be called from softirq and user contexts.  For
transforms with a setkey method it too should only be called from
user context.

As I can understand, user context requirement is due to potential for=20
setkey to sleep (although it appears, that currently the only module=20
that can sleep is shash which is calling kmalloc with GFP_KERNEL). Is it=20
correct?

But where is the difference between hard and softirq contexts? I fail to=20
see any technical reason for this requirement.

Thank you!

=2Dandrey

--nextPart1351120.y7ki5iFoNh
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkl6GqsACgkQR6LMutpd94wabgCgz9YRcaGpNcysA8t6WMH8YIS1
2GoAoInnK/mDJP+wp00/nu2fEM4dBR+M
=2w+r
-----END PGP SIGNATURE-----

--nextPart1351120.y7ki5iFoNh--
