Return-Path: <linux-kernel-owner+w=401wt.eu-S1755982AbYGKPjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755982AbYGKPjA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2008 11:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759923AbYGKPiq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jul 2008 11:38:46 -0400
Received: from tomts16-srv.bellnexxia.net ([209.226.175.4]:48578 "EHLO
	tomts16-srv.bellnexxia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759832AbYGKPip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2008 11:38:45 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AgcFACwYd0hMQWVt/2dsb2JhbACBWq1o
Date: Fri, 11 Jul 2008 11:38:41 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>
Cc: penberg@cs.helsinki.fi, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [RFC PATCH 0/5] kmemtrace RFC patch series
Message-ID: <20080711153841.GA14359@Krystal>
References: <20080710210543.1945415d@linux360.ro>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=_Krystal-15559-1215790721-0001-2"
Content-Disposition: inline
In-Reply-To: <20080710210543.1945415d@linux360.ro>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.21.3-grsec (i686)
X-Uptime: 11:33:29 up 36 days, 20:14,  5 users,  load average: 4.96, 2.71,
	2.37
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_Krystal-15559-1215790721-0001-2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eduard,

Did you have a look at the new tracepoints infrastructure ? I think it
could simplify your patchset a _lot_ !

Basically, it removes the format string from markers and allows to pass
complex structure pointers as arguments. It aims at simplifying the life
of in-kernel tracers which would want to use the facility. Turning a
marker implementation to tracepoints is really straightforward, for an
example see :

http://lkml.org/lkml/2008/7/9/569

For the tracepoints patchset :

http://lkml.org/lkml/2008/7/9/199

I think much of include/linux/kmemtrace.h, which is really just wrappers
around marker code, could then go away.

Regards,

Mathieu

* Eduard - Gabriel Munteanu (eduard.munteanu@linux360.ro) wrote:
> Hi everybody,
>=20
> I'd like to hear your opinion regarding kmemtrace and SL*B hooks.
>=20
> This is just a RFC, it's not intended to be merged yet. The userspace
> app is not included.
>=20
> BTW, there may be some whitespace errors, but disregard them for now,
> they will be fixed.
>=20
> 	Cheers,
> 	Eduard
>=20
>=20
> Eduard - Gabriel Munteanu (5):
>   kmemtrace: Core implementation.
>   Add new GFP flag __GFP_NOTRACE.
>   kmemtrace: SLAB hooks.
>   kmemtrace: SLUB hooks.
>   kmemtrace: SLOB hooks.
>=20
>  MAINTAINERS               |    6 ++
>  include/linux/gfp.h       |    1 +
>  include/linux/kmemtrace.h |  110 +++++++++++++++++++++++
>  include/linux/slab_def.h  |   16 +++-
>  include/linux/slub_def.h  |    9 ++-
>  init/main.c               |    2 +
>  lib/Kconfig.debug         |    4 +
>  mm/Makefile               |    2 +-
>  mm/kmemtrace.c            |  213 +++++++++++++++++++++++++++++++++++++++=
++++++
>  mm/slab.c                 |   35 ++++++--
>  mm/slob.c                 |   37 +++++++--
>  mm/slub.c                 |   49 +++++++++--
>  12 files changed, 460 insertions(+), 24 deletions(-)
>  create mode 100644 include/linux/kmemtrace.h
>  create mode 100644 mm/kmemtrace.c



--=20
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68

--=_Krystal-15559-1215790721-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFId36BPyWo/juummgRAoD1AJ4sTEgnIRULNBTduzj4YbFe7PgvLwCgnKwo
UZqI13YXocUbn1jqGFVqBPU=
=1u5x
-----END PGP SIGNATURE-----

--=_Krystal-15559-1215790721-0001-2--
