Return-Path: <linux-kernel-owner+w=401wt.eu-S1758563AbXGRHqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563AbXGRHqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 03:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752709AbXGRHqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 03:46:06 -0400
Received: from nigel.suspend2.net ([203.171.70.205]:40968 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479AbXGRHqF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 03:46:05 -0400
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@suspend2.net
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH -mm 0/5] Freezer update
Date: Wed, 18 Jul 2007 17:46:03 +1000
User-Agent: KMail/1.9.6
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, Oleg Nesterov <oleg@tv-sign.ru>,
       Pavel Machek <pavel@ucw.cz>
References: <200707180929.31511.rjw@sisk.pl>
In-Reply-To: <200707180929.31511.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3260681.MHKipcFbQV";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707181746.04187.nigel@nigel.suspend2.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3260681.MHKipcFbQV
Content-Type: text/plain;
  charset="cp 850"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Hi.

On Wednesday 18 July 2007 17:29:30 Rafael J. Wysocki wrote:
> Hi,
>=20
> The patches in these series update the freezer to eliminate some existing
> shortcomings, so please consider them as 2.6.23 material.
>=20
> The patches do the following:
> * update the freezer documentation to describe, previously omitted,=20
important
> =A0 reason for freezing tasks (ie. memory shrinking)
> * remove sys_sync() from the freezer and make the suspend/hibernation code
> =A0 invoke it explicitly
> * prevent new tasks from inheriting TIF_FREEZE set from the parents
> * introduce freezer-firendly wrappers around wait_event_interruptible()
> =A0 and wait_event_interruptible_timeout()
> * prevent the freezer from sending signals to kernel threads

I've sent acks for a couple, but not all.

No ack for the sys_sync removal because I think this is just a work around =
for=20
fuse issues, and fuse should be fixed (getting fuse tasks frozen=20
post-sys_sync makes far more sense to me).

No ack for the other patches because I haven't put the time into considerin=
g=20
them.

Regards,

Nigel
=2D-=20
See http://www.tuxonice.net for Howtos, FAQs, mailing
lists, wiki and bugzilla info.

--nextPart3260681.MHKipcFbQV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBGncU8N0y+n1M3mo0RAlQPAJ0QUMfXyxpxCnL5ZR3BEcae8iAL5gCgy0Pu
P7+znJHR7tac2jfo8O8eM7o=
=J4V/
-----END PGP SIGNATURE-----

--nextPart3260681.MHKipcFbQV--
