Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbYGNOHV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbYGNOHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2008 10:07:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753889AbYGNOHH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Jul 2008 10:07:07 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59747 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753472AbYGNOHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2008 10:07:05 -0400
Subject: Re: 2.6.26-rc9-git12: Reported regressions from 2.6.25
From: Johannes Berg <johannes@sipsolutions.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Adrian Bunk <bunk@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Natalie Protasevich <protasnb@gmail.com>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Greg KH <greg@kroah.com>
In-Reply-To: <Pine.LNX.4.44L0.0807140955020.2566-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.0807140955020.2566-100000@iolanthe.rowland.org>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-NtqE1GeviUS5bNnqjzEZ"
Date: Mon, 14 Jul 2008 16:06:38 +0200
Message-Id: <1216044398.23746.10.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NtqE1GeviUS5bNnqjzEZ
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D11072
> > > Subject		: scsi-layer crash after usb storage device unplug
> > > Submitter	: Johannes Berg <johannes@sipsolutions.net>
> > > Date		: 2008-07-12 01:50 (2 days old)
> > > Handled-By	: Alan Stern <stern@rowland.harvard.edu>
> > > Patch		: http://bugzilla.kernel.org/show_bug.cgi?id=3D11072#c3
> >=20
> > Alan, Greg?
>=20
> We haven't heard back yet from Johannes to confirm that the fix really
> works.  If it does, IMO the patch should go into 2.6.26.1.
>=20
> (In fact it might not be so easy to tell, since the failure is caused=20
> be a race.  Perhaps it would be best to submit the patch in any case.)

I haven't had a chance to apply the patch, but given that to cause the
oops to happen I had to unplug/replug the device at random intervals for
probably 10 minutes (yes, it took me that long to figure out I had put
an SDHC card into an SD reader) I suppose it really won't be easy to
tell.

johannes

--=-NtqE1GeviUS5bNnqjzEZ
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIe11rAAoJEKVg1VMiehFYoJAQAKgRQ38FD2mq1TLWWRy/XZzm
aTJ+CEIJpaYKeKvoRJsvIGDZQSrmRXscRRUoNuxzjBWHWsUzZ05AtnKvM1l8w2Iy
Aa/qxDoGi1FxIrVc/ztO2ORM+kDaDZAcdIJ1kVwLc8qagNpct5Ygvr12Ff0k3F5r
cX4P+fX0t4CTg4L7ncZOlY6s4KhLOfRy1WvWnoOJ9oKRlqO+oI9PEjr/e52bFo4l
ZCfMGPGOihP+o+Nz7UGwJFmJTkY76DqWxMM+AJnbZQ9DpKWrikZyh88kE7tNe+gT
hD7aKcYHgCFz1xeS8rBQsvZbieccBQ85NbJEk6F1aMbMKVQD1Lvc0PRilIs5hScl
FfVANU41Y+wc1lG1HcSZB5BiRdn+Y0wMJUwCrh/pAa9dlumzv0jYckzGkFpMmnkr
cvMM+1SAHYqRLGPmVI5co4mSTzurtC81wJX8jx9snXLOsPX10apeGplN3Ya76q7T
k+fLAmT3+NiP+kaji84mkpHo1Icvd4+Hw/cb3Kq8pme4q3Ae2puY9jN01p6rs2jg
zThdzqUwYKilpj86tzJh9aPYRQREcQftu2RVVk4o9zy3n0V8eFICFzjOqyAscCqt
FHJBHMFr2NhLtvuAGC2ju+9QQT6kdDJrPszDFkY27dk2C0Kvl/CMov90fjZZHHL/
YVk2JQ53UuyQGt6qAk9s
=ynW0
-----END PGP SIGNATURE-----

--=-NtqE1GeviUS5bNnqjzEZ--

