Return-Path: <linux-kernel-owner+w=401wt.eu-S933052AbXCOThW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933052AbXCOThW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 15:37:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbXCOThV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 15:37:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933052AbXCOThU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 15:37:20 -0400
Message-ID: <45F9A063.9040205@redhat.com>
Date: Thu, 15 Mar 2007 12:37:07 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Pierre.Peiffer@bull.net, mingo@elte.hu, linux-kernel@vger.kernel.org,
       jean-pierre.dion@bull.net
Subject: Re: [PATCH 2.6.21-rc3-mm2 4/4] sys_futex64 : allows 64bit futexes
References: <20070313095203.154246923@bull.net>	<20070313095549.813330645@bull.net>	<20070315110752.f1df4509.akpm@linux-foundation.org>	<45F99A8B.4050003@redhat.com> <20070315113136.b04ce342.akpm@linux-foundation.org>
In-Reply-To: <20070315113136.b04ce342.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig912616C16651E99560706343"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig912616C16651E99560706343
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> Well OK.  But that doesn't actually explain why 64-bit mutexes are need=
ed.
> It just says they are required.

I can show you the code but it's not easy to understand.  For
complicated syn objects like rwlocks the state information is more than
just locked or not.  Currently we have to use internal locks, modify the
state information, and then release it.  This is terribly inefficient
when many threads are used.  With 64bit futexes the state information
can be kept in the futex object and we don't need an internal lock,
hence the speed-up.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig912616C16651E99560706343
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFF+aBj2ijCOnn/RHQRAsgcAJ42y3dHmB3L5aq6/fOH1WHNKRFUegCgqY76
QMotmx7LbC9jTngCk2+Vw9E=
=y1AV
-----END PGP SIGNATURE-----

--------------enig912616C16651E99560706343--
