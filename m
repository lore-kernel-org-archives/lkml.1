Return-Path: <linux-kernel-owner+w=401wt.eu-S1754326AbYLHQyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754326AbYLHQyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 11:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753416AbYLHQyY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 11:54:24 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:33291 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753343AbYLHQyY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 11:54:24 -0500
Message-ID: <493D5212.8000703@novell.com>
Date: Mon, 08 Dec 2008 11:57:54 -0500
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.18 (X11/20081112)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [git pull] RT scheduler updates for tip
References: <493939B1.40506@novell.com> <20081208143228.GF14856@elte.hu> <20081208161246.GB4570@elte.hu>
In-Reply-To: <20081208161246.GB4570@elte.hu>
X-Enigmail-Version: 0.95.7
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigD1A9BEA8299F7CE5528079BA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigD1A9BEA8299F7CE5528079BA
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Ingo Molnar wrote:
> okay, this series is quite bad so i'm disabling it for now. I sent a=20
> build fix earlier today, then i triggered this build failure:
>
> kernel/built-in.o: In function `dequeue_pushable_task':
> sched.c:(.text+0x4a9f): undefined reference to `plist_del'
> kernel/built-in.o: In function `enqueue_pushable_task':
> sched.c:(.text+0x5734): undefined reference to `plist_del'
> sched.c:(.text+0x5747): undefined reference to `plist_add'
>
> and then this:
>
> kernel/sched_rt.c: In function =E2=80=98next_prio=E2=80=99:
> kernel/sched_rt.c:574: error: =E2=80=98struct rq=E2=80=99 has no member=
 named =E2=80=98cpu=E2=80=99
> kernel/sched_rt.c: In function =E2=80=98inc_rt_tasks=E2=80=99:
> kernel/sched_rt.c:619: error: =E2=80=98rq=E2=80=99 undeclared (first us=
e in this function)
> kernel/sched_rt.c:619: error: (Each undeclared identifier is reported o=
nly once
> kernel/sched_rt.c:619: error: for each function it appears in.)
> kernel/sched_rt.c: In function =E2=80=98dec_rt_tasks=E2=80=99:
> kernel/sched_rt.c:667: error: =E2=80=98rq=E2=80=99 undeclared (first us=
e in this function)
>
>
> 	Ingo
>  =20

Can you send your .config?

-Greg


--------------enigD1A9BEA8299F7CE5528079BA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkk9UhMACgkQlOSOBdgZUxlPDQCghMnIQg/qhgi1JRlJmzYpGM9c
nmgAmwcaGdzwxzkfVPVgXfx2J8Hk4lt3
=4G9I
-----END PGP SIGNATURE-----

--------------enigD1A9BEA8299F7CE5528079BA--
