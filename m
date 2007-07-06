Return-Path: <linux-kernel-owner+w=401wt.eu-S1763096AbXGFJOa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763096AbXGFJOa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 05:14:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758867AbXGFJOJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 05:14:09 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:49670 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756590AbXGFJOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 05:14:06 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC][PATCH -mm] PM: Do not sync filesystems from within the freezer
Date: Fri, 6 Jul 2007 19:13:56 +1000
User-Agent: KMail/1.9.6
Cc: benh@kernel.crashing.org, nigel@suspend2.net, rjw@sisk.pl, pavel@ucw.cz,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       mjg59@srcf.ucam.org, oliver@neukum.org, paulus@samba.org, mingo@elte.hu
References: <200707041658.59588.rjw@sisk.pl> <1183712394.3388.128.camel@localhost.localdomain> <E1I6jlB-0003TC-00@dorka.pomaz.szeredi.hu>
In-Reply-To: <E1I6jlB-0003TC-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart34817502.2AvyaTg7Yt";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707061914.02972.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart34817502.2AvyaTg7Yt
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Friday 06 July 2007 19:05:53 Miklos Szeredi wrote:
> > On Fri, 2007-07-06 at 09:13 +0200, Miklos Szeredi wrote:
> > >=20
> > > Another myth, that has been debunked already.  The problem is: how do
> > > you define fuse processes?  There's no theoretical or even practial
> > > way to do that.
> >=20
> > It could if they told the kernel via some black magic ...
> >=20
> > But that still suck. The freezer sucks :-)
>=20
> Yeah, and it wouldn't work in practice, since the auxilary tasks might
> be part of a library which is not even aware of being used by a "fuse
> task".

This is why I think the whole concept of filesystems in userspace is broken=
=2E=20
Trying to shift things that need special privilege and special handling to=
=20
userspace is just asking for trouble. You can say it's the kernel code's=20
fault, but then you have to explain why it's only fuse (yeah ok, and XFS)=20
that have problems.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart34817502.2AvyaTg7Yt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGjgfaN0y+n1M3mo0RAhwxAKCzBfzlaBBw8ZQK+deMRbrqU05hqQCcDgwt
rNGPIjV3/BoDmcZ0xLMknOc=
=fnLG
-----END PGP SIGNATURE-----

--nextPart34817502.2AvyaTg7Yt--
