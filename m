Return-Path: <linux-kernel-owner+w=401wt.eu-S1754384AbZGUKrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384AbZGUKrN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 06:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754024AbZGUKrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 06:47:13 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:59201 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754194AbZGUKrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 06:47:12 -0400
Subject: Re: binary ftrace buffer format
From: Johannes Berg <johannes@sipsolutions.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com>
References: <1247520189.4071.4.camel@johannes.local>
	 <alpine.DEB.2.00.0907202148140.11494@gandalf.stny.rr.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Ff242xY9EgsjbpZCynPL"
Date: Tue, 21 Jul 2009 12:46:39 +0200
Message-Id: <1248173199.11045.0.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Ff242xY9EgsjbpZCynPL
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2009-07-20 at 21:51 -0400, Steven Rostedt wrote:

> I have a tool called trace-cmd (I'm looking into porting it to the perf=20
> tool) but it currently does what you want. I've tested it on both 32 bit=20
> and 64 bit systems as well as big and little endians. The files can be=20
> created on one system and read on another. It contains data in the files=20
> to let other systems know how to read it.
>=20
> You can get the tool here:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/trace-cmd.git

Nice! I'll give it a whirl, in the meantime I've already found the
problem I was looking for though.

> Currently, we have not the need to trace more than a page. But this is=20
> something that can be changed in the future, but currently we have not ha=
d=20
> the need, and when it was developed, Linus suggested pages would be fine.

Fair enough.

johannes

--=-Ff242xY9EgsjbpZCynPL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKZZyLAAoJEODzc/N7+QmawOUP/3U/r79pQ6MRvBosgshXpOKe
NLKwdwK9vAT1XgX7wNBMWXhWYIZ8E/1RD0V7BjOtQSLfdpTBWOv+kpjrMGmKd4UZ
AXN4X3cG+6XT5i4IRtiVR7xXIp/uFvtAEjWub4W1cFOmyMVcuKA51SURwtxa/zHf
sBTxOX2A/NorLwMmFZN6IZGstjcKZ46O6TrfcJXbsnIuIb+eFBuIGicRsiRZXDwy
8ixBqJ1PQVGQ41sEN8DYu3IBpr9ILJUIhA5gfvE/yuBTSRuhs6FvEAgoqZvLFuDs
IQO9OwYppYdyRZ5cvBuoSGMPHCKY88S1LSFaFKnuYNHeOUDZtTYQV/mLEOF6/Up/
1mNNqJkKJmpmVvqcmY1pJhLlC6IBVhvVO+W8ayzwubdyGYZbaIV20yGVdKpfF3eI
yErQ9ohD54yMONQcCuQHeiG8xAY0A40SSRDCRMn/y7jHCmhZJlne49pC4VmnPYGG
POyHAOmxZUNYdomM+r7CkT+n7EmKv3mwjKejhvehyr8FaFuv2+r7bGlfnCQXUl21
rfIM9l1HywF9mvXwXcRBDJM5qUQdcCOkiAKMfOt9urxu4b8E+IW6jDlCwVY5xamI
FxsLhI3GdG6mDJxjUyoyazwkGe0hFYaC8qiWUm8Z00cqNrx6/NLmbaJpwTRG8Qn6
TlJ9ht1jHzfzVwXxSoKl
=8oCq
-----END PGP SIGNATURE-----

--=-Ff242xY9EgsjbpZCynPL--

