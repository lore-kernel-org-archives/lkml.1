Return-Path: <linux-kernel-owner+w=401wt.eu-S1755161AbZKNJVm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755161AbZKNJVm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Nov 2009 04:21:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754900AbZKNJVl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Nov 2009 04:21:41 -0500
Received: from xc.sipsolutions.net ([83.246.72.84]:56131 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754753AbZKNJVk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Nov 2009 04:21:40 -0500
Subject: Re: [PATCH 2.6.32] ftrace: fix event format export
From: Johannes Berg <johannes@sipsolutions.net>
To: rostedt@goodmis.org
Cc: Ingo Molnar <mingo@elte.hu>, Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1258154909.22249.211.camel@gandalf.stny.rr.com>
References: <1258115870.6167.4.camel@johannes.local>
	 <20091113224009.GB23942@elte.hu>
	 <1258154909.22249.211.camel@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-vZVDROz0IwMy2KA7LwNb"
Date: Sat, 14 Nov 2009 10:21:38 +0100
Message-ID: <1258190498.6167.31.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vZVDROz0IwMy2KA7LwNb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-11-13 at 18:28 -0500, Steven Rostedt wrote:

> > > Use
> > > 	"\"%s\"", fmt
> > > instead of
> > > 	"%s", #fmt
> > > to export the string and not the way it is built.
>=20
> Is there any examples of this currently in the kernel? If so could you
> show that in the changlog.

net/mac80211/driver-trace.h has some that are exported really badly and
both trace-cmd and perf fall over on them.

Incidentally, the kvm_mmu ones are also weird, but I'm not sure they can
be fixed up properly.

Do you think Andreas's objection to the now-missing escaping of " and \
is a problem, or should we either fix the parsers to parse the string
backward from REC stuff, or fix the routine that outputs them to
userspace to quote " and \?

johannes

--=-vZVDROz0IwMy2KA7LwNb
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJK/nafAAoJEODzc/N7+QmaiRAQAKYgDrKY7KcJ/z8sZonCTN40
dj1B1wE4+yjavosshd7YBzxa8OPhA1c6sMEa3FFkSr0kmYKgxt97DjW6upAxoHCC
NYal3xgxmCAcTp4yDUk7py7+nDKGdhDaImNN8nWNA847JpbB8UWEEFB8GSqbeiDS
HNVl8SXXnpoy4vP0KDtLFJmi/vQpFBYK8jptpT+8uelakoiGhhpWYSwo3qz+fFh/
3kOf/2tpRhadAoFWMFufX6CzdxhXdrtUoM0n7rJBoqZnwUXARdMI+N5TZlRZ3cAH
bp+5QRQE7soczK+LS5uPsdo5CEJ4WdUs62afA2X17ggd60YDugDnrXkUtHHuUXzc
HdIAeMFisSF9JaV5F15w0sjZXyNC6xhb3G9B31HZx8pXEC4vsFRO4yZ4PpLtAsJt
B/BYr+4M6zqITjki+NfKDk8ZBUwstpFQGzCoGO9N01vCAUbQdu/6AvaQl1rrI07s
vDpeZYY7yTydC0vcO6A/Y48f5gIhFUO4cG8/BA9DGuL7J4gZMpJnLemE5g0e6qdh
hCIXzJP5o58u0A4rlflZ1TuyO7Mkp/rSenCKe6xRSw41DWvdSZlKRkKgGfCoId2y
NCAkIv291PnLtsMBqmJ4g7S0l6s68f93wkHXz8QrcCVB53yHGGqKnsNyRJ9Diixf
m+N1vO2WgCJkNhnZ/Bx5
=A3Ue
-----END PGP SIGNATURE-----

--=-vZVDROz0IwMy2KA7LwNb--

