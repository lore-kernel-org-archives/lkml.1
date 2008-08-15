Return-Path: <linux-kernel-owner+w=401wt.eu-S1755020AbYHOLZ1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020AbYHOLZ1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 07:25:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYHOLZS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 07:25:18 -0400
Received: from victor.provo.novell.com ([137.65.250.26]:33061 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbYHOLZR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 07:25:17 -0400
Message-ID: <48A5670C.2080805@novell.com>
Date: Fri, 15 Aug 2008 07:22:52 -0400
From: Gregory Haskins <ghaskins@novell.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080720)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Roland McGrath <roland@redhat.com>, Ulrich Drepper <drepper@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       "Luis Claudio R. Goncalves" <lclaudio@uudg.org>,
       Clark Williams <williams@redhat.com>, Bruce Duncan <bwduncan@gmail.com>,
       Marcin Slusarz <marcin.slusarz@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH v2 0/6] ftrace: to kill a daemon (small updates)
References: <20080814194506.233473381@goodmis.org> <20080815092412.GC22209@elte.hu>
In-Reply-To: <20080815092412.GC22209@elte.hu>
X-Enigmail-Version: 0.95.6
OpenPGP: id=D8195319
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6B1DA94D4FA432BA8749DD52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6B1DA94D4FA432BA8749DD52
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: quoted-printable

(From the original mail)

Steven Rostedt wrote:
>
> Along came Gregory Haskins, who was bickering about having ftrace enabl=
ed
> on a production -rt kernel. I told him the reasons that this would be b=
ad
> and then he started thinking out loud, and suggesting wild ideas, like
> patching gcc!
>  =20
^^^^^^^^^^

Ingo Molnar wrote:
> Eventually gcc should be extended to provide a separate section for=20
> instrumentation patch sites, instead of us having to disassemble the=20
> object code.=20

:)

I obviously agree with this, so +1

Though, tbh, at the time I suggested it I didn't think of Steve's idea=20
to post-process which was quite clever. But I do agree that having gcc=20
do it will probably save some build time since it will probably be=20
trivial for it to do this when already processing -pg. It would have the =

added benefit of letting the arch specific toolchain do the arch=20
specific work (though I think Steve's solution capitalizes on the=20
toolchain extensively as it is).

The biggest downside is that we would have an external dependency on gcc =

for the feature, but I guess the kernel already has some of those anyway =

(e.g. the stack overflow guard feature, etc). We could always fall back=20
on Steve's post-processing if the toolchain lacks the feature.

-Greg


--------------enig6B1DA94D4FA432BA8749DD52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.9 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iEYEARECAAYFAkilZwwACgkQlOSOBdgZUxnNTwCfY6Foj4/ABk3NX31howqh5NoR
dYAAoI0bzCYlHI8C9L8pNrnW03txphRA
=1puy
-----END PGP SIGNATURE-----

--------------enig6B1DA94D4FA432BA8749DD52--
