Return-Path: <linux-kernel-owner+w=401wt.eu-S1757632Ab0ANXi5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab0ANXi5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 18:38:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757018Ab0ANXi4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 18:38:56 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58936 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756842Ab0ANXi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 18:38:56 -0500
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       Zhenyu Wang <zhenyu.z.wang@intel.com>,
       Zhenyu Wang <zhenyuw@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       David Woodhouse <dwmw2@infradead.org>
In-Reply-To: <1263508051-7868-15-git-send-email-gregkh@suse.de>
References: <20100114222551.GA7839@suse.de>
	 <1263508051-7868-1-git-send-email-gregkh@suse.de>
	 <1263508051-7868-2-git-send-email-gregkh@suse.de>
	 <1263508051-7868-3-git-send-email-gregkh@suse.de>
	 <1263508051-7868-4-git-send-email-gregkh@suse.de>
	 <1263508051-7868-5-git-send-email-gregkh@suse.de>
	 <1263508051-7868-6-git-send-email-gregkh@suse.de>
	 <1263508051-7868-7-git-send-email-gregkh@suse.de>
	 <1263508051-7868-8-git-send-email-gregkh@suse.de>
	 <1263508051-7868-9-git-send-email-gregkh@suse.de>
	 <1263508051-7868-10-git-send-email-gregkh@suse.de>
	 <1263508051-7868-11-git-send-email-gregkh@suse.de>
	 <1263508051-7868-12-git-send-email-gregkh@suse.de>
	 <1263508051-7868-13-git-send-email-gregkh@suse.de>
	 <1263508051-7868-14-git-send-email-gregkh@suse.de>
	 <1263508051-7868-15-git-send-email-gregkh@suse.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-Idok3jyHuGGowS+uypLY"
Date: Thu, 14 Jan 2010 23:38:48 +0000
Message-ID: <1263512328.17815.103.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
Subject: Re: [Stable-review] [PATCH 15/52] drm: remove address mask param
 for drm_pci_alloc()
X-SA-Exim-Version: 4.2.1 (built Wed, 25 Jun 2008 17:14:11 +0000)
X-SA-Exim-Scanned: Yes (on shadbolt.decadent.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Idok3jyHuGGowS+uypLY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2010-01-14 at 14:26 -0800, Greg Kroah-Hartman wrote:
> From: Zhenyu Wang <zhenyu.z.wang@intel.com>
>=20
> commit e6be8d9d17bd44061116f601fe2609b3ace7aa69 upstream.
>=20
> drm_pci_alloc() has input of address mask for setting pci dma
> mask on the device, which should be properly setup by drm driver.
> And leave it as a param for drm_pci_alloc() would cause confusion
> or mistake would corrupt the correct dma mask setting, as seen on
> intel hw which set wrong dma mask for hw status page. So remove
> it from drm_pci_alloc() function.

Based on comments at <http://bugs.freedesktop.org/show_bug.cgi?id=3D25510>
I think we also need this fix:

commit fc61901373987ad61851ed001fe971f3ee8d96a3
Author: David Woodhouse <dwmw2@infradead.org>
Date:   Wed Dec 2 11:00:05 2009 +0000

    agp/intel-agp: Clear entire GTT on startup

Ben.

--=20
Ben Hutchings
The generation of random numbers is too important to be left to chance.
                                                            - Robert Coveyo=
u

--=-Idok3jyHuGGowS+uypLY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIVAwUAS0+rA+e/yOyVhhEJAQJZnRAAsoIaqYnrDv+duOO7ApiZss2NZBHrA0EF
ggRvKOuFHFMpleyTfMb/ftlPi86jcvqdZXxaSaGpzMSMJRb+8ap+08V1G8ntpLe9
Cm3lXuwhDr3/bpl8XlE5G6OpBeq10FWlNwL1mfFdMclb2Dk4q8EWS8W5YGIE9nhd
AC5z4MycZyZjyj/hNY4z8RaKOdykydlf5Zf0nQoYCIOgLXC1Y14+C4mc/2XkBCXJ
MORV0bI+v/mB/7G4eqSuiqmaqYGIBvWwCTrHnAIoIcQoHLftlsYnx/c7yKY2C9NN
aDmWpZObD3ImFe40r73u7H+XWKPcHpZipTSfQWZuaNMqICI0l8AJsyYjEChd1VxQ
kScp10SHPlApE4D0DbLBdhg7PZVRTSM1tmLfo5HBdW5qmivrdZxdXnG+seP3jAMA
OsGmNAaC8+XGK/r5gDJFNeE7Tvfh3zH9hT7oDH9kVexd239hE66z5aZjwJDx79K3
yOh3qDOGzJUcpcGdeEDcCrRJr70QuUrVkubXQVk8cY+sY6mAzYuWvzx9tM5/6KOy
/c2Dc0AlCcm1psimHx47mib8eaVHuLz0U5M6+qComul4nNasXwAiDXMS14QsPCrg
7moSEhh9Vtq874Vs0XRtgiiWxDro5Zgs7QTVI62qJRtHeFKawfVvKuvB1MGAc1Tl
tKVpk/0SX5w=
=dquK
-----END PGP SIGNATURE-----

--=-Idok3jyHuGGowS+uypLY--
