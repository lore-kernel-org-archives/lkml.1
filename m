Return-Path: <linux-kernel-owner+w=401wt.eu-S1752727AbYKLGib@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbYKLGib (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 01:38:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751367AbYKLGiV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 01:38:21 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49754 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbYKLGiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 01:38:21 -0500
Date: Wed, 12 Nov 2008 17:38:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: linux-next@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus <torvalds@linux-foundation.org>
Subject: linux-next: procedures
Message-Id: <20081112173807.05cfadf0.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__12_Nov_2008_17_38_07_+1100_0mi=/BrXhq1vYw8k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Nov_2008_17_38_07_+1100_0mi=/BrXhq1vYw8k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

I just though I would send out a reminder and clarification of the
procedures around the linux-next tree.

Prerequisites for inclusion of a tree (a branch of a git tree or a quilt
series) in linux-next:

	- all its commits/patches have been posted to appropriate mailing
lists
	- they have all been reviewed
	- the tree has been "unit tested"
	- the tree is destined for the next merge window (except during a
merge window when only changes destined for the current merge window
should be there).

So, to be clear, the posting, reviewing and testing should be done
*before* commits/patches are added to linux-next.  linux-next is meant to
be for integration testing only i.e. the trees should be as close to what
will be sent to Linus as possible (but may need changes to cope with
changes in other subsystems/architectures).

These trees should be usually based on Linus' tree.  In some cases there
will be dependencies and we will deal with these on a case by case basis
(there have not been many so far).

The following will cause a tree to be temporarily dropped from linux-next:
	- non-trivial conflicts with Linus' tree
	- build failures
	- non-obvious conflicts with other trees (this will require
us to come up with some way forward for the trees involved)
	- the contact for the tree being unresponsive

Most conflicts will be notified to the contacts for the trees involved
(some really trivial ones will not).  Simple conflicts between trees I
will try to fix up (if possible) and carry such resolutions as necessary.

I will not, any more, carry fix up patches to make linux-next build or
boot.  If a tree is identified as causing such a problem, it will be
dropped until the problem is fixed.

This is all open to discussion ...

The result I am aiming for is that during a merge window, the trees in
linux-next are sent to Linus verbatim (or with minor conflict fixups) by
their owners and the linux-next ends up basically empty (wrt Linus' tree)
when -rc1 is released (except for a few trees that need to be merged
late).  At other times linux-next should be in a state that Andrew can
use it as the basis for an -mm release without to much pain.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__12_Nov_2008_17_38_07_+1100_0mi=/BrXhq1vYw8k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkkaec8ACgkQjjKRsyhoI8xgjQCgj/8H0U3/smtVyPvzLzSUZoWP
zWUAoKCis9tI/P9gCBUSYkDVSaGTHYta
=4/Sa
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Nov_2008_17_38_07_+1100_0mi=/BrXhq1vYw8k--
