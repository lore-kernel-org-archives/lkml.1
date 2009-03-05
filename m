Return-Path: <linux-kernel-owner+w=401wt.eu-S1754484AbZCEBdw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754484AbZCEBdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Mar 2009 20:33:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750928AbZCEBdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Mar 2009 20:33:42 -0500
Received: from mga02.intel.com ([134.134.136.20]:31873 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751077AbZCEBdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Mar 2009 20:33:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.38,304,1233561600"; 
   d="asc'?scan'208";a="495050224"
Subject: Re: [PATCH] fix DMI for EFI
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Brian Maly <bmaly@redhat.com>, Yinghai Lu <yinghai@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20090304175418.GB29823@elte.hu>
References: <49A9F597.4010601@redhat.com>
	 <86802c440902281856h1dc950e7me8568cd5dca59da9@mail.gmail.com>
	 <49ADEDA3.1030406@redhat.com> <20090304110022.GB18165@elte.hu>
	 <49AE9850.9020103@redhat.com>  <20090304175418.GB29823@elte.hu>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-236M7aES5dQZkOV/Aoox"
Date: Thu, 05 Mar 2009 09:33:38 +0800
Message-Id: <1236216818.24215.24.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-236M7aES5dQZkOV/Aoox
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, 2009-03-05 at 01:54 +0800, Ingo Molnar wrote:
> * Brian Maly <bmaly@redhat.com> wrote:
>=20
> >
> >
> >> Hm, could we ever find ourselves in the positition of having to access=
=20
> >> the DMI strings table in the EFI init code, to implement a quirk? I=20
> >> think that's quite plausible.
> >
> >> OTOH, with some DMI quirks in EFI tables it's a bit of a chicken and=20
> >> egg problem. Can DMI strings ever be outside of EFI tables on EFI=20
> >> systems?
> >
> >> 	Ingo
> >
> > Right now it is EFI that loads the dmi tables (and all other=20
> > tables such as ACPI), so it is a chicken and the egg. I think=20
> > that if dmi is ever needed by EFI, the dmi scan will have to=20
> > be moved inside efi_init. We could move the dmi scan into=20
> > efi_init and do the dmi scan the moment we have the dmi table.=20
> > Thats really the soonest point we could scan on EFI systems.=20
> > Im OK with moving dmi to efi_init if you prefer.
>=20
> Your patch looks fine, but i'd like to hear the opinion of Ying=20
> Huang as well.

This patch is OK for me.

Thanks,
Huang Ying


--=-236M7aES5dQZkOV/Aoox
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkmvK+MACgkQKhFGF+eHlpjzxQCgkdMnzW5yolv13cMqmbYZ+uJD
mGAAnA+LoOkkfzDKIOlCqyvFSHgTPTHh
=5D7M
-----END PGP SIGNATURE-----

--=-236M7aES5dQZkOV/Aoox--

