Return-Path: <linux-kernel-owner+w=401wt.eu-S1760644AbXGUFVk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760644AbXGUFVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jul 2007 01:21:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753582AbXGUFVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 21 Jul 2007 01:21:32 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:59037 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447AbXGUFVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jul 2007 01:21:31 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
To: david@lang.hm
Subject: Re: [linux-pm] Re: Hibernation considerations
Date: Sat, 21 Jul 2007 15:21:33 +1000
User-Agent: KMail/1.9.6
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Jeremy Maitin-Shepard <jbms@cmu.edu>, Milton Miller <miltonm@bga.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, Ying Huang <ying.huang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>
References: <Pine.LNX.4.44L0.0707201830470.5241-100000@iolanthe.rowland.org> <Pine.LNX.4.64.0707201540260.5166@asgard.lang.hm>
In-Reply-To: <Pine.LNX.4.64.0707201540260.5166@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2838332.GM7CrxbZlW";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707211521.34619.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2838332.GM7CrxbZlW
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Saturday 21 July 2007 08:43:20 david@lang.hm wrote:
> On Fri, 20 Jul 2007, Alan Stern wrote:
>=20
> > On Fri, 20 Jul 2007, Jeremy Maitin-Shepard wrote:
> >
> >>>> when doing a suspend-to-ram you get to a point where you just don't =
use
> >>>> any userspace.
> >>
> >>> What do you mean?  How can you prevent user tasks from running?  That=
's
> >>> basically what the freezer does, and the whole point of this approach
> >>> is to eliminate the freezer.  Right?
> >>
> >> Presumably no tasks at all would be scheduled.
> >
> > How would you prevent tasks from being scheduled?  How would you
> > prevent drivers from deadlocking because in order to put their device
> > in a low-power state they need to acquire a lock which is held by a
> > user task?
>=20
> you give up on the suspend becouse you have no way of getting the user=20
> task to give up the lock.
>=20
> however, kernel locks should not be held by user tasks, user tasks are no=
t=20
> expected to behave in rational ways, allowing them to compete with kernel=
=20
> tasks for locks is a sure way to get a deadlock or indefinate stall.
>=20
> what locks are accessed this way?

Any userspace process can do a syscall. In the process of the syscall, it c=
an=20
take kernel locks, and it can schedule (eg, while seeking to take a second=
=20
lock).

Regards,

Nigel

--nextPart2838332.GM7CrxbZlW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGoZfeN0y+n1M3mo0RAj6/AJ9et0G6U5Y14K100BwjpBe6GjZCzwCfe18X
ohg4CBTRkSJLm+//08uJJAI=
=jkir
-----END PGP SIGNATURE-----

--nextPart2838332.GM7CrxbZlW--
