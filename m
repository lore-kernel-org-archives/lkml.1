Return-Path: <linux-kernel-owner+w=401wt.eu-S1758626AbZDXEg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758626AbZDXEg2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 00:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758561AbZDXEgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 00:36:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:23699 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758542AbZDXEgM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 00:36:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,239,1239001200"; 
   d="asc'?scan'208";a="509510345"
Subject: Re: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
From: Huang Ying <ying.huang@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <49F140F7.4030705@jp.fujitsu.com>
References: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
	 <49F140F7.4030705@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-mEg5Ds2WsurX4kC7Ordy"
Date: Fri, 24 Apr 2009 12:36:09 +0800
Message-Id: <1240547769.6842.782.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-mEg5Ds2WsurX4kC7Ordy
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, 2009-04-24 at 12:32 +0800, Kenji Kaneshige wrote:
> Huang Ying wrote:
> > Debugging PCIE AER code can be very difficult because it is hard to
> > trigger various real hardware errors. This patch provide a software
> > based error injection tool, which can fake various PCIE errors with a
> > user space helper tool named "aer-inject". Which can be gotten from:
> >=20
> >   http://www.kernel.org/pub/linux/kernel/people/yhuang/
> >=20
> > The patch fakes AER error by faking some PCIE AER related registers
> > and an AER interrupt for specified the PCIE device.
> >=20
> > Signed-off-by: Huang Ying <ying.huang@intel.com>
> >=20
> > ---
> >  drivers/pci/pcie/aer/Kconfig       |    2=20
> >  drivers/pci/pcie/aer/Kconfig.debug |   18 +
> >  drivers/pci/pcie/aer/Makefile      |    1=20
> >  drivers/pci/pcie/aer/aer_inject.c  |  472 ++++++++++++++++++++++++++++=
+++++++++
> >  4 files changed, 493 insertions(+)
> >=20
> > --- /dev/null
> > +++ b/drivers/pci/pcie/aer/aer_inject.c
> > @@ -0,0 +1,472 @@
> > +/*
> > + * PCIE AER software error injection support.
> > + *
> > + * Debuging PCIE AER code is quite difficult because it is hard to
> > + * trigger various real hardware errors. Software based error
> > + * injection can fake almost all kinds of errors with the help of a
> > + * user space helper tool aer-inject, which can be gotten from:
> > + *   http://www.kernel.org/pub/utils/pcie/aer-inject
>=20
> Shouldn't it be=20
>=20
> http://www.kernel.org/pub/linux/kernel/people/yhuang/

Yes. I forget to change this. But the directory to put aer-inject tar
ball is subject to be changed. I am contacting with kernel.org ftp
maintainer for appropriate place.

Best Regards,
Huang Ying

--=-mEg5Ds2WsurX4kC7Ordy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAknxQbYACgkQKhFGF+eHlpgUGgCfdm4/W/IVxQoN1pcNQOTHX2uP
R3YAoISrPhQOOmIN27TRxImbi8QQE1ng
=r31m
-----END PGP SIGNATURE-----

--=-mEg5Ds2WsurX4kC7Ordy--

