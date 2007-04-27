Return-Path: <linux-kernel-owner+w=401wt.eu-S1755922AbXD0OZ5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922AbXD0OZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2007 10:25:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755876AbXD0OZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Apr 2007 10:25:57 -0400
Received: from mx1.redhat.com ([66.187.233.31]:45272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755877AbXD0OZm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2007 10:25:42 -0400
Message-ID: <463207BC.1060907@redhat.com>
Date: Fri, 27 Apr 2007 07:25:00 -0700
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] v3: utimensat implementation
References: <200704270308.l3R38axl031062@devserv.devel.redhat.com> <20070427005010.d58ac519.akpm@linux-foundation.org>
In-Reply-To: <20070427005010.d58ac519.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.3.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCBF3113F022B0C3FAE5136ED"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCBF3113F022B0C3FAE5136ED
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> there's a little bit of intersection with lutimesat() there.

I totally forgot about this.  Please do not merge the current lutimesat
patch.  We have to change it to lutimensat() the same way this new
utimensat() improves over futimesat().

Do yo have the broken out patch somewhere?  I'll make the change and
merge it with the utimensat patch.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigCBF3113F022B0C3FAE5136ED
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFGMge82ijCOnn/RHQRAhUFAJ9YEO2jXUt5mySO3TP9JWYt+J0J7ACgu40R
dFNLUbQPtLqJQ8MD6C0s3DM=
=j8nN
-----END PGP SIGNATURE-----

--------------enigCBF3113F022B0C3FAE5136ED--
