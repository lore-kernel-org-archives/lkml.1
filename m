Return-Path: <linux-kernel-owner+w=401wt.eu-S1945932AbXDCU6B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945932AbXDCU6B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 16:58:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753652AbXDCU6B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 16:58:01 -0400
Received: from mx1.redhat.com ([66.187.233.31]:57736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753648AbXDCU56 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 16:57:58 -0400
Message-ID: <4612BFBA.6050101@redhat.com>
Date: Tue, 03 Apr 2007 13:57:30 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Andi Kleen <andi@firstfloor.org>, Rik van Riel <riel@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org>
In-Reply-To: <20070403135154.61e1b5f3.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig1D8B3700AB45FB5EE6459E40"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig1D8B3700AB45FB5EE6459E40
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> But whatever we do, with the current MM design we need to at least take=
 the
> mmap_sem for reading so we can descend the vma tree and locate the
> pageframes.  And if that locking is the main problem then none of this =
is
> likely to help.

At least it's done only once for the madvise call and not twice as of
today with mmap and mprotect both needing the semaphore.  This can
reduce the contention quite a bit.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig1D8B3700AB45FB5EE6459E40
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEr+62ijCOnn/RHQRAgVXAKDEQk4d22BCNnfjr1z1DLvhbvT/gACfQiVS
2yTEt7kyj8p7zwlRvm0N98M=
=7yqI
-----END PGP SIGNATURE-----

--------------enig1D8B3700AB45FB5EE6459E40--
