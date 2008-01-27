Return-Path: <linux-kernel-owner+w=401wt.eu-S1757881AbYA0Q5X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757881AbYA0Q5X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 11:57:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751403AbYA0Q5N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 11:57:13 -0500
Received: from mail.gmx.net ([213.165.64.20]:60978 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1750831AbYA0Q5M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 11:57:12 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1+vtgpeyFivqsL1E/NI79dm0NWKimDOn3c7MrwWVB
	HiHasJ7mX8x7Wp
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: vatsa@linux.vnet.ibm.com
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sun, 27 Jan 2008 17:57:05 +0100
User-Agent: KMail/1.9.7
Cc: Tomasz Chmielewski <mangoo@wpkg.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, a.p.zijlstra@chello.nl,
       dhaval@linux.vnet.ibm.com
References: <479B69D2.5050603@wpkg.org> <200801271606.19862.toralf.foerster@gmx.de> <20080127165400.GB1044@linux.vnet.ibm.com>
In-Reply-To: <20080127165400.GB1044@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5097950.SUz6fH7GBg";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801271757.07743.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5097950.SUz6fH7GBg
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Sunday 27 January 2008 Srivatsa Vaddagiri wrote :
> You can set that to 0 to ask ondemand gov to include nice load into
> account while calculating cpu freq changes:
>=20
> # echo 0 > /sys/devices/system/cpu/cpu0/cpufreq/ondemand/ignore_nice_load
>=20
> This should restore the behavior of ondemand governor as seen in 2.6.23
> in your case (even with CONFIG_FAIR_GROUP_SCHED enabled). Can you pls con=
firm=20
> if that happens?

Yes, of course, unfortunately this speeds up the CPU up to max power consum=
ption
which isn't wanted at least at a notebook b/c temperature and fan speed are=
 at
maximum in that case :-(

It would be nice to run a grid application at lowest priority without impac=
t to
power / fan / temperature but OTOH have full performance for desktop
applications, isn't it ?


=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart5097950.SUz6fH7GBg
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnLfjhyrlCH22naMRAtG3AKCuvDcfhZXpKoYzE+nbmO9dcdAFUwCeO95R
bLGVhsQwBGz26jyEblX5OsQ=
=9R+Y
-----END PGP SIGNATURE-----

--nextPart5097950.SUz6fH7GBg--
