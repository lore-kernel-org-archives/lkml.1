Return-Path: <linux-kernel-owner+w=401wt.eu-S1945986AbXDCVrl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945986AbXDCVrl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 17:47:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1945993AbXDCVrl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 17:47:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945986AbXDCVrk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 17:47:40 -0400
Message-ID: <4612CB21.9020005@redhat.com>
Date: Tue, 03 Apr 2007 14:46:09 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Eric Dumazet <dada1@cosmosbay.com>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>, linux-mm@kvack.org,
       Hugh Dickins <hugh@veritas.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com>	<p73648dz5oa.fsf@bingen.suse.de>	<46128CC2.9090809@redhat.com>	<20070403172841.GB23689@one.firstfloor.org>	<20070403125903.3e8577f4.akpm@linux-foundation.org>	<4612B645.7030902@redhat.com> <20070403135154.61e1b5f3.akpm@linux-foundation.org> <4612C059.8070702@redhat.com> <4612C2B6.3010302@cosmosbay.com>
In-Reply-To: <4612C2B6.3010302@cosmosbay.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8B4ABF0E8D079DF4795C119E"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8B4ABF0E8D079DF4795C119E
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Eric Dumazet wrote:
> A page fault is not that expensive. But clearing N*PAGE_SIZE bytes is,
> because it potentially evicts a large part of CPU cache.

*A* page fault is not that expensive.  The problem is that you get a
page fault for every single page.  For 200k allocated you get 50 page
faults.  It quickly adds up.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig8B4ABF0E8D079DF4795C119E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEssh2ijCOnn/RHQRAt7qAJ9U+1b0HKgq1LwNoBh/PZUhEr7dtgCfakvE
pqzrkxFMAYLB2LW5Xh1W2W4=
=oN5m
-----END PGP SIGNATURE-----

--------------enig8B4ABF0E8D079DF4795C119E--
