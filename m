Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754752Ab0BSHpc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 02:45:32 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:48576 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754717Ab0BSHp2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 02:45:28 -0500
Date: Fri, 19 Feb 2010 18:45:22 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, kristoffer@gaisler.com
Subject: Re: linux-next: build failure after final merge (net tree)
Message-Id: <20100219184522.b89facc7.sfr@canb.auug.org.au>
In-Reply-To: <20100218.233321.226788593.davem@davemloft.net>
References: <20100219173713.e3f9f386.sfr@canb.auug.org.au>
	<20100218.233321.226788593.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.0beta7 (GTK+ 2.18.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__19_Feb_2010_18_45_22_+1100_QV.B4eE8K7zWsXnv"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Feb_2010_18_45_22_+1100_QV.B4eE8K7zWsXnv
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Thu, 18 Feb 2010 23:33:21 -0800 (PST) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Fri, 19 Feb 2010 17:37:13 +1100
>=20
> > I assume that this driver was written and tested only on Sparc
> > ... maybe it should depend on SPARC?
>=20
> Indeed, it should.  I thought for some reason that all OF
> platforms have of_remap() and of_device->resource[], oh
> well :-)
>=20
> Will commit the following, thanks!
>=20
> net: Make GRETH driver depend on SPARC.

Thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__19_Feb_2010_18_45_22_+1100_QV.B4eE8K7zWsXnv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkt+QZIACgkQjjKRsyhoI8wYpACeJUqvzMiseGEskzw6gNJkgkWf
W7oAoLbgidgt2HbDhvUF8sKAvWNLPhQ1
=zEew
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Feb_2010_18_45_22_+1100_QV.B4eE8K7zWsXnv--
