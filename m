Return-Path: <linux-kernel-owner+w=401wt.eu-S1753316AbZDVCdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbZDVCdU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 22:33:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbZDVCdD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 22:33:03 -0400
Received: from mga11.intel.com ([192.55.52.93]:27952 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751162AbZDVCdB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 22:33:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,228,1239001200"; 
   d="asc'?scan'208";a="683714337"
Subject: Re: [PATCH -v2] Add MCE support to KVM
From: Huang Ying <ying.huang@intel.com>
To: Avi Kivity <avi@redhat.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Andi Kleen <andi@firstfloor.org>
In-Reply-To: <49EDF287.9020908@redhat.com>
References: <1239953345.6842.3.camel@yhuang-dev.sh.intel.com>
	 <49E9F7BE.4090904@codemonkey.ws> <49EAE334.9020803@redhat.com>
	 <49EDF057.9060501@codemonkey.ws>  <49EDF287.9020908@redhat.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-ZjdCPRTC2vMrTYyoKDMq"
Date: Wed, 22 Apr 2009 10:32:52 +0800
Message-Id: <1240367572.6842.375.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZjdCPRTC2vMrTYyoKDMq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-04-22 at 00:21 +0800, Avi Kivity wrote:
> Anthony Liguori wrote:
> >
> > Regardless of the KVM interface for this, to go upstream to QEMU, this=20
> > needs a TCG implementation which means the logic must be duplicated in=20
> > userspace.  In particular, this is because a user-visible command is=20
> > being introduced in the monitor.
>=20
> Definitely.
>=20
> >
> > So Avi, regardless of what interface is chosen for KVM, can you hold=20
> > off applying these patches until there is a TCG implementation? =20
> > Otherwise, we'll be playing catchup between kvm-userspace and upstream=20
> > QEMU forever.
>=20
> I have a feeling we will anyway, but that's no reason to increase the=20
> gap.  Huang, can you generate a version for qemu/tcg?

OK. I will implement the qemu/tcg support.

Best Regards,
Huang Ying


--=-ZjdCPRTC2vMrTYyoKDMq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknugdIACgkQKhFGF+eHlpiuzQCfXMUf0kwmNOMr12ogaJwdF3uj
pLUAnREk7F3jECe/8EwjyRqxHuaj0wal
=oL1D
-----END PGP SIGNATURE-----

--=-ZjdCPRTC2vMrTYyoKDMq--

