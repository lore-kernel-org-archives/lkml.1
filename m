Return-Path: <linux-kernel-owner+w=401wt.eu-S932263AbZD1HlM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263AbZD1HlM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Apr 2009 03:41:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752703AbZD1Hk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Apr 2009 03:40:59 -0400
Received: from mga03.intel.com ([143.182.124.21]:29126 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZD1Hk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Apr 2009 03:40:57 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.40,259,1239001200"; 
   d="asc'?scan'208";a="136676611"
Subject: Re: [PATCH 3/4] PCI: PCIE AER: PCIE AER software error injection
From: Huang Ying <ying.huang@intel.com>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, Andi Kleen <andi@firstfloor.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
In-Reply-To: <49F140F7.4030705@jp.fujitsu.com>
References: <1240541127.6842.681.camel@yhuang-dev.sh.intel.com>
	 <49F140F7.4030705@jp.fujitsu.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-4056tMnHhPRqHP4i1+4a"
Date: Tue, 28 Apr 2009 15:40:55 +0800
Message-Id: <1240904455.6842.1138.camel@yhuang-dev.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-4056tMnHhPRqHP4i1+4a
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi, All,

The PCIE AER software error injection user space tool has been put in:

http://www.kernel.org/pub/linux/utils/pci/aer-inject/

This is the final place. I will change description in success version of
patches.

Best Regards,
Huang Ying

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
>=20
> ?
>=20
> (snip.)
>=20
> > --- /dev/null
> > +++ b/drivers/pci/pcie/aer/Kconfig.debug
> > @@ -0,0 +1,18 @@
> > +#
> > +# PCI Express Root Port Device AER Debug Configuration
> > +#
> > +
> > +config PCIEAER_INJECT
> > +	tristate "PCIE AER error injector support"
> > +	depends on PCIEAER
> > +	default n
> > +	help
> > +	  This enables PCI Express Root Port Advanced Error Reporting
> > +	  (AER) software error injector.
> > +
> > +	  Debuging PCIE AER code is quite difficult because it is hard
> > +	  to trigger various real hardware errors. Software based
> > +	  error injection can fake almost all kinds of errors with the
> > +	  help of a user space helper tool aer-inject, which can be
> > +	  gotten from:
> > +	     http://www.kernel.org/pub/utils/pcie/aer-inject
> >=20
>=20
> Ditto.
>=20
> Thanks,
> Kenji Kaneshige
>=20

--=-4056tMnHhPRqHP4i1+4a
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEABECAAYFAkn2sv4ACgkQKhFGF+eHlpg9dgCfTPs7GGdYqy4gT01h+x9D786T
CFwAn1NnJxoX3llZbW8w7NAeUl6TgClz
=flqG
-----END PGP SIGNATURE-----

--=-4056tMnHhPRqHP4i1+4a--

