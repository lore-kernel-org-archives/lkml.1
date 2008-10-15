Return-Path: <linux-kernel-owner+w=401wt.eu-S1753135AbYJODYz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135AbYJODYz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2008 23:24:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbYJODYr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Oct 2008 23:24:47 -0400
Received: from mx6.mail.ru ([194.67.23.26]:9513 "EHLO mx6.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751576AbYJODYr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2008 23:24:47 -0400
From: Andrey Borzenkov <arvidjaar@mail.ru>
To: linux-ext4@vger.kernel.org
Subject: Possible ext3 corruption with 1K block size
Date: Wed, 15 Oct 2008 07:24:38 +0400
User-Agent: KMail/1.9.10
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1438259.lRcpkbiL6Y";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200810150724.42180.arvidjaar@mail.ru>
X-Spam: Not detected
X-Mras: OK
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1438259.lRcpkbiL6Y
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

There is long standing open bug report on Mandriva which is currently
beieved to have root cause in file system corruption. It shows itself
in RPM DB corruption (at least, there is no other known method to trigger
it). So far all reported cases happened on filesystem with 1K block size
and stopped when RPM DB was moved to FS with 4K block size.

There are also similar RH reports as well.

Here are references:

https://qa.mandriva.com/show_bug.cgi?id=3D32547

This one is rather long. Interesting bits are probably around

https://qa.mandriva.com/show_bug.cgi?id=3D32547#c177
https://qa.mandriva.com/show_bug.cgi?id=3D32547#c148 (many users reporting
dumpe2fs)

https://bugzilla.redhat.com/show_bug.cgi?id=3D230362
https://bugzilla.redhat.com/show_bug.cgi?id=3D375931
https://bugzilla.redhat.com/show_bug.cgi?id=3D305301

The Mandriva bugzilla also mentions this mail from Stephen Tweedie=20
http://lkml.org/lkml/2007/9/18/232

which indicates some issues with 1K blocks, but according to last comment:
https://qa.mandriva.com/show_bug.cgi?id=3D32547#c300

it is still present in 2.6.27 (at least was present on -rc6)

There was a kernel bug report http://bugzilla.kernel.org/show_bug.cgi?id=3D=
11564,
but in this case it was identified as hardware issue.

--nextPart1438259.lRcpkbiL6Y
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkj1YncACgkQR6LMutpd94yKZQCfa1EfoFpFlUCfkND+fIF8k0+c
dooAn1R5yzAuphJgowlnuh3M2WSrc696
=u7/1
-----END PGP SIGNATURE-----

--nextPart1438259.lRcpkbiL6Y--
