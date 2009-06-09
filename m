Return-Path: <linux-kernel-owner+w=401wt.eu-S1755084AbZFIQGS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084AbZFIQGS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 12:06:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753338AbZFIQGI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 12:06:08 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47851 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751764AbZFIQGH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 12:06:07 -0400
Date: Wed, 10 Jun 2009 02:06:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: voyager tree build failure
Message-Id: <20090610020604.fb2b47f3.sfr@canb.auug.org.au>
In-Reply-To: <1244560718.4137.26.camel@mulgrave.site>
References: <20090609194038.826289f3.sfr@canb.auug.org.au>
	<1244560718.4137.26.camel@mulgrave.site>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__10_Jun_2009_02_06_04_+1000_E0XsGo.vQ5J_/viI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__10_Jun_2009_02_06_04_+1000_E0XsGo.vQ5J_/viI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Tue, 09 Jun 2009 10:18:38 -0500 James Bottomley <James.Bottomley@HansenP=
artnership.com> wrote:
>
> Thanks for finding this.  The fix looks to be a dummy definition of this
> function for x86_64.  The final fix (which has been under discussion)
> will be the elimination of safe_smp_processor_id() altogether.
>=20
> I've merged this into the
>=20
> [VOYAGER] x86: add {safe,hard}_smp_processor_id to smp_ops
>=20
> patch and respun the tree (and built it with an x86-64 cross compiler),
> so it should be safe to include next time around

Thanks.  We will see how we do (later) in the morning.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__10_Jun_2009_02_06_04_+1000_E0XsGo.vQ5J_/viI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkouiGwACgkQjjKRsyhoI8z68ACdF2UZ+1EBUACp/4n6YsHBzbV2
lqUAoKWrfoAg2ri1d5AzkSwEe54+AL8h
=yXWE
-----END PGP SIGNATURE-----

--Signature=_Wed__10_Jun_2009_02_06_04_+1000_E0XsGo.vQ5J_/viI--
