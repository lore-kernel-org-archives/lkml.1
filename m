Return-Path: <linux-kernel-owner+w=401wt.eu-S1758847AbXHERCa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758847AbXHERCa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Aug 2007 13:02:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753557AbXHERCX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 5 Aug 2007 13:02:23 -0400
Received: from mail.gmx.net ([213.165.64.20]:35925 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753417AbXHERCW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Aug 2007 13:02:22 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/KNSMPK5DKlcDkSEJKrV0AnUn4ZuVn1sMy+mAgTi
	UBx5M86AJJmu82
From: Toralf =?iso-8859-15?q?F=F6rster?= <toralf.foerster@gmx.de>
To: ibm-acpi@hmh.eng.br
Subject: suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Sun, 5 Aug 2007 19:02:15 +0200
User-Agent: KMail/1.9.5
Cc: ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1238361.oBO3fT75su";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708051902.18801.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1238361.oBO3fT75su
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

It is a small - but IMHO nagging - regression between these 2 kernel versio=
ns.

To make a "software suspend" at this notebook ("suspend to RAM") you have
to press <Fn>+ <F4>. Pressing the <Fn>-Key after that wakes up the notenboo=
k.

If you hibernated the system ("suspend to disc"), you have to press the pow=
er
button to wake up the notebook.

But now there is an issue if you want to wake up this notebook, after it was
suspended with <Fn>+<F4> again. It is now not possible to wake it up with <=
=46n>,
instead you have to press the power button as you would have it to do after=
 a
hibernation.

This issue occures in the current 2.6.21 kernel too.
(all tested at a stable Gentoo system - also with git-kernel-versions).

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart1238361.oBO3fT75su
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGtgKXhyrlCH22naMRAkolAKCvx+bWM8/wdgPJx8H6KAra47AV9gCfRexu
GTHYtNS51xVuOlpcF5QMJJE=
=Ohgo
-----END PGP SIGNATURE-----

--nextPart1238361.oBO3fT75su--
