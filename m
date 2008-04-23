Return-Path: <linux-kernel-owner+w=401wt.eu-S1759866AbYDWFYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759866AbYDWFYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2008 01:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751391AbYDWFYk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Apr 2008 01:24:40 -0400
Received: from ozlabs.org ([203.10.76.45]:53916 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751356AbYDWFYj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2008 01:24:39 -0400
Subject: Re: [PATCH] pci: let pci_device_shutdown to call pci_disable_msi
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: yhlu.kernel@gmail.com
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Jesse Barnes <jbarnes@virtuousgeek.org>, Greg KH <greg@kroah.com>,
       David Miller <davem@davemloft.net>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jeff Garzik <jeff@garzik.org>,
       linux-pci <linux-pci@atrey.karlin.mff.cuni.cz>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@hansenpartnership.com>,
       Sathya Prakash <sathya.prakash@lsi.com>
In-Reply-To: <200804222148.17530.yhlu.kernel@gmail.com>
References: <200804222148.17530.yhlu.kernel@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-vV7QKVQ7awnl7Q/3cZK1"
Date: Wed, 23 Apr 2008 15:24:37 +1000
Message-Id: <1208928277.9212.1.camel@concordia.ozlabs.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-vV7QKVQ7awnl7Q/3cZK1
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-04-22 at 21:48 -0700, Yinghai Lu wrote:
> this change
>=20
> | commit 23a274c8a5adafc74a66f16988776fc7dd6f6e51
> | Author: Prakash, Sathya <sathya.prakash@lsi.com>
> | Date:   Fri Mar 7 15:53:21 2008 +0530
> |
> |     [SCSI] mpt fusion: Enable MSI by default for SAS controllers
> |
> |     This patch modifies the driver to enable MSI by default for all SAS=
 chips.
> |
> |     Signed-off-by: Sathya Prakash <sathya.prakash@lsi.com>
> |     Signed-off-by: James Bottomley <James.Bottomley@HansenPartnership.c=
om>
> |
> cause kexec RHEL 5.1 kernel fail.
>=20
> root casue: the rhel 5.1 kernel still use INTx emulation.
> and mptscsih_shutdown doesn't call pci_disable_msi to reenable INTx on ke=
xec path
>=20
> so try to call pci_disable_msi in shutdown patch

How is kdump going to work? Your shutdown routine won't be called and
you'll have the same problem in the 2nd kernel, won't you?

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-vV7QKVQ7awnl7Q/3cZK1
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIDsgVdSjSd0sB4dIRAhnrAJ9kPazinr8YkXwL+41myB4t+sB7RQCgkfSL
BudHkfcVGHFdlFS8itgb/24=
=KJPn
-----END PGP SIGNATURE-----

--=-vV7QKVQ7awnl7Q/3cZK1--

