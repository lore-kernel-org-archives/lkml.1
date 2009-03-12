Return-Path: <linux-kernel-owner+w=401wt.eu-S1755414AbZCLHIU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755414AbZCLHIU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Mar 2009 03:08:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751690AbZCLHIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Mar 2009 03:08:10 -0400
Received: from 82-117-125-11.tcdsl.calypso.net ([82.117.125.11]:44722 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751539AbZCLHIJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Mar 2009 03:08:09 -0400
Date: Thu, 12 Mar 2009 08:07:58 +0100
From: Pierre Ossman <drzeus@drzeus.cx>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Wu Fengguang <fengguang.wu@intel.com>, Pekka Paalanen <pq@iki.fi>,
       Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH 0/4] [GIT PULL] memory saving ring buffer for
 tip/tracing/ftrace
Message-ID: <20090312080758.4a14d5b4@mjolnir.ossman.eu>
In-Reply-To: <20090312023720.144716747@goodmis.org>
References: <20090312023720.144716747@goodmis.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.15.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1; protocol="application/pgp-signature"; boundary="=_freyr.drzeus.cx-6291-1236841684-0001-2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_freyr.drzeus.cx-6291-1236841684-0001-2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Mar 2009 22:37:20 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Ingo,
>=20
> This patch series implements a better memory management by the
> ring buffer. It only allocates the buffers for the online CPUS, as well
> as keeps the buffers to a minimum size until they are used.
>=20
> Please pull the latest tip/tracing/ftrace tree, which can be found at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.g=
it
> tip/tracing/ftrace
>=20
>=20
> Steven Rostedt (4):
>       tracing: keep ring buffer to minimum size till used
>       tracing: expand the ring buffers when an event is activated
>       tracing: fix trace_wait to know to wait on all cpus or just one
>       ring-buffer: only allocate buffers for online cpus
>=20

How difficult is it to apply this to 2.6.27? Fedora is still on that
kernel and it would be nice if I could get my memory back on a
distribution kernel. :)

Rgds
--=20
     -- Pierre Ossman

  WARNING: This correspondence is being monitored by the
  Swedish government. Make sure your server uses encryption
  for SMTP traffic and consider using PGP for end-to-end
  encryption.

--=_freyr.drzeus.cx-6291-1236841684-0001-2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.11 (GNU/Linux)

iEYEARECAAYFAkm4tNAACgkQ7b8eESbyJLg+ZwCdGxWc4ZlzC+B3UkVgbbp6qKD9
B/MAoPW0n2+odTLWPriyaRE/P6/Gi8Z0
=hbr4
-----END PGP SIGNATURE-----

--=_freyr.drzeus.cx-6291-1236841684-0001-2--
