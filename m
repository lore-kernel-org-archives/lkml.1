Return-Path: <linux-kernel-owner+w=401wt.eu-S1753950AbZFCCev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753950AbZFCCev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jun 2009 22:34:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752205AbZFCCen
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Jun 2009 22:34:43 -0400
Received: from bilbo.ozlabs.org ([203.10.76.25]:48711 "EHLO bilbo.ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752144AbZFCCen (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jun 2009 22:34:43 -0400
Subject: Re: [PATCH 3/4] gcov: add gcov profiling infrastructure
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Oberparleiter <oberpar@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, andi@firstfloor.org, ying.huang@intel.com,
       W.Li@Sun.COM, mingo@elte.hu, heicars2@linux.vnet.ibm.com,
       mschwid2@linux.vnet.ibm.com
In-Reply-To: <20090602150324.c706b1d2.akpm@linux-foundation.org>
References: <20090602114359.129247921@linux.vnet.ibm.com>
	 <20090602114402.951631599@linux.vnet.ibm.com>
	 <20090602150324.c706b1d2.akpm@linux-foundation.org>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-/yl0YER4lCIm2pj2VtSd"
Date: Wed, 03 Jun 2009 12:34:44 +1000
Message-Id: <1243996484.29908.3.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-/yl0YER4lCIm2pj2VtSd
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2009-06-02 at 15:03 -0700, Andrew Morton wrote:
> On Tue, 02 Jun 2009 13:44:02 +0200
> Peter Oberparleiter <oberpar@linux.vnet.ibm.com> wrote:

> > +void __gcov_init(struct gcov_info *info)
> > +{
> > +	static unsigned int gcov_version;
> > +
> > +	mutex_lock(&gcov_lock);
> > +	if (gcov_version =3D=3D 0) {
> > +		gcov_version =3D info->version;
> > +		/*
> > +		 * Printing gcc's version magic may prove useful for debugging
> > +		 * incompatibility reports.
> > +		 */
> > +		pr_info("version magic: 0x%x\n", gcov_version);
>=20
> Will this be spat out as simply
>=20
> version magic: 0x1234
>=20
> ?  If so, that'll be rather obscure because people won't know what
> subsystem printed it.  Prefixing this (and all other printks) with
> "gcov: " would fix that.

Great minds think alike, see a few lines above:

+#define pr_fmt(fmt)	"gcov: " fmt

cheers


--=-/yl0YER4lCIm2pj2VtSd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkol4T8ACgkQdSjSd0sB4dJhrACgyuQxfGU51pE++l8XY46wG155
fAUAn1tGMP2MWzUNi+RQlHaVvYhl9w4V
=1B+R
-----END PGP SIGNATURE-----

--=-/yl0YER4lCIm2pj2VtSd--

