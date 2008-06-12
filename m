Return-Path: <linux-kernel-owner+w=401wt.eu-S1757334AbYFLRGn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757334AbYFLRGn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 13:06:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753697AbYFLRGe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 13:06:34 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:34719 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752302AbYFLRGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 13:06:33 -0400
Subject: Re: Problem: Out of memory after 2days with 2GB RAM
From: Johannes Berg <johannes@sipsolutions.net>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Rik van Riel <riel@redhat.com>, Zdenek Kabelac <zdenek.kabelac@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       yi.zhu@intel.com, reinette.chatre@intel.com,
       linux-wireless@vger.kernel.org
In-Reply-To: <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com> (sfid-20080612_183546_862400_74C1FB2A)
References: <c4e36d110806120307n20cce692s9c136f11596f5ab0@mail.gmail.com>
	 <20080612093833.0fb9cdd6@bree.surriel.com>
	 <1213278884.3936.15.camel@johannes.berg>
	 <1ba2fa240806120843s268b2ff4mb45a11adf11afc7f@mail.gmail.com>
	 <1ba2fa240806120935r54a080eci7fa6fafc718eed17@mail.gmail.com>
	 (sfid-20080612_183546_862400_74C1FB2A)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-US5klRkV1nBE0x3GLjJR"
Date: Thu, 12 Jun 2008 19:05:35 +0200
Message-Id: <1213290335.3730.4.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-US5klRkV1nBE0x3GLjJR
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> > Probably. it would be safe to use vmalloc for allocating txb anyway.
> > I'll give it a try.
>=20
> So vmalloc  didn't break anything on the 32bit machine I'm just about
> to install 64 one so it will take hour or two.. I will issue some
> official patch after that.

Well, I disagree, and I'll push my patch as soon as somebody confirms
that it doesn't break anything.

> > There was already discussion on LKML about memory allocation problems
> > on X86_64, which might explain this regression. This didn't happen
> > before.
>=20
> This is  the thread title if you are interested.
> 'x86/kernel/pci_dma.c: gfp |=3D __GFP_NORETRY'

Like I said, it doesn't matter, there's no need to _waste_
18*256*sizeof(void *) bytes memory.

johannes

--=-US5klRkV1nBE0x3GLjJR
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIUVdbAAoJEKVg1VMiehFYIc4P/2Ebf+XPaW6s4/BYvH7HpIbq
/JocDvLUzk+q8+NJ468tJ5KNUxcJ2K18A7YiVUHY8vUg+PhIFACCm9cmaUwnOcws
4kh98S8CVVA4yDAyeW20ZVZe9tEznf1XL3HiAmbh0zaL5/shmBTGmO7c9MH8TAJS
MZ7phLWNkXUN0I7pB3Gmv3vpPWb1cT4F/CcaZ6w+uvvcc50CMerPgGE1hrVipSej
8A9a0G7lPpU/vY1TGQhsAlRtQeflpT+Ao4lbw06iq9cUaSSCodtt+FEv16Oags/9
c1MJKyZP4/O66lfSkzN9mcv11+yXZPXy7+pqOgSXvfCJ7MGkPQab9CGANLUR0t6z
O3Sb7UbohJXHBgWj7q/qx8eGgB46esn6FeJLRpKxpxCSQM+HHHsJO4DpwnQFqnrT
NCMw+D2u1k8LF45Ujlom7hXTnn06nMmc4PedZaZipYqwTynqHfJvxZRxEOI42fuj
XF1s6dQEvwacX2ICUT2GBS9KUZmfDtpcn0U6FNjo4RhRtKTOuUbTpjfzZ6ipVnIQ
dOap5GmTeWNq6igpXmi6JaLPv4k1dKUwfbTsnk0cCsHgb2DzLj+POXk9XQG1/zhU
7Y0oO0vydbzXclTOIPDFcN6gMg1K9TBNVFP1lxD9OTp9jDBsj+Pue3wuYn+a0UEB
TsJej93PUIbo/uSgaMpk
=4EsQ
-----END PGP SIGNATURE-----

--=-US5klRkV1nBE0x3GLjJR--

