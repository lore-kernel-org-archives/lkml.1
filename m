Return-Path: <linux-kernel-owner+w=401wt.eu-S1763925AbYEFOr3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763925AbYEFOr3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2008 10:47:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762062AbYEFOrS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 May 2008 10:47:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58743 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761938AbYEFOrQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2008 10:47:16 -0400
Date: Wed, 7 May 2008 00:47:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: John Williams <john.williams@petalogix.com>
Cc: monstr@seznam.cz, linux-kernel@vger.kernel.org, arnd@arndb.de,
       linux-arch@vger.kernel.org, stephen.neuendorffer@xilinx.com,
       John.Linn@xilinx.com, matthew@wil.cx, will.newton@gmail.com,
       drepper@redhat.com, microblaze-uclinux@itee.uq.edu.au,
       grant.likely@secretlab.ca, Michal Simek <monstr@monstr.eu>
Subject: Re: [PATCH 45/56] microblaze_v2: headers simple files - empty or
 redirect to asm-generic
Message-Id: <20080507004702.d516a727.sfr@canb.auug.org.au>
In-Reply-To: <1209954849.5798.80.camel@localhost>
References: <1209901305-6404-1-git-send-email-monstr@seznam.cz>
	<96f2004535c34a0c762bf2012c299cbf9f89ab32.1209897266.git.monstr@monstr.eu>
	<92cd3a27b393bb394d48902594152351a92c59bb.1209897266.git.monstr@monstr.eu>
	<4e20213f5f296268a24955df8c951f7fba279816.1209897266.git.monstr@monstr.eu>
	<49eccf3408b90a5ebb42635493bbeef3b584acb9.1209897266.git.monstr@monstr.eu>
	<d1e4a572d2add458e1dc7c4f5a3039ae4faa2c04.1209897266.git.monstr@monstr.eu>
	<27d6acda14c492aae35d8bb1343a122624560418.1209897266.git.monstr@monstr.eu>
	<64e6fc7378cd5c714fcceef7d4965c1fb3d1b288.1209897266.git.monstr@monstr.eu>
	<9cc0d54a98f25748dc3f16fc3250524d7cd00877.1209897266.git.monstr@monstr.eu>
	<5d240127ee05c28d5156bfbf305329f9540f6c14.1209897267.git.monstr@monstr.eu>
	<59b5238f7a259dcac4c9ca6513756a188625462e.1209897267.git.monstr@monstr.eu>
	<8e1d421649250f7a3f638cd552bc46e5f5845890.1209897267.git.monstr@monstr.eu>
	<1209954849.5798.80.camel@localhost>
X-Mailer: Sylpheed 2.5.0beta3 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__7_May_2008_00_47_02_+1000_W3MIZLRLt5k93m4r"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__7_May_2008_00_47_02_+1000_W3MIZLRLt5k93m4r
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 05 May 2008 12:34:09 +1000 John Williams <john.williams@petalogix.c=
om> wrote:
>
>=20
> >  include/asm-microblaze/auxvec.h            |   14 ++++++++++++++
> >  include/asm-microblaze/cputime.h           |   16 ++++++++++++++++
> >  include/asm-microblaze/div64.h             |   16 ++++++++++++++++
> >  include/asm-microblaze/emergency-restart.h |   16 ++++++++++++++++
> >  include/asm-microblaze/errno.h             |   16 ++++++++++++++++
> >  include/asm-microblaze/futex.h             |   16 ++++++++++++++++
> >  include/asm-microblaze/kdebug.h            |   19 +++++++++++++++++++
> >  include/asm-microblaze/local.h             |   16 ++++++++++++++++
> >  include/asm-microblaze/mutex.h             |   16 ++++++++++++++++
> >  include/asm-microblaze/namei.h             |   24 ++++++++++++++++++++=
++++
> >  include/asm-microblaze/percpu.h            |   16 ++++++++++++++++
> >  include/asm-microblaze/resource.h          |   16 ++++++++++++++++
> >  include/asm-microblaze/user.h              |   18 ++++++++++++++++++
>=20
> These are all just includes of asm-generic/* (hooray!).

Absolutely, but is it really necessary to have 14-16 lines of comment
(including a copyright notice) for a file whose single real line is just
to include another file?  i.e. reduce all these to 1 line files.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__7_May_2008_00_47_02_+1000_W3MIZLRLt5k93m4r
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFIIG9sTgG2atn1QN8RAvaoAJ9rgHnCrY64JwOVw+xNVnq6FwHqogCfc7R/
8R0oqWux3hVI/nx0/hWpXjM=
=CXr7
-----END PGP SIGNATURE-----

--Signature=_Wed__7_May_2008_00_47_02_+1000_W3MIZLRLt5k93m4r--
