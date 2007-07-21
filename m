Return-Path: <linux-kernel-owner+w=401wt.eu-S936239AbXGUWQc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936239AbXGUWQc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 18:16:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S964970AbXGUWP7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 18:15:59 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:50746 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964952AbXGUWP5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 18:15:57 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sun, 22 Jul 2007 08:16:02 +1000
User-Agent: KMail/1.9.6
Cc: Miklos Szeredi <miklos@szeredi.hu>, rjw@sisk.pl, miltonm@bga.com,
       stern@rowland.harvard.edu, ying.huang@intel.com,
       linux-kernel@vger.kernel.org, david@lang.hm,
       linux-pm@lists.linux-foundation.org
References: <Pine.LNX.4.64.0707171319140.2467@asgard.lang.hm> <200707212243.35602.nigel@nigel.suspend2.net> <87lkd9ohtn.fsf@jbms.ath.cx>
In-Reply-To: <87lkd9ohtn.fsf@jbms.ath.cx>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1976347.8yxf0I4N35";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707220816.03838.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1976347.8yxf0I4N35
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Sunday 22 July 2007 02:13:56 Jeremy Maitin-Shepard wrote:
> It seems that you could still potentially get a failure to freeze if one
> FUSE process depends on another, and the one that is frozen second just
> happens to be waiting on the one that is frozen first when it is frozen.
> I admit that this situation is unlikely, and perhaps acceptable.
>=20
> A larger concern is that it seems that freezing FUSE processes at all
> _will_ generate deadlocks if a non-synchronous or memory-map-supporting
> filesystem is loopback mounted from a FUSE filesystem.  In that case, if
> you attempt to sync or free memory once FUSE is frozen, you are sure to
> get a deadlock.

Ok. So then (in response to Alan too), how about keeping a tree of mounts,=
=20
akin to the device tree, and working from the deepest nodes up? (In=20
conjunction with what I already suggested)?

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart1976347.8yxf0I4N35
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGooWjN0y+n1M3mo0RAiFrAKDoNHX3OYIQ5oa5oMuyorrITCWFngCgndeJ
kW4J4yTjFIdPr+slSiMtIwo=
=CQ/Y
-----END PGP SIGNATURE-----

--nextPart1976347.8yxf0I4N35--
