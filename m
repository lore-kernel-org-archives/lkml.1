Return-Path: <linux-kernel-owner+w=401wt.eu-S1754081AbXLXCoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754081AbXLXCoO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 21:44:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751557AbXLXCoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 21:44:05 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57304 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751459AbXLXCoE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 21:44:04 -0500
Date: Mon, 24 Dec 2007 13:43:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: balbir@linux.vnet.ibm.com
Cc: linuxppc-dev@ozlabs.org, akpm@linux-foundation.org, gregkh@suse.de,
       linux-kernel@vger.kernel.org
Subject: Re: Build breakage on powerpc with 2.6.24-rc6-mm1
Message-Id: <20071224134353.c00fc231.sfr@canb.auug.org.au>
In-Reply-To: <20071223224158.GA7975@linux.vnet.ibm.com>
References: <20071223224158.GA7975@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__24_Dec_2007_13_43_53_+1100_HJmzWKCz5Gt4yzl+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__24_Dec_2007_13_43_53_+1100_HJmzWKCz5Gt4yzl+
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Balbir,

Thanks for the report.

On Mon, 24 Dec 2007 04:11:58 +0530 Balbir Singh <balbir@linux.vnet.ibm.com>=
 wrote:
>
> I see the following error with the iseries_veth driver in 2.6.24-rc6-mm1
>=20
> drivers/net/iseries_veth.c: In function =E2=80=98veth_init_connection=E2=
=80=99:
> drivers/net/iseries_veth.c:818: warning: unused variable =E2=80=98rc=E2=
=80=99
> drivers/net/iseries_veth.c: In function =E2=80=98veth_probe_one=E2=80=99:
> drivers/net/iseries_veth.c:1086: error: =E2=80=98veth_port_ktypeq=E2=80=
=99 undeclared
> (first use in this function)
> drivers/net/iseries_veth.c:1086: error: (Each undeclared identifier is
> reported only once
> drivers/net/iseries_veth.c:1086: error: for each function it appears
> in.)
> make[2]: *** [drivers/net/iseries_veth.o] Error 1
> make[1]: *** [drivers/net] Error 2
> make: *** [drivers] Error 2

Yeah, that would be
gregkh-driver-kobject-convert-drivers-net-iseries_vethc-to-use-kobject_init=
-add_ng.

Hi Greg, do you even build with your patches applied?

> Here's a patch, compile tested to fix the compilation problem

Hopefully Greg will fix his original patch before it reaches Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__24_Dec_2007_13_43_53_+1100_HJmzWKCz5Gt4yzl+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFHbxztTgG2atn1QN8RAiFeAJ0eoC9FEIZUKdcCZzLUx4IiO4gHbQCffn6T
XYCe4KW5c/YRjg0iPPka1h4=
=o0P7
-----END PGP SIGNATURE-----

--Signature=_Mon__24_Dec_2007_13_43_53_+1100_HJmzWKCz5Gt4yzl+--
