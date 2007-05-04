Return-Path: <linux-kernel-owner+w=401wt.eu-S1031015AbXEDQFL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031015AbXEDQFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2007 12:05:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031020AbXEDQFL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 May 2007 12:05:11 -0400
Received: from mx1.redhat.com ([66.187.233.31]:33531 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031015AbXEDQFI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2007 12:05:08 -0400
Message-ID: <463B598B.80200@redhat.com>
Date: Fri, 04 May 2007 09:04:27 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Nick Piggin <nickpiggin@yahoo.com.au>
CC: Rik van Riel <riel@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: [PATCH] MM: implement MADV_FREE lazy freeing of anonymous memory
References: <4632D0EF.9050701@redhat.com> <463B108C.10602@yahoo.com.au>
In-Reply-To: <463B108C.10602@yahoo.com.au>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB9E51AA9AB8A92368961C143"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB9E51AA9AB8A92368961C143
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Nick Piggin wrote:
> What I found is that, on this system, MADV_FREE performance improvement=

> was in the noise when you look at it on top of the MADV_DONTNEED glibc
> and down_read(mmap_sem) patch in sysbench.

I don't want to judge the numbers since I cannot but I want to make an
observations: even if in the SMP case MADV_FREE turns out to not be a
bigger boost then there is still the UP case to keep in mind where Rik
measured a significant speed-up.  As long as the SMP case isn't hurt
this is reaosn enough to use the patch.  With more and more cores on one
processor SMP systems are pushed evermore to the high-end side.  You'll
find many installations which today use SMP will be happy enough with
many-core UP machines.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigB9E51AA9AB8A92368961C143
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGO1mL2ijCOnn/RHQRAjv8AJ9zZVuzkgK54Pt7kJYSkZWfHVnvrwCgkyVV
hldTUN/cq7b2y8tPOqgb0ZU=
=woM3
-----END PGP SIGNATURE-----

--------------enigB9E51AA9AB8A92368961C143--
