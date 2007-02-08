Return-Path: <linux-kernel-owner+w=401wt.eu-S1423018AbXBHQMk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423018AbXBHQMk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 11:12:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423111AbXBHQMk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 11:12:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:39138 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423018AbXBHQMj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 11:12:39 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] export ufs_fs.h to userspace
Date: Thu, 8 Feb 2007 11:12:22 -0500
User-Agent: KMail/1.9.6
Cc: dushistov@mail.ru, linux-kernel@vger.kernel.org, sparc@gentoo.org
References: <200702080246.16996.vapier@gentoo.org> <200702081010.51790.vapier@gentoo.org> <1170950377.8675.60.camel@laptopd505.fenrus.org>
In-Reply-To: <1170950377.8675.60.camel@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1269227.K63AvDIclD";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200702081112.23632.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1269227.K63AvDIclD
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 08 February 2007, Arjan van de Ven wrote:
> On Thu, 2007-02-08 at 10:10 -0500, Mike Frysinger wrote:
> > On Thursday 08 February 2007, Arjan van de Ven wrote:
> > > On Thu, 2007-02-08 at 02:46 -0500, Mike Frysinger wrote:
> > > > was ufs_fs.h purposefully not exported to userspace or did it just
> > > > slip through the cracks ?  assuming the latter scenario, the attach=
ed
> > > > patch touches up the relationship between ufs_fs.h and its sub
> > > > headers (like ufs_fs_sb.h) so that we can export it ... the silo
> > > > bootloader takes advantage of this header for example
> > >
> > > are you sure it actually uses anything from this header, and not just
> > > assumes the magic number to be there??
> > > (also.. I kind of would think it reasonable for things with their own
> > > UFS fs reader to have their own header)
> >
> > silo utilizes the structures and the random defines so that it can query
> > UFS filesystems directly
>
> at which point arguably it should have it's own UFS header.
> It's not using the UFS header to use as *kernel* interface!!

true, and i wont argue that point too much other than to say it's nice that=
=20
the kernel provides it so as to reduce code duplication in the world

in more realistic terms, not exporting the ufs_fs.h header prevents any sor=
t=20
of raw filesystem checkers which would be running in userspace, but then=20
again i cant quote any such packages that actually exist ;)

in the end, it doesnt really matter to me right now one way or the other as=
=20
the silo guys do include some ufs code to handle the case where it is being=
=20
built by a non-linux toolchain
=2Dmike

--nextPart1269227.K63AvDIclD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.2 (GNU/Linux)

iQIVAwUARctL50FjO5/oN/WBAQK1BQ/+MkEhQDHmqHGEeIxusmgvXXdcK+8+8wv7
id4btcDNtg9dBpen9LHXA2RufdhQRcDU9/3cJ0U68E1vDP1Au9GKgeb4Agh6gV5U
3Vy8b+Xh1Jqe1F0I9PPo0QadoDoxtNOBfxrVgea3Rrn1zm+QCSl/nIV6fDUq+pPS
emdIS8xyMIcILmfhAALx7sBfHVMtlqyvho/drxiW78Hpo7BMcSzn8iHQ8anNwzvQ
kHFp6+rFAnbBM4077oIR8b03OJQvYTJWiVuFSIZsAaUd7qPRz+REIIvbMxP78w1O
AixuS9gAIsLeRWcyRN31yzO7ajRC9SlVXFF9Shto80EzdpYgiZVKwqwhbef8CFtI
5QcatJm03ytz4h/3XdnyKmMFN6HGH4N8gUCYidMf0fEYaq7762wNiB/bHRM/ALEY
hInAnPtIH7+i4QXNZitAXWezvyonKbV0bIdszkUnVFwmicXothAK6V5kO9SJJjPi
clhD5dPFxg4jjpGbn9lPzR2UQSofhXMoy48AjWcnqTD9kLTh3w7E5ywYwVEwjRgC
C0ZxHIyQ2GevaBKOL6RFssmeOAf66uTpq/YYRD7NEd0/0WYTsvPLKObMFzXixXWz
2xv3i0cGXAZgsJVA6SV07mCLQcU+kfBgfq4YI03ErFfndRf2YXtmHGc/P6WjzmK7
IYcqlajW47c=
=0lC4
-----END PGP SIGNATURE-----

--nextPart1269227.K63AvDIclD--
