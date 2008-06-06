Return-Path: <linux-kernel-owner+w=401wt.eu-S1764325AbYFFHdx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764325AbYFFHdx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 03:33:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755880AbYFFHdo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 03:33:44 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43120 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286AbYFFHdn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 03:33:43 -0400
Date: Fri, 6 Jun 2008 17:33:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 5
Message-Id: <20080606173319.66cc9924.sfr@canb.auug.org.au>
In-Reply-To: <20080606071707.GB9708@elte.hu>
References: <20080605175217.cee497f3.sfr@canb.auug.org.au>
	<20080605195604.41623687.akpm@linux-foundation.org>
	<20080606071707.GB9708@elte.hu>
X-Mailer: Sylpheed 2.5.0rc (GTK+ 2.12.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__6_Jun_2008_17_33_19_+1000_ScNrJEAh0+rMI9C1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jun_2008_17_33_19_+1000_ScNrJEAh0+rMI9C1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ingo,

On Fri, 6 Jun 2008 09:17:07 +0200 Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Morton <akpm@linux-foundation.org> wrote:
>=20
> > Instantly oopses on two x86_64 boxes with this config:
> > http://userweb.kernel.org/~akpm/config-akpm2.txt
> >=20
> > oops: http://userweb.kernel.org/~akpm/p6056454.jpg
> >
> > At a guess I'd say the sched_domains code is calling into slab before=20
> > slab is initalised.  Something like that.
>=20
> did SLUB change in linux-next? There no such problem in -tip.

$ git rev-list stable..next-20080605 -- mm/slub.c include/linux/slub_def.h
139e2551f25697a242de2b9c61d4514c2f762ca8
0bb08241ce68aaa70b7b804b4d6319d8bad3ae24

The first is the merge of the trivial tree and the second is in that tree
and only changes some comments in slub.c

$ git rev-list stable..next-20080605 -- mm/slab.c include/linux/slab*
(nothing)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__6_Jun_2008_17_33_19_+1000_ScNrJEAh0+rMI9C1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhI6D8ACgkQTgG2atn1QN8VLgCeLxyKvIw8NvMBZbPNL3f82uvM
UPkAnjRSY6M3DGNPq40qMi44hZXYmglf
=vV8g
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jun_2008_17_33_19_+1000_ScNrJEAh0+rMI9C1--
