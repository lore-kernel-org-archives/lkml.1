Return-Path: <linux-kernel-owner+w=401wt.eu-S1753803AbYH1IOX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753803AbYH1IOX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 04:14:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751266AbYH1IOL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 04:14:11 -0400
Received: from systemlinux.org ([83.151.29.59]:38436 "EHLO m18s25.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbYH1IOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 04:14:10 -0400
X-Greylist: delayed 530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Aug 2008 04:14:10 EDT
Date: Thu, 28 Aug 2008 10:04:29 +0200
From: Andre Noll <maan@systemlinux.org>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, jurriaan <thunder7@xs4all.nl>,
       linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>
Subject: Re: 2.6.27-rc4: lots of 'in_atomic():1, irqs_disabled():0' with  software-raid1
Message-ID: <20080828080429.GD4247@skl-net.de>
References: <20080827170538.GA24393@amd64.of.nowhere> <200808272347.43577.rjw@sisk.pl> <20080828073324.GR20055@kernel.dk> <20080828004532.45d8b8c9.akpm@linux-foundation.org> <20080828074830.GV20055@kernel.dk> <20080828075607.GA3795@skl-net.de> <20080828081113.GW20055@kernel.dk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k4f25fnPtRuIRUb3"
Content-Disposition: inline
In-Reply-To: <20080828081113.GW20055@kernel.dk>
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k4f25fnPtRuIRUb3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 10:11, Jens Axboe wrote:
> > Also, md_super_write() does not check the return value of bio_alloc().
> > That probably needs fixing as well.
>=20
> No, that's the guarentee of mempool_alloc() - as long as you have
> __GFP_WAIT set, you'll never see a NULL return.

Ah, OK. Thanks for the clarification.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--k4f25fnPtRuIRUb3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFItlwNWto1QDEAkw8RAjl4AJ0VmE7aVE9tIaIZwo6bGllQ9VlZZQCeLk4o
QR6fajciXsC85J8ST3Prvuo=
=Hya3
-----END PGP SIGNATURE-----

--k4f25fnPtRuIRUb3--
