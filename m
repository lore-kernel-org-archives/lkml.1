Return-Path: <linux-kernel-owner+w=401wt.eu-S1758611AbXF3N5v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611AbXF3N5v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2007 09:57:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757457AbXF3N5n
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Jun 2007 09:57:43 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49037 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757301AbXF3N5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2007 09:57:42 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: sh section mismatches [was Re: 2.6.22-rc6 on Dreamcast (SH4)]
Date: Sat, 30 Jun 2007 09:58:39 -0400
User-Agent: KMail/1.9.7
Cc: Satyam Sharma <satyam.sharma@gmail.com>, linuxsh-dev@lists.sourceforge.net,
       LKML <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>
References: <a781481a0706280457r4abb5046wc82cff9d49b7975e@mail.gmail.com> <1183210853.6016.2.camel@localhost.localdomain>
In-Reply-To: <1183210853.6016.2.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4336801.ObFUexhyWM";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200706300958.40315.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4336801.ObFUexhyWM
Content-Type: text/plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Saturday 30 June 2007, Adrian McMenamin wrote:
> On Thu, 2007-06-28 at 17:27 +0530, Satyam Sharma wrote:
> > Hi,
> >
> > > On Monday 25 June 2007, Adrian McMenamin wrote:
> > > > Still getting this:
> > > >
> > > >  MODPOST vmlinux
> > > > WARNING: arch/sh/boards/dreamcast/built-in.o(.data+0x0): Section
> > > > mismatch: reference to .init.text: (between 'mv_dreamcast' and
> > > > 'systemasic_int')
> >
> > I had sent a patch for this earlier ... Adrian, did you try (build + bo=
ot
> > + testrun) with it? Does this one go away (and system executes fine)?
> >
> > [ http://lkml.org/lkml/diff/2007/6/23/116/1 ]
> >
> > [ This has to do with __init functions calling __initmv functions in a
> > zillion files in arch/sh/boards/.../setup.c which is problematic when
> > __initmv is not __init itself (!SH_GENERIC && !SH_UNKNOWN) ]
> >
> > > > WARNING: drivers/built-in.o(.text+0x168e0): Section mismatch:
> > > > reference to .init.data: (between 'pvr2fb_check_var' and
> > > > 'pvr2fb_interrupt') WARNING: drivers/built-in.o(.text+0x1701c):
> > > > Section mismatch: reference to .init.data: (between
> > > > 'pvr2fb_pci_probe' and 'read_mem')
> > > > WARNING: drivers/built-in.o(.text+0x17024): Section mismatch:
> > > > reference to .init.text: (between 'pvr2fb_pci_probe' and 'read_mem')
> > > > WARNING: drivers/built-in.o(.data+0x738): Section mismatch: referen=
ce
> > > > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> > > > WARNING: drivers/built-in.o(.data+0x750): Section mismatch: referen=
ce
> > > > to .init.text: (between 'board_list' and 'pvr2fb_pci_driver')
> >
> > drivers/video/pvr2fb.c is a mess with __init, __initdata, __devinit and
> > __devinitdata (__exit and __devexit variants for good measure) all being
> > used and referencing each other freely ... I have no idea what function
> > should actually be what. Sam normally knows about such things,
> > adding him to Cc: list.
>
> Finally got around to applying this patch, but it doesn't fix the
> problem...

sure it did ... his patch was to address just the stuff in arch/sh/, not th=
e=20
pvr video driver, and your output shows that it is working
=2Dmike

--nextPart4336801.ObFUexhyWM
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4 (GNU/Linux)

iQIVAwUARoZhkEFjO5/oN/WBAQIGDQ/+PpHED7z6IQ0hYIU65ewTU0Tcm/NdxsUI
/azK3ZbltSwFr16sXbkz1Jzt3iyj9WNav+cz9mcSe/oWfNbi9ykY6elnuRdQSUiF
P908TOvCCImCgfhsRkaXQyVUpYtCQt6xobDa4Q4qQfBCc9Dka5jkA5hBS4UCcwwt
y7SEN5tk1ESkWLRiDfgoT3ZgkD34esQpzARDM1fNFMxvmYfwFS5Uk5iU1UUnqIj1
LKVFErhkbAMADk6N98g+5J+XhPmjUPfki35oOsavn68dcMwVzU8rQ2nzefUcedjO
ELVBUKDnuVWwzTvB5RWDiRmVntrFiGZA+6az8x/DaBvHi5hl1bkBlCzrWlig4JcA
us9dhXD8QZGD+VB6khGu3q/srpIzuNkp9YaguP7uXpRHCJH4KV5B89UGFRKmWP08
L8MFC4ZjYEMH4oWHC2stYGr/O6Dn00xuhb7WxfTZfOJQPLXZmIF1jJ+6cgUMV1P3
QH+Ecje0jD7avzYnDpMJXn0D6rMLdDVEihI4yiQcA3jAdKAWOX2B6diWiwNup6zF
JWbbYC9H6vTNUfTiK6e2oL1w2msh+5c2pWWFgmJ3CSTqCp+2baZJXHxzIACgJX9U
GOJXYqZLSqcnILMbu3D5fi5km0JlOOh0N0lpCOA4jBxfnvX17i9qCV0p+8Fu6bvI
vcAjTIDCdig=
=N64v
-----END PGP SIGNATURE-----

--nextPart4336801.ObFUexhyWM--
