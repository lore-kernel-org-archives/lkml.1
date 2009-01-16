Return-Path: <linux-kernel-owner+w=401wt.eu-S933148AbZAPBw1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933148AbZAPBw1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jan 2009 20:52:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754910AbZAPBwP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Jan 2009 20:52:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:51493 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbZAPBwO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jan 2009 20:52:14 -0500
Date: Fri, 16 Jan 2009 12:52:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       David Howells <dhowells@redhat.com>
Subject: Re: linux-next: Tree for January 15  (afs/fscache)
Message-Id: <20090116125207.e1e79798.sfr@canb.auug.org.au>
In-Reply-To: <496F7DE4.7020600@oracle.com>
References: <20090115170415.3edc1df6.sfr@canb.auug.org.au>
	<496F7DE4.7020600@oracle.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jan_2009_12_52_07_+1100_hh7awvt0tBkzsyU+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jan_2009_12_52_07_+1100_hh7awvt0tBkzsyU+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

On Thu, 15 Jan 2009 10:18:12 -0800 Randy Dunlap <randy.dunlap@oracle.com> w=
rote:
>
> (still)
>=20
> when CONFIG_AFS=3Dy and CONFIG_FSCACHE=3Dm:
> (CONFIG_AFS_FSCACHE=3Dn)
>=20
>=20
> fs/built-in.o: In function `afs_cell_purge':
> (.text+0x6b13e): undefined reference to `__fscache_relinquish_cookie'
> fs/built-in.o: In function `afs_releasepage':
> file.c:(.text+0x6fd4d): undefined reference to `__fscache_uncache_page'
> fs/built-in.o: In function `afs_readpages':
> file.c:(.text+0x7022b): undefined reference to `__fscache_read_or_alloc_p=
ages'
> fs/built-in.o: In function `afs_readpage':
> file.c:(.text+0x7063b): undefined reference to `__fscache_read_or_alloc_p=
age'
> file.c:(.text+0x707c0): undefined reference to `__fscache_uncache_page'
> file.c:(.text+0x7083a): undefined reference to `__fscache_write_page'
> file.c:(.text+0x7086d): undefined reference to `__fscache_uncache_page'
> fs/built-in.o: In function `afs_invalidatepage':
> file.c:(.text+0x70ab3): undefined reference to `__fscache_uncache_page'
> fs/built-in.o: In function `afs_clear_inode':
> (.text+0x778be): undefined reference to `__fscache_relinquish_cookie'
> fs/built-in.o: In function `afs_iget':
> (.text+0x77cad): undefined reference to `__fscache_acquire_cookie'
> fs/built-in.o: In function `afs_iget':
> (.text+0x77e25): undefined reference to `__fscache_attr_changed'
> fs/built-in.o: In function `afs_iget':
> (.text+0x77ff6): undefined reference to `__fscache_relinquish_cookie'
> fs/built-in.o: In function `afs_vlocation_apply_update':
> vlocation.c:(.text+0x81989): undefined reference to `__fscache_update_coo=
kie'
> fs/built-in.o: In function `afs_vlocation_lookup':
> (.text+0x822f0): undefined reference to `__fscache_acquire_cookie'
> fs/built-in.o: In function `afs_vlocation_lookup':
> (.text+0x8269c): undefined reference to `__fscache_update_cookie'
> fs/built-in.o: In function `afs_vlocation_reaper':
> vlocation.c:(.text+0x82f01): undefined reference to `__fscache_relinquish=
_cookie'
> fs/built-in.o: In function `afs_put_volume':
> (.text+0x86b95): undefined reference to `__fscache_relinquish_cookie'
> fs/built-in.o: In function `afs_volume_lookup':
> (.text+0x8784e): undefined reference to `__fscache_acquire_cookie'

I have dropped the nfs tree form linux-next for today (there was an ia64
build problem as well).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Jan_2009_12_52_07_+1100_hh7awvt0tBkzsyU+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklv6EcACgkQjjKRsyhoI8ynfQCeNmXZCr6qtxBDUUAl4JuhM0Tj
RgoAn0Bt45pqFMEimz/MD5UKN6H95sLU
=GDeT
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jan_2009_12_52_07_+1100_hh7awvt0tBkzsyU+--
