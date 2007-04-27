Return-Path: <linux-kernel-owner+w=401wt.eu-S1755308AbXD0Azy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308AbXD0Azy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2007 20:55:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXD0Azx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Apr 2007 20:55:53 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44478 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755308AbXD0Azw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2007 20:55:52 -0400
Message-ID: <46314A08.9000209@redhat.com>
Date: Thu, 26 Apr 2007 17:55:36 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] utimensat implementation
References: <200704262249.l3QMn5C2021588@devserv.devel.redhat.com> <20070426162530.bc30a1bb.akpm@linux-foundation.org> <46313F99.6080402@zytor.com>
In-Reply-To: <46313F99.6080402@zytor.com>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig703AAFA77841E281E15EFAED"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig703AAFA77841E281E15EFAED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

H. Peter Anvin wrote:
> I'm a bit leery of abusing the timespec value like this, though.  A
> flags field seem like it would be cleaner.

It's ugly.  Then you have the parameter, which might have nice valid
values, and they get ignored.  I thought about it when this was
discussed in the working group and thought it's a toss up.


> Something else... if we're dickering with these interfaces, shouldn't w=
e
> allow setting atime as well?

Why?  To allow somebody to hide her/his tracks?

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enig703AAFA77841E281E15EFAED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMUoI2ijCOnn/RHQRAr2NAJoDUzgRrloXp/M5MkRCDQawNWA2hgCfRdet
FRoGOWhlk28tzgdtAynnSNE=
=BKZO
-----END PGP SIGNATURE-----

--------------enig703AAFA77841E281E15EFAED--
