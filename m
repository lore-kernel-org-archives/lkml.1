Return-Path: <linux-kernel-owner+w=401wt.eu-S1760032AbXGEQkX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760032AbXGEQkX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2007 12:40:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758387AbXGEQkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Jul 2007 12:40:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42822 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758253AbXGEQkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2007 12:40:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] util-linux-ng 2.13-rc1
Date: Thu, 5 Jul 2007 12:41:59 -0400
User-Agent: KMail/1.9.7
Cc: Karel Zak <kzak@redhat.com>,
       List util-linux-ng <util-linux-ng@vger.kernel.org>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20070703221156.GY14825@petra.dvoda.cz> <20070704084211.GA19128@infradead.org>
In-Reply-To: <20070704084211.GA19128@infradead.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4058283.TlGlUmDnHe";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200707051242.00625.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4058283.TlGlUmDnHe
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Wednesday 04 July 2007, Christoph Hellwig wrote:
> On Wed, Jul 04, 2007 at 12:11:56AM +0200, Karel Zak wrote:
> >  mount(8) doesn't include filesystem detection code anymore. You
> >  have to compile --with-fsprobe=3D{blkid,volume_id}, and libblkid
> >  (e2fsprogs) or libvolume_id (udev >=3D v110) is required.
>
> Sorry, but it's really annoying to pull in a filesystem-specific devel
> package for that.  Having a library is fine, but please move the library
> into util-linux so it's always available without another dependency.

ugh, moving libraries which are already actively maintained by other core=20
projects into util-linux is so not a good idea (ignoring the fact that it'd=
=20
easily be a pita/waste for distro maintainers)

> That=20
> way xfsprogs could for example drop it's own detection library aswell.

i dont really think this is dependent on util-linux at all.  nothing is=20
stopping xfsprogs from depending on udev or e2fsprogs now.

> >  The package build system is now based on autotools. The build system
> >  supports  separate CFLAGS and LDFLAGS for suid programs (SUID_CFLAGS,
> >  SUID_LDFLAGS). For more details see the README file
>
> And this is really dumb.  autotools is a completely pain in the ass and

not really at all.  hand written build systems are a constant source of pai=
n=20
for distribution maintainers and people trying to cross-compile (and the on=
e=20
that was in util-linux had many problems in both these areas).

> not useful at all for linux-only tools.

incorrect.  linux changes over time as does the kernel/libc/architecture=20
api's.  look at the old util-linux build system -- it had a crappy hand=20
written configure script to try and detect all these different issues.
=2Dmike

--nextPart4058283.TlGlUmDnHe
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARo0fWEFjO5/oN/WBAQLxjRAAyvQHL/6V0yFayUp6tMZa6OpAXfiqQNwF
9NIQtfKxZlYf9NgVj1vzpam9nvtThm1GMXqHXIEBSzn0nrfGgN1H+k7Tq1qIotUC
0jt6MPADP5zolLhZRJBeQ67/QCBN6ajetTDtiVLJDGMoQQ7axMhxN8PdFYPN0Zpa
sCdsdqczLEJPofZ6pvtud86q+NmQVb6juzHHBmYC8+5/FMuIpxCuHS9B18Y2oQss
8uJ3Ff3jMpiM84nNrq9Pbg8zONCtHWcc2NlkwXwV/dzxgOFdxh6r8IH3X4DbUPk3
tRkCTlsfzpgPFqtQQu4sRlj0Cu8Oq+ySiYTVUxh47Qz/JRKLVKtKB/YWjt/7yjM5
wPk9vycj131jUzL8ZSQAwRx+R1ebp/VtJ/vpVPS/o4lA2dfEss8SUsHFDLxQTTsB
/D/X0b0X0tk+HIw6BXtz4qrSHyQHFnD8RiWgxQ4aECQLUV80cCY+8mXYYbOMzETV
lS/ySv5fJANYUB7YF4zNAA0sN7hp+Vlw2vEw/hQXzWulRvqyk1vGhe0eGN+sAWvu
T45NOmu9G+lRz2TrFXP0UaRl1Cp3QLiHCyee7zgw5+iqC6gu2Z+db7VNXvImQA+C
J/vdqrqzzNPur5DyZah40UmnAex3I1o482ECJ94LObP6riJF9rQuw0dz88i4uECS
DelkgfEOJqg=
=JpdJ
-----END PGP SIGNATURE-----

--nextPart4058283.TlGlUmDnHe--
