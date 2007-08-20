Return-Path: <linux-kernel-owner+w=401wt.eu-S1758140AbXHTIXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758140AbXHTIXz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 04:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752750AbXHTIXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 04:23:48 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:33621 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752362AbXHTIXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 04:23:47 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Peter Zijlstra <peterz@infradead.org>
Subject: Re: 2.6.22.2-cfs-v19.1 stops honouring nice 3 after some hours
Date: Mon, 20 Aug 2007 09:54:22 +0200
User-Agent: KMail/1.9.7
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
References: <200708151823.17623.mgd@technosis.de> <1187286737.6114.100.camel@twins>
In-Reply-To: <1187286737.6114.100.camel@twins>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1473212.Le1cVN0j5h";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200708200954.34812.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1187598227;f019111c;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1473212.Le1cVN0j5h
Content-Type: multipart/mixed;
  boundary="Boundary-01=_uiUyGpfTEiehh6u"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

--Boundary-01=_uiUyGpfTEiehh6u
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> > I played a bit with renicing my (mostly) CPU bound jobs and found
> > somewhat strange behaviour.
> >=20
> > I'm on 2.6.22.2-cfs-v19.1 -- I can't boot into 2.6.23-rc3 as part of
> > my daily work because my NVIDIA driver doesn't yet work with it though
> > I could try to do some X-less testing if need be.
>=20
> Please do try, a lot has changed since v19.1.

Meanwhile I've done some testing on 2.6.23-rc3.

The good news is that the strange behaviour w/r to nice I had seen on
2.6.22.3-cfs-v19.1 is no longer there.

Long running CPU bound jobs at different nice levels do indeed progress
(roughly) according to the %CPU figures as reported by top now.

However what I find somewhat unexpected is the IMO huge variation
in %CPU as observed even with 'top -d 60'. I've attached a log showing
5 CPU bound tasks observed for an our with 'top -b -d 60 -n 60'.

Jobs 5897, 5928 and 5977 do perform essentially the same tasks.
Jobs 17085 and 21492 do perform essentially the same task but differ
from the other 3 task.

I would have expected Jobs 5897 and 5928 to differ by at most one
percent point when measured for 60 seconds.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=C3=A4ftsf=C3=BChrer: Heiko Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--Boundary-01=_uiUyGpfTEiehh6u
Content-Type: application/x-bzip2;
  name="top2.log.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="top2.log.bz2"

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
qh8KHHahhG9KT+RdyRThQkLOjao0

--Boundary-01=_uiUyGpfTEiehh6u--

--nextPart1473212.Le1cVN0j5h
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGyUi6UYYhyuxDQc4RAs9wAJ4hbIH9mBwXjgINvRfjgrjpeINujACfVjpi
Bd2d3cfuVXna1QnLIys0yZc=
=aydF
-----END PGP SIGNATURE-----

--nextPart1473212.Le1cVN0j5h--
