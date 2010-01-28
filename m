Return-Path: <linux-kernel-owner+w=401wt.eu-S1756478Ab0A1XZv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab0A1XZv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 18:25:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386Ab0A1XZu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 18:25:50 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39220 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756347Ab0A1XZt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 18:25:49 -0500
Date: Fri, 29 Jan 2010 10:25:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: sparc tree build warning
Message-Id: <20100129102543.7af32673.sfr@canb.auug.org.au>
In-Reply-To: <20100128.052432.251700168.davem@davemloft.net>
References: <20091214163338.f811722f.sfr@canb.auug.org.au>
	<20100128184423.40ce38fb.sfr@canb.auug.org.au>
	<20100128.052432.251700168.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta6 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Jan_2010_10_25_43_+1100_tYJ9dg8obKDZEjX4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jan_2010_10_25_43_+1100_tYJ9dg8obKDZEjX4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 28 Jan 2010 05:24:32 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Thu, 28 Jan 2010 18:44:23 +1100
>=20
> > I am still seeing these.  Is it my compiler version (gcc4.4.0)?
>=20
> You can't turn on DEBUG_STRICT_USER_COPY_CHECKS and
> expect a successful build.  It's for developers to
> look at the errors that are generated and audit those
> cases in detail.

These are defconfig builds and CONFIG_DEBUG_STRICT_USER_COPY_CHECKS is
not set in either case.

> You'll get the same exact errors as on i386.

I only do an i386 defconfig build and I don't get these warnings.

> Please just elide the option from your test builds.

I would if I could :-)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Jan_2010_10_25_43_+1100_tYJ9dg8obKDZEjX4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktiHPcACgkQjjKRsyhoI8x6PwCgqx7eiYxGk/2fLdT88Hp2UzDj
txcAoJuTF6nFMgi8yu6ONL5B5RFqT2bY
=HsMS
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jan_2010_10_25_43_+1100_tYJ9dg8obKDZEjX4--
