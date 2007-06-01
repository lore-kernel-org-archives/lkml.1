Return-Path: <linux-kernel-owner+w=401wt.eu-S1760690AbXFABFg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760690AbXFABFg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 21:05:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757500AbXFABF3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 21:05:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45458 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754686AbXFABF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 21:05:28 -0400
Date: Fri, 1 Jun 2007 11:05:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ulrich Drepper <drepper@redhat.com>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, torvalds@linux-foundation.org,
       Chris Zankel <chris@zankel.net>
Subject: Re: [PATCH] Introduce O_CLOEXEC (take >2)
Message-Id: <20070601110520.5b7d6c30.sfr@canb.auug.org.au>
In-Reply-To: <20070531162021.4cd4e91a.akpm@linux-foundation.org>
References: <200705311809.l4VI9F9X009556@devserv.devel.redhat.com>
	<20070531162021.4cd4e91a.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.12; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Jun_2007_11_05_20_+1000_wLOlppWngMdw=Fgp"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Jun_2007_11_05_20_+1000_wLOlppWngMdw=Fgp
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 31 May 2007 16:20:21 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> This will break xtensa, because that architecture (and only that
> architecture) doesn't include asm-generic/fcntl.h from asm/fcntl.h.

It used to (for a whole 15 months).  Consolidation and cleanup is hard
enough to do once ...

> But let's leave this patch as-is: it's xtensa which needs fixing.

See my other patch ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Jun_2007_11_05_20_+1000_wLOlppWngMdw=Fgp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGX3DVFdBgD/zoJvwRAlvJAJ99tkjLotuDt+3LJIDFe5Nh6KeHpACdEqYx
SbAAnK5IOWDXskADKM8ZKQQ=
=El4/
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Jun_2007_11_05_20_+1000_wLOlppWngMdw=Fgp--
