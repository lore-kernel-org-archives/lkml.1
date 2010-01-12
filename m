Return-Path: <linux-kernel-owner+w=401wt.eu-S1752567Ab0ALCjK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752567Ab0ALCjK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:39:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529Ab0ALCjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:39:09 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55726 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751112Ab0ALCjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:39:08 -0500
Date: Tue, 12 Jan 2010 13:39:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>,
       Phillip Lougher <phillip@lougher.demon.co.uk>
Subject: Re: linux-next: origin tree build failure
Message-Id: <20100112133900.f22b3b72.sfr@canb.auug.org.au>
In-Reply-To: <20100112133252.8b4591bd.sfr@canb.auug.org.au>
References: <20100112121434.49930eea.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1001111720290.17145@localhost.localdomain>
	<20100112133252.8b4591bd.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Jan_2010_13_39_00_+1100_Ak6an=j0EUIuF11q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jan_2010_13_39_00_+1100_Ak6an=j0EUIuF11q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Jan 2010 13:32:52 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> I guess there is something else in the partially
> created linux-next today that has triggered this build failure.   I will
> investigate further.

Yes, there are two commits in the squashfs tree that rearrange some of
the decompression code.  They are:

"lzma: Make lzma available to non initramfs/initrd code"
"lzma: make lzma reentrant"

Phillip, you need to merge Linus' tree (or rebase on it) and fix those up
for the introduction of the LZO decompression stuff.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Jan_2010_13_39_00_+1100_Ak6an=j0EUIuF11q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktL4MQACgkQjjKRsyhoI8x+agCeNJ0bIpbksbuQG+qYqi6OaUAv
SO0An34WPgRxiSGNSSZtloQJC6vMEmtV
=TSzZ
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jan_2010_13_39_00_+1100_Ak6an=j0EUIuF11q--
