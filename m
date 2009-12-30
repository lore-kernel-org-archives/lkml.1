Return-Path: <linux-kernel-owner+w=401wt.eu-S1751528AbZL3A4U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528AbZL3A4U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Dec 2009 19:56:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751418AbZL3A4S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Dec 2009 19:56:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48664 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751340AbZL3A4S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Dec 2009 19:56:18 -0500
Date: Wed, 30 Dec 2009 11:56:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove macro MAXHOSTNAMELEN from <asm-generic/param.h>.
Message-Id: <20091230115610.c10599b8.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.0912291929010.6325@localhost>
References: <alpine.LFD.2.00.0912291929010.6325@localhost>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__30_Dec_2009_11_56_10_+1100_w7LWapa3F6R3kEN5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__30_Dec_2009_11_56_10_+1100_w7LWapa3F6R3kEN5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Robert,

On Tue, 29 Dec 2009 19:32:15 -0500 (EST) "Robert P. J. Day" <rpjday@crashco=
urse.ca> wrote:
>
> Since nothing in the entire tree makes use of this macro, remove it.
> This removal should eventually propagate to all of the arch-specific
> param.h files.

Except if the only place this is picked up by glibc is the kernel header
files, then it will disappear from user mode and some packages may break.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__30_Dec_2009_11_56_10_+1100_w7LWapa3F6R3kEN5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAks6pSoACgkQjjKRsyhoI8yFJgCffydGmHddBgLShlltYmMOXt/F
UnsAoKdmMArRpUa4OvGfTa2YW5igVUfb
=WKXh
-----END PGP SIGNATURE-----

--Signature=_Wed__30_Dec_2009_11_56_10_+1100_w7LWapa3F6R3kEN5--
