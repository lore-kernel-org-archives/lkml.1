Return-Path: <linux-kernel-owner+w=401wt.eu-S1751805AbZFAEme@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751805AbZFAEme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 00:42:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750920AbZFAEm0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 00:42:26 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50663 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785AbZFAEm0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 00:42:26 -0400
Date: Mon, 1 Jun 2009 14:42:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Neil Brown <neilb@suse.de>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, raz ben yehuda <raziebe@gmail.com>,
       "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: linux-next: md tree build failure
Message-Id: <20090601144218.26810ec8.sfr@canb.auug.org.au>
In-Reply-To: <20090525061552.GH11363@kernel.dk>
References: <20090525153346.758483fc.sfr@canb.auug.org.au>
	<20090525061552.GH11363@kernel.dk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Jun_2009_14_42_18_+1000_P=l2AjSGjUIoIYFf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Jun_2009_14_42_18_+1000_P=l2AjSGjUIoIYFf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 25 May 2009 08:15:52 +0200 Jens Axboe <jens.axboe@oracle.com> wrote:
>
> On Mon, May 25 2009, Stephen Rothwell wrote:
> >=20
> > Today's linux-next build (powerpc ppc64_defconfig) failed like this:
> >=20
> > drivers/md/raid0.c: In function 'create_strip_zones':
> > drivers/md/raid0.c:243: error: 'struct request_queue' has no member nam=
ed 'hardsect_size'
> >=20
> > Caused by commit e1defc4ff0cf57aca6c5e3ff99fa503f5943c1f1 ("block: Do
> > away with the notion of hardsect_size") from the block tree interacting
> > with commit 131e4477401ae76a9cbe8539e4b7819e04cfba36 ("md: raid0: chunk
> > size check in raid0_run") from the md tree.
>=20
> Martin, this is starting to look like a disaster :-(

So, is anything happening about these?  I still get these (and the dm)
build failures.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Jun_2009_14_42_18_+1000_P=l2AjSGjUIoIYFf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkojXCoACgkQjjKRsyhoI8w+5ACfbbSBLbF5GX39Rzq2Zs9g5w6M
U4kAnjEXlCc7YO617HlJsxWP02nbUlG1
=2VAE
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Jun_2009_14_42_18_+1000_P=l2AjSGjUIoIYFf--
