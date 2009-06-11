Return-Path: <linux-kernel-owner+w=401wt.eu-S1761766AbZFKCDW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761766AbZFKCDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jun 2009 22:03:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757820AbZFKCDM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Jun 2009 22:03:12 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:60409 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215AbZFKCDL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jun 2009 22:03:11 -0400
Subject: Re: [PATCH] Re:[BUILD FAILURE 04/04] Next June 04:PPC64 randconfig
 [drivers/net/ucc_geth.o]
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: subrata@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, netdev@vger.kernel.org,
       Li Yang <leoli@freescale.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       Linuxppc-dev <Linuxppc-dev@ozlabs.org>,
       Linux-Next <linux-next@vger.kernel.org>,
       Linux-Kernel <linux-kernel@vger.kernel.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
In-Reply-To: <1244685364.6494.14.camel@subratamodak.linux.ibm.com>
References: <20090610174323.28045.70169.sendpatchset@subratamodak.linux.ibm.com>
	 <20090611110523.1fd56a41.sfr@canb.auug.org.au>
	 <1244685364.6494.14.camel@subratamodak.linux.ibm.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Gs/KyC+TrNDFjdC2ZtWn"
Date: Thu, 11 Jun 2009 12:03:11 +1000
Message-Id: <1244685791.4674.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Gs/KyC+TrNDFjdC2ZtWn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-06-11 at 07:26 +0530, Subrata Modak wrote:
> On Thu, 2009-06-11 at 11:05 +1000, Stephen Rothwell wrote:
> > Hi Subrata,
> >=20
> > On Wed, 10 Jun 2009 23:13:23 +0530 Subrata Modak <subrata@linux.vnet.ib=
m.com> wrote:
> > >
> > >  	/* Find the TBI PHY.  If it's not there, we don't support SGMII */
> > > -	ph =3D of_get_property(np, "tbi-handle", NULL);
> > > +	ph =3D (phandle *)of_get_property(np, "tbi-handle", NULL);
> >=20
> > You don't need this cast because of_get_property() returns "void *".
>=20
> Stephen,
>=20
> True. But without this gcc complains:
>=20
> CC [M]  drivers/net/ucc_geth.o
> drivers/net/ucc_geth.c: In function =E2=80=98ucc_geth_probe=E2=80=99:
> drivers/net/ucc_geth.c:3824: warning: assignment discards qualifiers from=
 pointer target type
                                                           ^^^^^^^^^^^

And what does that warning actually mean?

Your cast actually introduces a bug.

cheers

--=-Gs/KyC+TrNDFjdC2ZtWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkowZd8ACgkQdSjSd0sB4dLk5gCcC/h3ugX0KI34JeU9onHHPv7t
iL8AnA6s3XJ6wOJGrHrwg+LQavqZWNw/
=5Ygr
-----END PGP SIGNATURE-----

--=-Gs/KyC+TrNDFjdC2ZtWn--

