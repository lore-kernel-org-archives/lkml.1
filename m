Return-Path: <linux-kernel-owner+w=401wt.eu-S1756713AbZAURwA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756713AbZAURwA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2009 12:52:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753341AbZAURvv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Jan 2009 12:51:51 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:57341 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZAURvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2009 12:51:50 -0500
Message-ID: <49776161.1080801@novell.com>
Date: Wed, 21 Jan 2009 12:54:41 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-rt-users <linux-rt-users@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "linux >> LKML" <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>
Subject: Re: [RT] [git pull] updates for rt/sched
References: <497760A1.9090806@novell.com>
In-Reply-To: <497760A1.9090806@novell.com>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig99955A69452C03ED1B28036A"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig99955A69452C03ED1B28036A
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Gregory Haskins wrote:
> Hi Steve,
>   Here is a backport of the latest patches that went into tip/sched/rt
>
> -Greg
>  =20

[Adding Peter to CC, since he contributed too]


>
> -------------
> The following changes since commit 0ea6fdc871f24f65e28cd9a92ead1c881783=
741a:
>   Gregory Haskins (1):
>         rt/sched: ensure interrupts are disabled during post-schedule()=

> processing
>
> are available in the git repository at:
>
> =20
> git://git.kernel.org/pub/scm/linux/kernel/git/ghaskins/linux-2.6-hacks.=
git
> rt/sched
>
> Gregory Haskins (6):
>       sched: cleanup inc/dec_rt_tasks
>       sched: track the next-highest priority on each runqueue
>       sched: use highest_prio.curr for pull threshold
>       sched: use highest_prio.next to optimize pull operations
>       sched: de CPP-ify the scheduler code
>       sched: fix build error in kernel/sched_rt.c when RT_GROUP_SCHED &=
&
> !SMP
>
> Peter Zijlstra (1):
>       sched: make plist a library facility
>
>  init/Kconfig      |    1 -
>  kernel/sched.c    |   12 ++-
>  kernel/sched_rt.c |  372
> ++++++++++++++++++++++++++++++++++------------------
>  lib/Kconfig       |    6 -
>  lib/Makefile      |    4 +-
>  5 files changed, 255 insertions(+), 140 deletions(-)
>
>
>  =20



--------------enig99955A69452C03ED1B28036A
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkl3YWEACgkQlOSOBdgZUxmZkgCdGH81CVrIM5ms43BhwHNcnLU9
xrIAn1T1tcik34OP/5iR0Zpt83+0wYJ9
=Qcrk
-----END PGP SIGNATURE-----

--------------enig99955A69452C03ED1B28036A--
