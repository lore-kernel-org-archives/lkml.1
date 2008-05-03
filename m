Return-Path: <linux-kernel-owner+w=401wt.eu-S1760194AbYECGHm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760194AbYECGHm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 02:07:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753414AbYECGHd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 02:07:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:32936 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753011AbYECGHc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 02:07:32 -0400
Date: Sat, 3 May 2008 16:07:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: Requirements and process
Message-Id: <20080503160724.6c3e0392.sfr@canb.auug.org.au>
In-Reply-To: <20080503154542.18807e59.sfr@canb.auug.org.au>
References: <20080503154542.18807e59.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__3_May_2008_16_07_24_+1000_F5R8plUrJzn9MMQA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__3_May_2008_16_07_24_+1000_F5R8plUrJzn9MMQA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 3 May 2008 15:45:42 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> The following architectures are not in linux-next (and should be):
>=20
> alpha		cris		frv
> h8300		m32r		m68knommu
> mips		mn10300		parisc
> um		v850		xtensa
>=20
> See Andrew's mail for a list of other subsystems.

In case it isn't clear, I need to be told where I can get a particular
tree from and who should be contacted in case of problems (I do not troll
through the MAINTAINERS file).  I can currently handle git trees and
quilt series.  I am willing to consider other formats/scms.  I also do
not mind having multiple trees (or branches or series files) for a single
subsystem/maintainer.

Series files must be annotated with an indication of the place in Linus'
tree that they are based on using the following format:

# BASE <some identification of a place in Linus' tree>

This base can be a SHA1 or a release tag or one of the ...-git<n> or the
output from "git describe".  Alternatively, you can be based on another
tree in linux-next by using:

# NEXT_BASE <name of a tree in linux-next>

The names are in the Next/Trees file in each release and normally do not
change.

Also you may (if you like) delimit the parts of the series you want in
linux-next by using:

# NEXT_PATCHES_START
.
.
# NEXT_PATCHES_END

There can be multiple such sections.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__3_May_2008_16_07_24_+1000_F5R8plUrJzn9MMQA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIHAEiTgG2atn1QN8RAiFqAJ4kHu19HFoe+2P4BRkVH3YmksyCMgCfZf2H
O/m258Vnrhb5moeibmadu3c=
=jini
-----END PGP SIGNATURE-----

--Signature=_Sat__3_May_2008_16_07_24_+1000_F5R8plUrJzn9MMQA--
