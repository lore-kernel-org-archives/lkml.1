Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZFHCSb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZFHCSb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 22:18:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753987AbZFHCSY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 22:18:24 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42444 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752892AbZFHCSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 22:18:23 -0400
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org
Cc: Chris Adams <cmadams@hiwaay.net>, 510478@bugs.debian.org
In-Reply-To: <20090103180148.GA1375968@hiwaay.net>
References: <3ae3aa420901021125n1153053fsdf2378e7d11abbc0@mail.gmail.com>
	 <20090103002114.GA1538533@hiwaay.net>
	 <20090103022358.GA2454@dastardly.home.dghda.com>
	 <20090103044143.GB1538533@hiwaay.net>
	 <20090103045227.GA5994@dastardly.home.dghda.com>
	 <20090103180148.GA1375968@hiwaay.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KvmYTpY8+Ac8PEb2spJK"
Date: Mon, 08 Jun 2009 03:18:18 +0100
Message-Id: <1244427498.21215.200.camel@deadeye>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1.1 
X-SA-Exim-Connect-IP: 192.168.4.182
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [PATCH] v2 Re: Bug: Status/Summary of slashdot leap-second
 crash on new years 2008-2009
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KvmYTpY8+Ac8PEb2spJK
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2009-01-03 at 12:01 -0600, Chris Adams wrote:
> Once upon a time, Duane Griffin <duaneg@dghda.com> said:
> > How about instead of a switch statement, assigning the message to a
> > variable and printing that. I.e. something like:
>=20
> Good point.  Here's an updated version that also adds a comment to the
> xtime_lock definition about not using printk.
> --=20
> Chris Adams <cmadams@hiwaay.net>
> Systems and Network Administrator - HiWAAY Internet Services
> I don't speak for anybody but myself - that's enough trouble.
>=20
>=20
> From: Chris Adams <cmadams@hiwaay.net>
>=20
> The code to handle leap seconds printks an information message when the
> second is inserted or deleted.  It does this while holding xtime_lock.
> However, printk wakes up klogd, and in some cases, the scheduler tries
> to get the current kernel time, trying to get xtime_lock (which results
> in a deadlock).  This moved the printks outside of the lock.  It also
> adds a comment to not use printk while holding xtime_lock.
[...]

This patch doesn't seem to have gone anywhere.  Was this bug fixed in
some other way or has it been forgotten?

Ben.

--=20
Ben Hutchings
Logic doesn't apply to the real world. - Marvin Minsky

--=-KvmYTpY8+Ac8PEb2spJK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQBKLHTp79ZNCRIGYgcRAjIOAJ9RdCEOZFi5w+8Bl7sHqc1x8xEv1ACgocCj
0FXjGhr++BNqRVET7XqokCo=
=VQpK
-----END PGP SIGNATURE-----

--=-KvmYTpY8+Ac8PEb2spJK--
