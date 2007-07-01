Return-Path: <linux-kernel-owner+w=401wt.eu-S1756164AbXGAHN5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164AbXGAHN5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2007 03:13:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753377AbXGAHNt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Jul 2007 03:13:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55943 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406AbXGAHNt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2007 03:13:49 -0400
Date: Sun, 1 Jul 2007 17:13:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rodolfo Giometti <giometti@enneenne.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] LinuxPPS (with new syscalls API) - new version
Message-Id: <20070701171325.29d8b184.sfr@canb.auug.org.au>
In-Reply-To: <20070630171340.GT13886@enneenne.com>
References: <20070628081538.GP13886@enneenne.com>
	<1183019474.1170.66.camel@pmac.infradead.org>
	<20070628084003.GQ13886@enneenne.com>
	<1183031060.1170.145.camel@pmac.infradead.org>
	<20070628161450.GD13886@enneenne.com>
	<1183117082.1170.308.camel@pmac.infradead.org>
	<20070629150813.GM13886@enneenne.com>
	<1183132548.1170.360.camel@pmac.infradead.org>
	<20070629163422.GP13886@enneenne.com>
	<1183135253.17622.5.camel@shinybook.infradead.org>
	<20070630171340.GT13886@enneenne.com>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__1_Jul_2007_17_13_25_+1000_k8_NAgIbIqrN1VDj"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__1_Jul_2007_17_13_25_+1000_k8_NAgIbIqrN1VDj
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Jun 2007 19:13:40 +0200 Rodolfo Giometti <giometti@enneenne.com>=
 wrote:
>
> Maybe I can define a special struct for exchanging time data as:
>=20
>    struct pps_timedata_s {
>       long sec;
>       long nsec;
>    }
>=20
> and managing time data conversions at userland...
>=20
> What do you think about that? :)

"long" is one of the datatypes that changes size between 32 bit and 64
bit, so not such a good choice. You could use __u32 or __64 (or
whatever), that makes it very clear that these are fixed size data types.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__1_Jul_2007_17_13_25_+1000_k8_NAgIbIqrN1VDj
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGh1QaTgG2atn1QN8RAvc0AKCTikSqkoucmiBWX48Xz7FKH7h9KACgkRp1
9jwe4Pkzyva97mn0wVHu7T8=
=UVZQ
-----END PGP SIGNATURE-----

--Signature=_Sun__1_Jul_2007_17_13_25_+1000_k8_NAgIbIqrN1VDj--
