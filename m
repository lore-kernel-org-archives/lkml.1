Return-Path: <linux-kernel-owner+w=401wt.eu-S1751491AbZGTFaC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751491AbZGTFaC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jul 2009 01:30:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751053AbZGTFaB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Jul 2009 01:30:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43960 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750770AbZGTFaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jul 2009 01:30:00 -0400
Date: Mon, 20 Jul 2009 15:29:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@elte.hu>, rgetz@blackfin.uclinux.org,
       linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: [PATCH] kernel.printk.c - ensure that "console enabled"
 messages are printed on the console
Message-Id: <20090720152954.b8f82609.sfr@canb.auug.org.au>
In-Reply-To: <20090717174852.c00aa374.akpm@linux-foundation.org>
References: <200907040017.26921.rgetz@blackfin.uclinux.org>
	<200907091308.37370.rgetz@blackfin.uclinux.org>
	<20090710102547.GD5499@elte.hu>
	<20090717174852.c00aa374.akpm@linux-foundation.org>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Jul_2009_15_29_54_+1000_tmVvMwHdcBR5kx6N"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Jul_2009_15_29_54_+1000_tmVvMwHdcBR5kx6N
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 17 Jul 2009 17:48:52 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Fri, 10 Jul 2009 12:25:47 +0200
> Ingo Molnar <mingo@elte.hu> wrote:
>=20
> >=20
> > * Robin Getz <rgetz@blackfin.uclinux.org> wrote:
> >=20
> > > From: Robin Getz <rgetz@blackfin.uclinux.org>
> > >=20
> > > Today, when a console is registered without CON_PRINTBUFFER, end=20
> >=20
> > Looks good, applied it to tip:core/printk for v2.6.32, thanks Robin.=20
>=20
> Seven days later, this isn't in linux-next.  Did it get lost?

It went into tip:core/printk on July 10.  It has not propagated to
tip:auto-latest (which is what is merged int linux-next) yet.  The last
update of auto-latest was about July 6.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Jul_2009_15_29_54_+1000_tmVvMwHdcBR5kx6N
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpkANIACgkQjjKRsyhoI8x5UQCgv/8Ff/4J1ffXUrh+lu2MGIDX
tCIAoK4txdlHoOR/pX9FuiArV7JHThej
=8lod
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Jul_2009_15_29_54_+1000_tmVvMwHdcBR5kx6N--
