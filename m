Return-Path: <linux-kernel-owner+w=401wt.eu-S1754121AbZFVIe2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121AbZFVIe2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jun 2009 04:34:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753314AbZFVIeV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 22 Jun 2009 04:34:21 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46251 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbZFVIeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jun 2009 04:34:20 -0400
Date: Mon, 22 Jun 2009 18:34:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       ppc-dev <linuxppc-dev@lists.ozlabs.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       James Simmons <jsimmons@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
       Krzysztof Helt <krzysztof.h1@poczta.fm>,
       Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Subject: Re: [PATCH] fbdev: work around old compiler bug
Message-Id: <20090622183415.46fa786b.sfr@canb.auug.org.au>
In-Reply-To: <20090622180420.2e0424e4.sfr@canb.auug.org.au>
References: <20090622180420.2e0424e4.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.2; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__22_Jun_2009_18_34_15_+1000_ppHojJRl/ruUqHwd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__22_Jun_2009_18_34_15_+1000_ppHojJRl/ruUqHwd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Jun 2009 18:04:20 +1000 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> When building with a 4.1.x compiler on powerpc64 (at least) we get
> this error:

Ignore this, it causes more problems:

drivers/video/logo/logo_linux_clut224.c:548: error: logo_linux_clut224_clut=
 causes a section type conflict

I'll work on a better solution.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__22_Jun_2009_18_34_15_+1000_ppHojJRl/ruUqHwd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAko/QgcACgkQjjKRsyhoI8wFwgCfadJlSGyDOj4rWg+P/b+klxoA
S5YAoKjh7PPFs1fh/uTueDGZU+Eb57Ir
=rbt5
-----END PGP SIGNATURE-----

--Signature=_Mon__22_Jun_2009_18_34_15_+1000_ppHojJRl/ruUqHwd--
