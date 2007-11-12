Return-Path: <linux-kernel-owner+w=401wt.eu-S1756333AbXKLJpw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333AbXKLJpw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2007 04:45:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757068AbXKLJpe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Nov 2007 04:45:34 -0500
Received: from viefep18-int.chello.at ([213.46.255.22]:57174 "EHLO
	viefep15-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756449AbXKLJpd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2007 04:45:33 -0500
Subject: Re: iozone write 50% regression in kernel 2.6.24-rc1
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <1194833640.20251.80.camel@ymzhang>
References: <1194601672.20251.60.camel@ymzhang>
	 <1194602064.6289.157.camel@twins>  <1194833640.20251.80.camel@ymzhang>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-5Qp5c6IbYhgVi5Rs+bsN"
Date: Mon, 12 Nov 2007 10:45:28 +0100
Message-Id: <1194860728.7179.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.0 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-5Qp5c6IbYhgVi5Rs+bsN
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Mon, 2007-11-12 at 10:14 +0800, Zhang, Yanmin wrote:

> > Subject: mm: speed up writeback ramp-up on clean systems
>
> I tested kernel 2.6.23, 2,6,24-rc2, 2.6.24-rc2_peter(2.6.24-rc2+this patc=
h).
>=20
> 1) Compare among first/second/following running
> 2.6.23: second run of iozone will get about 28% improvement than first ru=
n.
> 	Following run is very stable like 2nd run.
> 2.6.24-rc2: second run of iozone will get about 170% improvement than fir=
st run. 3rd run
> 	will get about 80% improvement than 2nd. Following run is very stable li=
ke 3rd run.
> 2.6.24-rc2_peter: second run of iozone will get about 14% improvement tha=
n first run. Following
> 	run is mostly stable like 2nd run.
> So the new patch really improves the first run result. Comparing wiht 2.6=
.24-rc2, 2.6.24-rc2_peter
> has 330% improvement on the first run.
>=20
> 2) Compare among different kernels(based on the stable highest result):
> 2.6.24-rc2 has about 50% regression than 2.6.23.
> 2.6.24-rc2_peter has the same result like 2.6.24-rc2.
>
> From this point of view, above patch has no improvement. :)

Drad, still good test results though.

Could you describe you system in detail, that is, you have 8GB of memory
and 8 cpus (2*quad?). How many disks does it have and are those
aggregated using md or dm? What filesystem do you use?



--=-5Qp5c6IbYhgVi5Rs+bsN
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHOCC4XA2jU0ANEf4RAiBIAJ4kTQx8Y9P1Zmdnyyjx4YI1dR0GigCfVJZ4
CLjeSv7ZdFnrpKMV3LmYYuU=
=/jLp
-----END PGP SIGNATURE-----

--=-5Qp5c6IbYhgVi5Rs+bsN--

