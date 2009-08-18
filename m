Return-Path: <linux-kernel-owner+w=401wt.eu-S1751997AbZHRFc5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997AbZHRFc5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Aug 2009 01:32:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751493AbZHRFc5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Aug 2009 01:32:57 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553AbZHRFc4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Aug 2009 01:32:56 -0400
Date: Tue, 18 Aug 2009 15:32:50 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Philipp Reisner <philipp.reisner@linbit.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jens Axboe <jens.axboe@oracle.com>
Subject: Re: linux-next: drbd tree build failure
Message-Id: <20090818153250.5ce293b5.sfr@canb.auug.org.au>
In-Reply-To: <yq1prbk59bv.fsf@sermon.lab.mkp.net>
References: <20090729152938.791a81c3.sfr@canb.auug.org.au>
	<yq1prbk59bv.fsf@sermon.lab.mkp.net>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__18_Aug_2009_15_32_50_+1000_hPJQkj64O8=/s.mY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__18_Aug_2009_15_32_50_+1000_hPJQkj64O8=/s.mY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Martin, Jens,

On Wed, 29 Jul 2009 01:47:48 -0400 "Martin K. Petersen" <martin.petersen@or=
acle.com> wrote:
>
> >>>>> "Stephen" =3D=3D Stephen Rothwell <sfr@canb.auug.org.au> writes:
>=20
> Stephen> drivers/block/drbd/drbd_nl.c: In function
> Stephen> 'drbd_setup_queue_param': drivers/block/drbd/drbd_nl.c:707:
> Stephen> error: implicit declaration of function
> Stephen> 'blk_queue_stack_limits'
>=20
> We've decided to keep blk_queue_stack_limits as a wrapper to ease the
> transition.  I sent Jens a patch earlier today that does this.

I am still getting this error (3 weeks later) ...  :-(

Maybe my original patch should be applied to the drbd tree?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__18_Aug_2009_15_32_50_+1000_hPJQkj64O8=/s.mY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkqKPQIACgkQjjKRsyhoI8z8JgCgp2ofV77nzlTBb2L/XSRstZZE
eDYAnA6Rdm6rhTrf5ZqQVJBnpuLogZle
=Zmer
-----END PGP SIGNATURE-----

--Signature=_Tue__18_Aug_2009_15_32_50_+1000_hPJQkj64O8=/s.mY--
