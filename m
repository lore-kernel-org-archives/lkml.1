Return-Path: <linux-kernel-owner+w=401wt.eu-S1760255AbYA0Ml3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760255AbYA0Ml3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 07:41:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759093AbYA0MjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 07:39:21 -0500
Received: from mail.gmx.net ([213.165.64.20]:53023 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1757470AbYA0MjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 07:39:19 -0500
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/02mIv46D0ev6ooEygfI8wSx+5xoO8mCO07IOpbp
	a19JVFI+w2pARs
From: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>
To: Mike Galbraith <efault@gmx.de>
Subject: Re: (ondemand) CPU governor  regression between 2.6.23 and 2.6.24
Date: Sun, 27 Jan 2008 13:39:11 +0100
User-Agent: KMail/1.9.7
References: <479B69D2.5050603@wpkg.org> <200801271200.04971.toralf.foerster@gmx.de> <1201433167.22060.10.camel@homer.simson.net>
In-Reply-To: <1201433167.22060.10.camel@homer.simson.net>
Cc: Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3702719.PAk5QgY8qC";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200801271339.14668.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3702719.PAk5QgY8qC
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Am Sonntag, 27. Januar 2008 schrieben Sie:
>=20
> On Sun, 2008-01-27 at 12:00 +0100, Toralf F=C3=B6rster wrote:
> > BTW the dnetc process runs under the user "dnetc" with nice level -19,
> > my process runs under my own user id "tfoerste" therefore I wouldn't ex=
pect
> > that both processes got the same processor resources isn't it ? :
>=20
> Normal.  Nice level controls cpu distribution _within_ a task group,
> whereas distribution between groups is controlled by cpu_share.  It's
> going to take a while for folks to get used to having two levels of cpu
> distribution.

Ough, does this mean that for a multi-user scenario of 2 non-root users "A"=
 and
"B" each running exactly 1 process with nice level 0 and 19 rerspectively
that both share ~50% of the CPU *and furthermore* that that user "B" does n=
ever
ever have a  chance to be nice to user "A" although his process should real=
ly
use only those CPU cycles not eated by any other user ?

If the answer is yes what's about extending the current behaviour to consid=
er
(optionally) nice level of running processes in the case where
CONFIG_FAIR_GROUP_SCHED is set ?

But anyway the initial email reports not a regression related to the ondema=
nd
governor.

=2D-=20
MfG/Sincerely

Toralf F=C3=B6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart3702719.PAk5QgY8qC
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHnHtyhyrlCH22naMRAoa2AJ470v6pC9LPq7MK9ng9/8npc00EKQCgjVZv
REHpCJbD8Mp+TzGP7uJnrpU=
=nXFk
-----END PGP SIGNATURE-----

--nextPart3702719.PAk5QgY8qC--
