Return-Path: <linux-kernel-owner+w=401wt.eu-S1755052AbZETJ5E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052AbZETJ5E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 05:57:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754070AbZETJ4y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 05:56:54 -0400
Received: from mail5.tpgi.com.au ([203.12.160.101]:53512 "EHLO
	mail5.tpgi.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058AbZETJ4y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 05:56:54 -0400
X-TPG-Junk-Status: Message not scanned
X-TPG-Antivirus: Passed
X-TPG-Abuse: host=adsl.samad.com.au; ip=60.241.248.86; date=Wed, 20 May 2009 19:56:44 +1000
Date: Wed, 20 May 2009 19:56:39 +1000
From: Alex Samad <alex@samad.com.au>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: Kernel crash with 2.6.29 + nfs + xfs (radix-tree)
Message-ID: <20090520095639.GA27496@samad.com.au>
References: <20090520003745.GA27491@samad.com.au> <20090520090558.GQ16929@discord.disaster>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DocE+STaALJfprDB"
Content-Disposition: inline
In-Reply-To: <20090520090558.GQ16929@discord.disaster>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 20, 2009 at 07:05:58PM +1000, Dave Chinner wrote:
> On Wed, May 20, 2009 at 10:37:45AM +1000, Alex Samad wrote:
> > Hi
> >=20
> > I have been quit a lot of crashes on my debian amd64 box in the 2.6.29
> > series of kernel. Seems for me to be when the system is under load and
> > there is network action -> nfsd -> xfs.
>=20
> Perhaps a use after free or a reference counting problem. Thanks for
> reporting it.
>=20
> > May  5 19:45:38 x kernel: ------------[ cut here ]------------

[snip]

> > I have logged a bug with debian
> > ( more info http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D526406),
> > there has been one other to report this problem.
> >=20
> > we believe somebody has already reported a similar problem here
> > http://groups.google.com/group/linux.kernel/browse_thread/thread/dd00f5=
2e93397c9e/6b6814dab9b41a05?pli=3D1
>=20
> Which no-one noticed was related to XFS (not in the subject line)
> and so most people (like me) would have simply deleted it without
> reading it....
>=20
> > has any one else seen this problem, who do I need to raise this too ?
>=20

thanks

> I've cc'd the XFS list.
>=20
> > I am able to reproduce this problem on my machine (amd64 phenomem II 8G
> > ram), running virtualbox, I have a vm access the local filesystem via
> > nfs (udp) and when I do a rm -fr <some directory ~200M> I see the bug
>=20
> I run debian, XFS and 2.6.29 on all my machines but I haven't
> tripped over the problem - it all appears to be related to calling
> dispose_list() during/just after removing a lot of files. If you
> have a simple method of reproducing the problem (e.g. a simple shell
> script) it would help track down the problem much faster....

my source directory was an openwrt trunk (svn co
svn://svn.openwrt.org/openwrt/trunk/) which I had done a compile on, I
went to delete it (just about every time it would cause this problem.

on the original data set (I was in the process of moving from one
location to another so I still have the original data)

du -s --si=20
5.2G

find | wc -l
313320

if you have a look at the debian bug, another person (mike) has
experienced this on a machine that is basically a backup server so
heavily stressed out - using xfs partitions - he found going back to
2.6.28-7 seems to be stable.



>=20
> Cheers,
>=20
> Dave.


--DocE+STaALJfprDB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkoT09QACgkQkZz88chpJ2P+DwCeKmpLZGr3qPzsnpa1Lp3Pur/0
QNMAoNSQLT3yKRVDZ8bGScMnyjO+9ux9
=NCm2
-----END PGP SIGNATURE-----

--DocE+STaALJfprDB--
