Return-Path: <linux-kernel-owner+w=401wt.eu-S1763093AbXGFHTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763093AbXGFHTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 03:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753867AbXGFHTj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 03:19:39 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40825 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752059AbXGFHTi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 03:19:38 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Fri, 6 Jul 2007 17:19:34 +1000
User-Agent: KMail/1.9.6
Cc: nigel@suspend2.net, rjw@sisk.pl, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, mjg59@srcf.ucam.org, oliver@neukum.org,
       paulus@samba.org, mingo@elte.hu
References: <200707041658.59588.rjw@sisk.pl> <200707061707.23316.nigel@nigel.suspend2.net> <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6i0N-0003CY-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2001911.hDr84XMzzR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061719.36054.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2001911.hDr84XMzzR
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 17:13:27 Miklos Szeredi wrote:
> > To get more serious and practical though, I think the solution is to
> > fuzz the userspace/kernelspace distinction. What we really want to
> > do is freeze things that submit I/O, then sync, then freeze anything
> > that processes I/O and needs to be frozen. In effect, redefine fuse
> > processes as freezeable kernel threads.
>=20
> Another myth, that has been debunked already.  The problem is: how do
> you define fuse processes?  There's no theoretical or even practial
> way to do that.

No theoretical or practical way?! I'll freely admit to being quite ignorant=
=20
about fuse, but surely there's some way by which they can be distinguished.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart2001911.hDr84XMzzR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGje0IN0y+n1M3mo0RAsI8AKDVne3j+dySUwP7nqn+n4PWYYY4nwCgtggq
iJIlnJzslub4sJ8LypH4e/0=
=p5BO
-----END PGP SIGNATURE-----

--nextPart2001911.hDr84XMzzR--
