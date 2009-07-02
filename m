Return-Path: <linux-kernel-owner+w=401wt.eu-S1753512AbZGBA7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512AbZGBA7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 20:59:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752350AbZGBA7q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 20:59:46 -0400
Received: from mga12.intel.com ([143.182.124.36]:11588 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751579AbZGBA7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 20:59:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.42,329,1243839600"; 
   d="asc'?scan'208";a="160716458"
Date: Thu, 2 Jul 2009 08:59:46 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Andy Whitcroft <apw@canonical.com>, Dave Airlie <airlied@linux.ie>,
       dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] i915: fix up a raw 64bit divide
Message-ID: <20090702005946.GB6705@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Jesse Barnes <jbarnes@virtuousgeek.org>,
	Andy Whitcroft <apw@canonical.com>, Dave Airlie <airlied@linux.ie>,
	dri-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
References: <1246458059-15965-1-git-send-email-apw@canonical.com>
 <20090701091255.363f9d4d@jbarnes-g45>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NDin8bjvE/0mNLFQ"
Content-Disposition: inline
In-Reply-To: <20090701091255.363f9d4d@jbarnes-g45>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NDin8bjvE/0mNLFQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2009.07.01 09:12:55 -0700, Jesse Barnes wrote:
> On Wed,  1 Jul 2009 15:20:59 +0100
> Andy Whitcroft <apw@canonical.com> wrote:
>=20
> > We are seeing compilation failures on i386 in some environments due
> > to an undefined reference as below:
> >=20
> >     ERROR: "__udivdi3" [drivers/gpu/drm/i915/i915.ko] undefined!
> >=20
> > This is generated due to a raw 64 bit divide in the i915 driver.  Fix
> > up this raw divide.
> >=20
> > Signed-off-by: Andy Whitcroft <apw@canonical.com>
>=20
> I think building with newer GCCs will prevent this error, but the fix
> looks fine.
>=20
> Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
>=20

yeah, sorry I didn't catch that.

Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--NDin8bjvE/0mNLFQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkpMBoIACgkQsQQaM014GCdqugCdF00FHZ2Zx4CTdDnzztj1pCYs
v+wAn0LLedM/ppakgoH+Wa1CJpKDhlkR
=f+Q8
-----END PGP SIGNATURE-----

--NDin8bjvE/0mNLFQ--
