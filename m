Return-Path: <linux-kernel-owner+w=401wt.eu-S1754675AbYJ3CDS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754675AbYJ3CDS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 22:03:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752004AbYJ3CDD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 22:03:03 -0400
Received: from mga01.intel.com ([192.55.52.88]:46099 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbYJ3CDB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 22:03:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,511,1220252400"; 
   d="asc'?scan'208";a="633176613"
Subject: Re: [PATH -mm -v2] Fix a race condtion of oops_in_progress
From: Huang Ying <ying.huang@intel.com>
To: Chris Snook <csnook@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <49087871.3010303@redhat.com>
References: <1225268796.24095.48.camel@yhuang-dev.sh.intel.com>
	 <49087871.3010303@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-cfKCy/D25sQ2d8swzmf2"
Date: Thu, 30 Oct 2008 10:02:59 +0800
Message-Id: <1225332179.24095.61.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-cfKCy/D25sQ2d8swzmf2
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, Chris,

On Wed, 2008-10-29 at 08:51 -0600, Chris Snook wrote:
> Huang Ying wrote:
> > Fix a race condition accessing oops_in_progress.  Which may be changed =
on
> > multiple CPU simultaneously, but it is changed via non-atomic operation
> > ++/--.  This patch changes the definition of oops_in_process from int t=
o
> > atomic_t, and accessing method to atomic operations.
>=20
> You also need barriers.  I believe rmb() before atomic_read() and wmb() a=
fter=20
> atomic_set() should suffice.

I don't think that is necessary. I haven't found there is particular
consistent requirement about oops_in_progress.

Best Regards,
Huang Ying


--=-cfKCy/D25sQ2d8swzmf2
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkkJFc0ACgkQKhFGF+eHlphovwCgqYa9Bfjch32UMwLb8EEXwBFr
WCQAn1UawQHscEK+fbTbltUQvdvJaqX3
=MHmX
-----END PGP SIGNATURE-----

--=-cfKCy/D25sQ2d8swzmf2--

