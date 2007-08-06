Return-Path: <linux-kernel-owner+w=401wt.eu-S1763328AbXHFJhT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763328AbXHFJhT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2007 05:37:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760752AbXHFJhA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Aug 2007 05:37:00 -0400
Received: from mail.gmx.net ([213.165.64.20]:37662 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1761454AbXHFJg5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2007 05:36:57 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/O8+ljQjTOk8/FRbygaY4CCLU3TCz1DbyMFzoIPW
	9zAG42x9qWN6Zk
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Pavel Machek <pavel@ucw.cz>
Subject: Re: suspend/hibernation regression between 2.6.19 and 2.6.20 w/ Thinkpad T41
Date: Mon, 6 Aug 2007 11:36:46 +0200
User-Agent: KMail/1.9.5
Cc: ibm-acpi@hmh.eng.br, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
References: <200708051902.18801.toralf.foerster@gmx.de> <20070805222937.GA23963@elf.ucw.cz>
In-Reply-To: <20070805222937.GA23963@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4569252.9UeqM23Iiz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708061136.50491.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4569252.9UeqM23Iiz
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Montag, 6. August 2007 00:29 schrieb Pavel Machek:
> Yes, I seen similar reports. Does it happen in all shutdown mode and
> 2.6.22? Does it happen   in platform mode in 2.6.19?

I can reproduce this behaviour by doing the following with kernel 2.6.20 :

1. <Fn>+<F4>   - the systems sleeps within RAM
2. <Fn>             - the systems wakes up
3. <Fn>+<F12> - the systems hibernates to disk
4. <power>       - systems wakes up
5. <Fn>+<F4>   - the systems sleeps within RAM

Now pressing <Fn> doesn't wake up the system, I have to press the power but=
ton
for that instead.

BTW I tried to test the latest git-sources -rc2 but the <Fn> keys do not wo=
rk
anymore with the thinkpad-acpi feature (neither as module nor if compiled i=
nto).

=2D-=20
MfG/Sincerely

Toralf F=F6rster

--nextPart4569252.9UeqM23Iiz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBGtuuvhyrlCH22naMRAiZqAKC7JnTqDwKWx7/VpfOrkcANXUEljwCgxmp6
XRXNbBUK1S9wJYGxVXO61Sc=
=VYkn
-----END PGP SIGNATURE-----

--nextPart4569252.9UeqM23Iiz--
