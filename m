Return-Path: <linux-kernel-owner+w=401wt.eu-S1767101AbXDTNab@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767101AbXDTNab (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:30:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767100AbXDTNab
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:30:31 -0400
Received: from iucha.net ([209.98.146.184]:35972 "EHLO mail.iucha.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767101AbXDTNaa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:30:30 -0400
Date: Fri, 20 Apr 2007 08:30:28 -0500
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: chuck.lever@oracle.com, Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Adrian Bunk <bunk@stusta.de>,
       OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
       linux-kernel@vger.kernel.org
Subject: Success! Was: [PATCH 0/4] 2.6.21-rc7 NFS writes: fix a series of issues
Message-ID: <20070420133028.GA24044@iucha.net>
References: <1176905506.6796.84.camel@heimdal.trondhjem.org> <20070419015232.GO24044@iucha.net> <1176950713.6422.95.camel@heimdal.trondhjem.org> <462786C9.7090405@oracle.com> <1176995848.6663.1.camel@heimdal.trondhjem.org> <20070419155046.GR24044@iucha.net> <1176998982.6663.10.camel@heimdal.trondhjem.org> <20070419195844.GT24044@iucha.net> <1177018242.6628.10.camel@heimdal.trondhjem.org> <20070419214931.GX24044@iucha.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+9kyDs7IugQ0lHaC"
Content-Disposition: inline
In-Reply-To: <20070419214931.GX24044@iucha.net>
X-GPG-Key: http://iucha.net/florin_iucha.gpg
X-GPG-Fingerprint: 5E59 C2E7 941E B592 3BA4  7DCF 343D 2B14 2376 6F5B
User-Agent: Mutt/1.5.13 (2006-08-11)
From: florin@iucha.net (Florin Iucha)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--+9kyDs7IugQ0lHaC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 19, 2007 at 04:49:31PM -0500, Florin Iucha wrote:
> On Thu, Apr 19, 2007 at 05:30:42PM -0400, Trond Myklebust wrote:
> > > I'm far from the machine right now, so I will do some more tests
> > > tonight, but right now, the new patchset is not good.  What is the
> > > difference between reverting the patch you sent yesterday and your
> > > current fifth patch?  I assume the other four are identical, right?
> >=20
> > The only difference is the way in which we handle retries of an NFSv4
> > request: the new patch disconnects if and only if a timeout has
> > occurred, or the server sends us garbage.
>=20
> I have to mention that I rebased to the head of the tree
> (895e1fc7226e6732bc77138955b6c7dfa279f57a) before applying your
> patches, in order to test what I expect the official tree to be.
>=20
> Tonight I'll test this kernel once more, then go back to 21-rc7 and
> apply your 5 patches and re-test.

It passed big-copy, and the copy run from the gnome-session while I
did my morning light browsing, email reading, etc.

kernel:
   895e1fc7226e6732bc77138955b6c7dfa279f57a

patches:
   linux-2.6.21-001-cleanup_unstable_write.dif
   linux-2.6.21-002-defer_clearing_pg_writeback.dif
   linux-2.6.21-003-fix_desynchronised_ncommit.dif
   linux-2.6.21-004-fix_nfs_set_page_dirty.dif
   linux-2.6.21-005-fix_nfsv4_resend.dif

Regards,
florin

--=20
Bruce Schneier expects the Spanish Inquisition.
      http://geekz.co.uk/schneierfacts/fact/163

--+9kyDs7IugQ0lHaC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGKMB0ND0rFCN2b1sRAiQlAJ4pxXeoyifGTTK+tDV7bM+q7N05zwCgjuL9
Zt/OrpAfXFoKpnjfRAC+cvo=
=G/iu
-----END PGP SIGNATURE-----

--+9kyDs7IugQ0lHaC--
