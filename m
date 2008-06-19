Return-Path: <linux-kernel-owner+w=401wt.eu-S1756548AbYFSFxy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548AbYFSFxy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2008 01:53:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751606AbYFSFxq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Jun 2008 01:53:46 -0400
Received: from mga11.intel.com ([192.55.52.93]:16637 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751369AbYFSFxp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2008 01:53:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.27,670,1204531200"; 
   d="asc'?scan'208";a="343195452"
Date: Thu, 19 Jun 2008 13:46:09 +0800
From: Zhenyu Wang <zhenyu.z.wang@intel.com>
To: Dave Airlie <airlied@linux.ie>
Cc: torvalds@linux-foundation.org, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [git pull] agp patches for 2.6.26 final
Message-ID: <20080619054609.GA24066@zhen-devel.sh.intel.com>
Mail-Followup-To: Dave Airlie <airlied@linux.ie>,
	torvalds@linux-foundation.org,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
References: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <alpine.DEB.0.82.0806190538490.14089@skynet.skynet.ie>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2008.06.19 05:41:27 +0100, Dave Airlie wrote:
>=20
> Hi Linus,
>=20
> Please pull the 'agp-patches' branch from
> ssh://master.kernel.org/pub/scm/linux/kernel/git/airlied/agp-2.6.git agp-=
patches
>=20
> This contains a fix for a mapping race from Jan, some pci ids from via=20
> via Greg, Intel bugfix + new pci ids, and bool/whitespace cleanups.
>=20
> Dave.
>=20

I'm sorry, Dave. This one seems missing from 4 series chipset enabling
patch, sorry I forgot those chipset flush setup, pls apply this.

Thanks.

[AGP] intel_agp: setup chipset flush like i965 for 4 series chipsets

Signed-off-by: Zhenyu Wang <zhenyu.z.wang@intel.com>
---
 drivers/char/agp/intel-agp.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/char/agp/intel-agp.c b/drivers/char/agp/intel-agp.c
index 1ae64bb..acc4bd5 100644
--- a/drivers/char/agp/intel-agp.c
+++ b/drivers/char/agp/intel-agp.c
@@ -947,8 +947,7 @@ static void intel_i9xx_setup_flush(void)
 	intel_private.ifp_resource.name =3D "Intel Flush Page";
 	intel_private.ifp_resource.flags =3D IORESOURCE_MEM;
=20
-	/* Setup chipset flush for 915 */
-	if (IS_I965 || IS_G33) {
+	if (IS_I965 || IS_G33 || IS_G4X) {
 		intel_i965_g33_setup_chipset_flush();
 	} else {
 		intel_i915_setup_chipset_flush();
--=20
1.5.4


--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkhZ8qEACgkQsQQaM014GCcclgCfcS2hp5pq9JLXo/gsPjse/8g0
dTQAmwcsSmMpat8TJYQ/pOdtSsI0eDYN
=HuRM
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
