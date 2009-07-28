Return-Path: <linux-kernel-owner+w=401wt.eu-S1751181AbZG1EUI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751181AbZG1EUI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jul 2009 00:20:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750835AbZG1EUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Jul 2009 00:20:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52545 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774AbZG1EUG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jul 2009 00:20:06 -0400
Date: Tue, 28 Jul 2009 14:20:01 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Philipp Reisner <philipp.reisner@linbit.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090728142001.e346afec.sfr@canb.auug.org.au>
In-Reply-To: <200907271109.33271.philipp.reisner@linbit.com>
References: <20090727173754.6a04e781.sfr@canb.auug.org.au>
	<200907271109.33271.philipp.reisner@linbit.com>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__28_Jul_2009_14_20_01_+1000_5cMw7NspeJtgsUEV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Jul_2009_14_20_01_+1000_5cMw7NspeJtgsUEV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Philipp,

On Mon, 27 Jul 2009 11:09:32 +0200 Philipp Reisner <philipp.reisner@linbit.=
com> wrote:
>
> On Monday 27 July 2009 09:37:54 Stephen Rothwell wrote:
> >
> > Today's linux-next build (powerpc allyesconfig) failed like this:
> >
> > drivers/block/drbd/drbd_trace.o: In function `.roles_to_name':
> > (.text+0x64): multiple definition of `.roles_to_name'
> > drivers/block/drbd/drbd.o:(.text+0x28eb8): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `disks_to_name':
> > (.opd+0x30): multiple definition of `disks_to_name'
> > drivers/block/drbd/drbd.o:(.opd+0x1b78): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `roles_to_name':
> > (.opd+0x18): multiple definition of `roles_to_name'
> > drivers/block/drbd/drbd.o:(.opd+0x1b60): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `.conns_to_name':
> > (.text+0x0): multiple definition of `.conns_to_name'
> > drivers/block/drbd/drbd.o:(.text+0x28e54): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `set_st_err_name':
> > (.opd+0x48): multiple definition of `set_st_err_name'
> > drivers/block/drbd/drbd.o:(.opd+0x1b90): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `.disks_to_name':
> > (.text+0xcc): multiple definition of `.disks_to_name'
> > drivers/block/drbd/drbd.o:(.text+0x28f20): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `conns_to_name':
> > (.opd+0x0): multiple definition of `conns_to_name'
> > drivers/block/drbd/drbd.o:(.opd+0x1b48): first defined here
> > drivers/block/drbd/drbd_trace.o: In function `.set_st_err_name':
> > (.text+0x134): multiple definition of `.set_st_err_name'
> > drivers/block/drbd/drbd.o:(.text+0x28f88): first defined here
> >
> > I applied the following patch to mark DRBD_TRACE broken for now.
>=20
> I have fixed that issue. With the next pull, drbd_tracing should
> compile on PPC.=20

Thanks.

> BTW, we are working on making our stuff compatible with Rusty's
> cpu set changes. I expect that this will be finished soon...

Excellent.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__28_Jul_2009_14_20_01_+1000_5cMw7NspeJtgsUEV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpufHEACgkQjjKRsyhoI8xU3ACcDI9KpYScxbZsqUbsLXLkD9Ks
0ywAn0p/tBrMdLeltjcjGqtxg4pWr3/F
=/BW2
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Jul_2009_14_20_01_+1000_5cMw7NspeJtgsUEV--
