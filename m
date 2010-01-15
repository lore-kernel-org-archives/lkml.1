Return-Path: <linux-kernel-owner+w=401wt.eu-S1756591Ab0AOA4N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0AOA4N (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 19:56:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754557Ab0AOA4M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 19:56:12 -0500
Received: from mga12.intel.com ([143.182.124.36]:36578 "EHLO
	azsmga102.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755982Ab0AOA4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 19:56:10 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.47,316,1257148800"; 
   d="asc'?scan'208";a="232958004"
Date: Fri, 15 Jan 2010 08:56:06 +0800
From: Zhenyu Wang <zhenyuw@linux.intel.com>
To: Greg KH <gregkh@suse.de>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       Dave Airlie <airlied@redhat.com>, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [Stable-review] [PATCH 15/52] drm: remove address mask param
 for drm_pci_alloc()
Message-ID: <20100115005606.GA3562@zhen-devel.sh.intel.com>
Reply-To: Zhenyu Wang <zhenyuw@linux.intel.com>
Mail-Followup-To: Greg KH <gregkh@suse.de>,
	Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	Dave Airlie <airlied@redhat.com>, akpm@linux-foundation.org,
	torvalds@linux-foundation.org,
	David Woodhouse <dwmw2@infradead.org>
References: <1263508051-7868-8-git-send-email-gregkh@suse.de>
 <1263508051-7868-9-git-send-email-gregkh@suse.de>
 <1263508051-7868-10-git-send-email-gregkh@suse.de>
 <1263508051-7868-11-git-send-email-gregkh@suse.de>
 <1263508051-7868-12-git-send-email-gregkh@suse.de>
 <1263508051-7868-13-git-send-email-gregkh@suse.de>
 <1263508051-7868-14-git-send-email-gregkh@suse.de>
 <1263508051-7868-15-git-send-email-gregkh@suse.de>
 <1263512328.17815.103.camel@localhost>
 <20100114234516.GA25061@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <20100114234516.GA25061@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2010.01.14 15:45:16 -0800, Greg KH wrote:
> On Thu, Jan 14, 2010 at 11:38:48PM +0000, Ben Hutchings wrote:
> > On Thu, 2010-01-14 at 14:26 -0800, Greg Kroah-Hartman wrote:
> > > From: Zhenyu Wang <zhenyu.z.wang@intel.com>
> > >=20
> > > commit e6be8d9d17bd44061116f601fe2609b3ace7aa69 upstream.
> > >=20
> > > drm_pci_alloc() has input of address mask for setting pci dma
> > > mask on the device, which should be properly setup by drm driver.
> > > And leave it as a param for drm_pci_alloc() would cause confusion
> > > or mistake would corrupt the correct dma mask setting, as seen on
> > > intel hw which set wrong dma mask for hw status page. So remove
> > > it from drm_pci_alloc() function.
> >=20
> > Based on comments at <http://bugs.freedesktop.org/show_bug.cgi?id=3D255=
10>
> > I think we also need this fix:
> >=20
> > commit fc61901373987ad61851ed001fe971f3ee8d96a3
> > Author: David Woodhouse <dwmw2@infradead.org>
> > Date:   Wed Dec 2 11:00:05 2009 +0000
> >=20
> >     agp/intel-agp: Clear entire GTT on startup
> >=20
> > Ben.
>=20
> Ok, I can add that as well, if the Intel / DRM people do not object.
>=20
> Anyone?
>=20

yeah, please add that one too, it's an important fix.

thanks.

--=20
Open Source Technology Center, Intel ltd.

$gpg --keyserver wwwkeys.pgp.net --recv-keys 4D781827

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktPvSYACgkQsQQaM014GCf67ACgjr2WznHFOQY63ReICov22j4o
MLQAn1BypSDrUKpXgu2RBhPhyN27nlUk
=Jt04
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
