Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbYHZSSl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbYHZSSl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2008 14:18:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756171AbYHZSSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Aug 2008 14:18:32 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:46540 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756032AbYHZSSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2008 14:18:31 -0400
Message-ID: <48B4486A.1010308@novell.com>
Date: Tue, 26 Aug 2008 14:16:10 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: mingo@elte.hu
CC: srostedt@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org,
       linux-rt-users@vger.kernel.org, npiggin@suse.de,
       gregory.haskins@gmail.com
Subject: Re: [PATCH v2 0/6] sched: misc rt fixes for tip/sched/devel (was:
 Series short description)
References: <20080825200852.23217.13842.stgit@dev.haskins.net> <20080826173131.16413.17862.stgit@dev.haskins.net>
In-Reply-To: <20080826173131.16413.17862.stgit@dev.haskins.net>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFE4EE7E35EA025A693CE7FA1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFE4EE7E35EA025A693CE7FA1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Ingo,
>
> The following repositories
>
>      git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-h=
acks.git tip/sched/devel/rtbalance=20
>
>      ftp://ftp.novell.com/dev/ghaskins/tip-rt-fixes.tar.bz2
>
> apply to tip/sched/devel to pick up fixes for the RT scheduler.=20
>  =20

[ It would help if I remembered to rename the default subject ;) ]

I just wanted to add that these are not urgent fixes.  .28 at the
earliest.  Thanks

-Greg

> [
> 	Changelog:
> =09
> 	v2:=20
> 	    *) predicated newidle and double_lock changes on
> 	       CONFIG_PREEMPT to address a concern by Nick Piggin
>
> 	    *) fixed a build issue when DEBUG_PI_LIST is defined=20
>
> 	v1:
> 	    *) initial release
> ]
>
> These patches were developed in the interest of shorting latencies in
> PREEMPT_RT, but they apply to the mainline scheduler as well, so I am
> offering them here first.
>
> This has been tested under both 26.3-rt3 and tip/sched/devel on x86_64 =
for
> both CONFIG_SMP and !CONFIG_SMP.
>
> Comments/bug-fixes welcome!
>
> Regards,
> -Greg
>
>
> ---
>
> Gregory Haskins (6):
>       sched: create "pushable_tasks" list to limit pushing to one attem=
pt
>       plist: fix PLIST_NODE_INIT to work with debug enabled
>       sched: add sched_class->needs_post_schedule() member
>       sched: make double-lock-balance fair
>       sched: pull only one task during NEWIDLE balancing to limit criti=
cal section
>       sched: only try to push a task on wakeup if it is migratable
>
>
>  include/linux/init_task.h |    1=20
>  include/linux/plist.h     |    9 ++-
>  include/linux/sched.h     |    2 +
>  kernel/sched.c            |   84 ++++++++++++++++++++++++---
>  kernel/sched_rt.c         |  139 +++++++++++++++++++++++++++++++++++++=
+-------
>  5 files changed, 202 insertions(+), 33 deletions(-)
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rt-user=
s" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  =20



--------------enigFE4EE7E35EA025A693CE7FA1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAki0SGoACgkQlOSOBdgZUxmsAgCdG+piCcBZdn6Xnm1QUYi8K2Iu
nUsAoIKZxtbYsXFG7c8X3aBsGbAQeznp
=bQfL
-----END PGP SIGNATURE-----

--------------enigFE4EE7E35EA025A693CE7FA1--
