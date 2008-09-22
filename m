Return-Path: <linux-kernel-owner+w=401wt.eu-S1753364AbYIVP3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364AbYIVP3T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2008 11:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752682AbYIVP3K
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Sep 2008 11:29:10 -0400
Received: from postman.teamix.net ([194.150.191.120]:42417 "EHLO
	rproxy.teamix.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752675AbYIVP3J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2008 11:29:09 -0400
X-Greylist: delayed 807 seconds by postgrey-1.27 at vger.kernel.org; Mon, 22 Sep 2008 11:29:09 EDT
From: Martin Steigerwald <ms@teamix.de>
Organization: team(ix) GmbH
To: linux-kernel@vger.kernel.org
Subject: documentation about scheduling policies
Date: Mon, 22 Sep 2008 17:29:06 +0200
User-Agent: KMail/1.9.9
Cc: Ingo Molnar <mingo@elte.hu>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6056827.WDYW8uj3tR";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200809221729.06870.ms@teamix.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6056827.WDYW8uj3tR
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline


Please CC to me as I am not subscribed to linux-kernel.


Hi!

I wonder about scheduling policies in CFS. I find these:

ms@mango> grep "case SCHED_" sched.c sched_fair.c | sort | uniq=20
~/lokal/Kernel/linux-2.6.26/kernel
sched.c:        case SCHED_BATCH:
sched.c:        case SCHED_FIFO:
sched.c:        case SCHED_IDLE:
sched.c:        case SCHED_NORMAL:
sched.c:        case SCHED_RR:

sched_fair.c seems to differentiate SCHED_PATCH only:

ms@mango> egrep "(SCHED_I|SCHED_B)" sched_fair.c                      =20
~/lokal/Kernel/linux-2.6.26/kernel
 * Completely Fair Scheduling (CFS) Class (SCHED_NORMAL/SCHED_BATCH)
        if (likely(!sysctl_sched_compat_yield) && curr->policy !=3D SCHED_B=
ATCH)=20
{
        if (unlikely(p->policy =3D=3D SCHED_BATCH))


The documentation on scheduling policies in Documentation/scheduler appears=
=20
rather scarse to me.

The wikipage at

http://ck.wikia.com/wiki/SchedulingPolicies

has more hints. But I wonder whether they are up to date and also they part=
ly=20
related to RSDL/SD features.

What about SCHED_IDLEPRIO anyway - the description of it makes it appear qu=
ite=20
useful to me? Is it SCHED_IDLE in the new scheduler? Hmm, it does not appea=
r=20
that chrt can set this scheduling priority as of util-linux-ng 2.13.1.1.

I am willing to create documentation patches provided someone explains thes=
e=20
to me ;-).

Ciao,
=2D-=20
Martin Steigerwald - team(ix) GmbH - http://www.teamix.de
gpg: 19E3 8D42 896F D004 08AC A0CA 1E10 C593 0399 AE90

--nextPart6056827.WDYW8uj3tR
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkjXucIACgkQHhDFkwOZrpAPMQCeJe2J55UUsPZ182IwZSiqssOs
HC4An1xRAyl2DGFOcA5OK2FTviOwLYq1
=7lfT
-----END PGP SIGNATURE-----

--nextPart6056827.WDYW8uj3tR--
