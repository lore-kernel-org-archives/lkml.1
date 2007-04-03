Return-Path: <linux-kernel-owner+w=401wt.eu-S965765AbXDCRUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965765AbXDCRUQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2007 13:20:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965920AbXDCRUQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Apr 2007 13:20:16 -0400
Received: from mx1.redhat.com ([66.187.233.31]:51280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965765AbXDCRUO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2007 13:20:14 -0400
Message-ID: <46128CC2.9090809@redhat.com>
Date: Tue, 03 Apr 2007 10:20:02 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Rik van Riel <riel@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Jakub Jelinek <jakub@redhat.com>
Subject: Re: missing madvise functionality
References: <46128051.9000609@redhat.com> <p73648dz5oa.fsf@bingen.suse.de>
In-Reply-To: <p73648dz5oa.fsf@bingen.suse.de>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig55DE0CEACF1EBF576272AE34"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig55DE0CEACF1EBF576272AE34
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andi Kleen wrote:
> Why do you need a lock for that? I don't see any problem with
> two threads doing that in parallel. The kernel would
> serialize it internally and one would fail, but that shouldn't
> be a problem.=20

There is no lock at all at userlevel.  I'm talking about locks in the
kernel.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig55DE0CEACF1EBF576272AE34
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGEozC2ijCOnn/RHQRAmqJAKCQR0RSmg3qjSRg7jniAADyPYdnTwCgkj4r
/qjQERP211JdXh805MtX2Dc=
=+kk0
-----END PGP SIGNATURE-----

--------------enig55DE0CEACF1EBF576272AE34--
