Return-Path: <linux-kernel-owner+w=401wt.eu-S1753842AbYLHQLW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842AbYLHQLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:11:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753183AbYLHQLO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:11:14 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:37185 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752560AbYLHQLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:11:13 -0500
Message-ID: <493D47EC.6090600@novell.com>
Date: Mon, 08 Dec 2008 11:14:36 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] sched: fix build failure in kernel/sched_rt.c
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208160557.GA4570@elte.hu>
In-Reply-To: <20081208160557.GA4570@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD64102A1BB718F9B7EA4174"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD64102A1BB718F9B7EA4174
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> From a9750309ef51081abb17268936769511b3683488 Mon Sep 17 00:00:00 2001
> From: Ingo Molnar <mingo@elte.hu>
> Date: Mon, 8 Dec 2008 16:39:24 +0100
> Subject: [PATCH] sched: fix build failure in kernel/sched_rt.c
> MIME-Version: 1.0
> Content-Type: text/plain; charset=3Dutf-8
> Content-Transfer-Encoding: 8bit
>
> Impact: build fix
>  =20

Doh!

-Greg "always breakin' uniprocessor" Haskins

(sorry)

> fix:
>
>  kernel/sched_rt.c: In function =91inc_rt_tasks=92:
>  kernel/sched_rt.c:593: error: =91prio=92 undeclared (first use in this=
 function)
>  kernel/sched_rt.c:593: error: (Each undeclared identifier is reported =
only once
>  kernel/sched_rt.c:593: error: for each function it appears in.)
>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  kernel/sched_rt.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched_rt.c b/kernel/sched_rt.c
> index c5b1c5a..64a8f0a 100644
> --- a/kernel/sched_rt.c
> +++ b/kernel/sched_rt.c
> @@ -583,9 +583,7 @@ static inline int next_prio(struct rq *rq)
>  static inline
>  void inc_rt_tasks(struct sched_rt_entity *rt_se, struct rt_rq *rt_rq)
>  {
> -#if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
>  	int prio =3D rt_se_prio(rt_se);
> -#endif
>  #ifdef CONFIG_SMP
>  	struct rq *rq =3D rq_of_rt_rq(rt_rq);
>  #endif
>  =20



--------------enigDD64102A1BB718F9B7EA4174
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkk9R+wACgkQlOSOBdgZUxlqgACeI95BMSnV7IKsNiixbdMqmkJ9
xkIAnjrwa+Z3ER4eRtXrhPLv8TtKdQsa
=Xrr4
-----END PGP SIGNATURE-----

--------------enigDD64102A1BB718F9B7EA4174--
