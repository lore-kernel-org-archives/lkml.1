Return-Path: <linux-kernel-owner+w=401wt.eu-S1752134AbXAZUpd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134AbXAZUpd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jan 2007 15:45:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752141AbXAZUpd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 26 Jan 2007 15:45:33 -0500
Received: from mx1.redhat.com ([66.187.233.31]:45887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752134AbXAZUpb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jan 2007 15:45:31 -0500
Message-ID: <45BA6860.6040007@redhat.com>
Date: Fri, 26 Jan 2007 12:45:20 -0800
From: Ulrich Drepper <drepper@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Thunderbird 1.5.0.9 (X11/20061219)
MIME-Version: 1.0
To: Andrew Morton <akpm@osdl.org>
CC: Alexey Dobriyan <adobriyan@openvz.org>, devel@openvz.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] lutimesat: actual syscall and wire-up on i386
References: <20070126112345.GC11128@localhost.sw.ru> <20070126123903.046aaa5e.akpm@osdl.org>
In-Reply-To: <20070126123903.046aaa5e.akpm@osdl.org>
X-Enigmail-Version: 0.94.1.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDD50FF3089ACBF9F18024878"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDD50FF3089ACBF9F18024878
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Andrew Morton wrote:
> OK, but I don't recall having seeing a demand for lutimes().  Opinions
> are sought?

It's an interface which has been available on other platforms forever
(lutimes, not lutimesat).  If it can be implemented correctly on the
interesting file systems I'd say "go ahead", it can only be useful and
have more benefits than the probably small cost of implementing it.

If on the other hand important filesystems cannot support lutimes then
I'd wait with introducing the syscall at least until the support is
added.  It much easier to cope with unavailable syscalls then it is with
partially working ones.

--=20
=E2=9E=A7 Ulrich Drepper =E2=9E=A7 Red Hat, Inc. =E2=9E=A7 444 Castro St =
=E2=9E=A7 Mountain View, CA =E2=9D=96


--------------enigDD50FF3089ACBF9F18024878
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org

iD8DBQFFumhg2ijCOnn/RHQRAlTjAJ4vcVD7oysFh2Lbfbjf9N0RvtfEcACaA7WA
Y57md4F3Hv4WBfZSnxOFjKY=
=aR91
-----END PGP SIGNATURE-----

--------------enigDD50FF3089ACBF9F18024878--
