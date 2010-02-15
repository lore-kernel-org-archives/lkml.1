Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756699Ab0BOXQh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 18:16:37 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:55951 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756462Ab0BOXQg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 18:16:36 -0500
Date: Tue, 16 Feb 2010 10:16:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Chinner <david@fromorbit.com>, xfs-masters@oss.sgi.com,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>
Subject: Rebase v. merge (Was: Re: linux-next: manual merge of the xfs tree
 with the vfs tree)
Message-Id: <20100216101626.0549dee8.sfr@canb.auug.org.au>
In-Reply-To: <20100215034417.GV30031@ZenIV.linux.org.uk>
References: <20100215122740.87c6cb5f.sfr@canb.auug.org.au>
	<20100215034417.GV30031@ZenIV.linux.org.uk>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Feb_2010_10_16_26_+1100_6.q.GiQAJr4Pm=CF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Feb_2010_10_16_26_+1100_6.q.GiQAJr4Pm=CF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Mon, 15 Feb 2010 03:44:17 +0000 Al Viro <viro@ZenIV.linux.org.uk> wrote:
>
> Actually, I'd cheerfully rebased that sucker (to e.g. write_inode2); it h=
as
> grown a trivial conflict with mainline after one of gfs2 merges and it's
> annoying to fix it up after each for-next rebase.
>=20
> So I'd rather put a rebased variant and switched the for-next to using th=
at,
> if people who'd pulled it already are OK with that.

Just out of interest, is there some reason you didn't just merge Linus'
tree (or the subset that caused the conflict) into the write-inode
branch.  That would have meant that you still had a nonrebasing branch
that others could use.  Now anyone who has merged your write_inode branch
needs to rebuild their trees using you new write-rebase2 branch or risk
causing conflicts in linux-next or Linus' tree when their tree's are
merged.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Feb_2010_10_16_26_+1100_6.q.GiQAJr4Pm=CF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt51coACgkQjjKRsyhoI8ybzwCfQdtiDw7y0O8V7Hp0WU2L+bi3
mokAoIiHmI7amzylt9C83mApv6Omgwrd
=qnRR
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Feb_2010_10_16_26_+1100_6.q.GiQAJr4Pm=CF--
