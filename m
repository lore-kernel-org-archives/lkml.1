Return-Path: <linux-kernel-owner+w=401wt.eu-S1761105AbXETGMj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761105AbXETGMj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2007 02:12:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758970AbXETGMb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 May 2007 02:12:31 -0400
Received: from server021.webpack.hosteurope.de ([80.237.130.29]:45811 "EHLO
	server021.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758679AbXETGMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2007 02:12:31 -0400
From: Michael Gerdau <mgd@technosis.de>
Organization: Technosis GmbH
To: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sched - graphic smoothness under load - cfs-v13 sd-0.48
Date: Sun, 20 May 2007 08:12:13 +0200
User-Agent: KMail/1.9.5
Cc: Ray Lee <ray@madrabbit.org>,
       Linux Kernel M/L <linux-kernel@vger.kernel.org>
References: <464F57DD.2000309@tmr.com> <2c0942db0705191322p54e05e40p512146f21f68299a@mail.gmail.com> <464F99EC.3080006@tmr.com>
In-Reply-To: <464F99EC.3080006@tmr.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1514572.0Ezs25GRyo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200705200812.26391.mgd@technosis.de>
X-bounce-key: webpack.hosteurope.de;mgd@technosis.de;1179641550;c25bf37e;
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1514572.0Ezs25GRyo
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

> Okay, here's a bonus, http://www.tmr.com/~davidsen/sched_smooth_02.html=20
> not only has the right values, the labels are changed, and I included=20
> more data points from the fc6 recent kernel and the 2.6.21.1 kernel with=
=20
> the mainline scheduler.
>=20
> The nice thing about this test and the IPC test I posted recently is=20
> that they are reasonable stable on the same hardware, so even if someone=
=20
> argues about what they show, they show the same thing each time and can=20
> therefore be used to compare changes.

I'm not sure I follow you here. The difference between 2.6.21 and 2.6.21.1
are two simple (as in involving little code) changes to ip4 and ip6 net
and I'm not even sure that code is used at all in your tests.
[Read: IMO the 2.6.21 and 2.6.21.1 figures are for identical cases].

Assuming the above is correct then IMO the variance between the two
"dublicated" lines (cfs-v13 and sd048) is such that I would not have
written "that they are reasonable stable on the same hardware".

I don't want to say the values aren't useful. I simply think there is
a high noiselevel.

Best,
Michael
=2D-=20
 Technosis GmbH, Gesch=E4ftsf=FChrer: Michael Gerdau, Tobias Dittmar
 Sitz Hamburg; HRB 89145 Amtsgericht Hamburg
 Vote against SPAM - see http://www.politik-digital.de/spam/
 Michael Gerdau       email: mgd@technosis.de
 GPG-keys available on request or at public keyserver

--nextPart1514572.0Ezs25GRyo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBGT+bKUYYhyuxDQc4RApc1AKCqq5r4SzhqodDx+qwL1AT4GBeGEwCdG0Me
VUSrGH5eaYMy+IF0ZS2LtKw=
=fIPR
-----END PGP SIGNATURE-----

--nextPart1514572.0Ezs25GRyo--
