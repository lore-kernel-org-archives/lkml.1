Return-Path: <linux-kernel-owner+w=401wt.eu-S1755953AbYCaLln@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953AbYCaLln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 07:41:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753124AbYCaLlf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 07:41:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44533 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbYCaLle (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 07:41:34 -0400
Date: Mon, 31 Mar 2008 22:41:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Andy Whitcroft <apw@shadowen.org>,
       Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       Lonnie Iverson <ldiverson@novell.com>
Subject: Re: [BUILD_FAILURE] linux-next: Tree for March 31 build fails on
 fs/novfs sys_flistxattr()
Message-Id: <20080331224125.cc030176.sfr@canb.auug.org.au>
In-Reply-To: <47F0C8B6.7020808@linux.vnet.ibm.com>
References: <20080331181118.7964d4a9.sfr@canb.auug.org.au>
	<47F0C8B6.7020808@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0beta1 (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__31_Mar_2008_22_41_25_+1100_v0a0k1HnzWDFLvP4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__31_Mar_2008_22_41_25_+1100_v0a0k1HnzWDFLvP4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2008 16:49:18 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> Hi Stephen,
>=20
> The next-20080331 allyesconfig, build fails on x86_64 machine
>=20
> fs/novfs/built-in.o: In function `sys_flistxattr':
> /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4658: multiple definition=
 of `sys_flistxattr'
> fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:457: first defined h=
ere
> ld: Warning: size of symbol `sys_flistxattr' changed from 112 in fs/xattr=
.o to 75 in fs/novfs/built-in.o
> fs/novfs/built-in.o: In function `sys_fsetxattr':
> /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4672: multiple definition=
 of `sys_fsetxattr'
> fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:295: first defined h=
ere
> ld: Warning: size of symbol `sys_fsetxattr' changed from 164 in fs/xattr.=
o to 97 in fs/novfs/built-in.o
> fs/novfs/built-in.o: In function `sys_fgetxattr':
> /root/kernels/linux-2.6.25-rc7/fs/novfs/inode.c:4645: multiple definition=
 of `sys_fgetxattr'
> fs/xattr.o:/root/kernels/linux-2.6.25-rc7/fs/xattr.c:384: first defined h=
ere
> ld: Warning: size of symbol `sys_fgetxattr' changed from 128 in fs/xattr.=
o to 91 in fs/novfs/built-in.o
> make[1]: *** [fs/built-in.o] Error 1
> make: *** [fs] Error 2

Yes, well this from fs/novfs/inode.c was asking for it really :-)

asmlinkage ssize_t sys_flistxattr(int fd, char __user * list, size_t size)
{
.
.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__31_Mar_2008_22_41_25_+1100_v0a0k1HnzWDFLvP4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFH8M3rTgG2atn1QN8RAuXoAJ4oe9DRU1/dG7hNQLKvE2INc41C3ACcDl/h
CCrG4lawcGHyfcH1au+EwSs=
=crGX
-----END PGP SIGNATURE-----

--Signature=_Mon__31_Mar_2008_22_41_25_+1100_v0a0k1HnzWDFLvP4--
