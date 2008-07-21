Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834AbYGUXHz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834AbYGUXHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2008 19:07:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYGUXHr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Jul 2008 19:07:47 -0400
Received: from ozlabs.org ([203.10.76.45]:51062 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751694AbYGUXHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2008 19:07:47 -0400
Subject: Re: [PATCH] pci kernel-doc fatal error
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
       torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org,
       linux-pci@vger.kernel.org
In-Reply-To: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
References: <20080721092718.f15dc1ea.randy.dunlap@oracle.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-zEK04WH6TS+LtIawmRZq"
Date: Tue, 22 Jul 2008 09:07:45 +1000
Message-Id: <1216681665.7427.9.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-zEK04WH6TS+LtIawmRZq
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, 2008-07-21 at 09:27 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
>=20
> Fix kernel-doc comments so that they don't produce errors.
> Also cut some extraneous copy-paste text.
>=20
> Error(linhead//drivers/pci/pci.c:1133): duplicate section name 'Descripti=
on'
> Error(linhead//drivers/pci/pci.c:1189): duplicate section name 'Descripti=
on'

But now the description lines exceed 80 columns, and with longer
function names it's even harder to write a meaningful description in
under 80 columns.

Couldn't kerneldoc be modified to accept multiline descriptions? I know
they're /short/ descriptions, but still.

cheers

ps. I did look at changing kerneldoc to do that myself, but whereas
previously I thought I didn't really know perl, now I /know/ I totally
don't know perl ;)


> --- linhead.orig/drivers/pci/pci.c
> +++ linhead/drivers/pci/pci.c
> @@ -1123,8 +1123,7 @@ int pci_enable_wake(struct pci_dev *dev,
>  }
> =20
>  /**
> - * pci_prepare_to_sleep - prepare PCI device for system-wide transition =
into
> - *                        a sleep state
> + * pci_prepare_to_sleep - prepare PCI device for system-wide transition =
into a sleep state
>   * @dev: Device to handle.
>   *
>   * Choose the power state appropriate for the device depending on whethe=
r
> @@ -1181,8 +1180,7 @@ int pci_prepare_to_sleep(struct pci_dev
>  }
>
>  /**
> - * pci_back_from_sleep - turn PCI device on during system-wide transitio=
n into
> - *                       the working state a sleep state
> + * pci_back_from_sleep - turn PCI device on during system-wide transitio=
n into working state
>   * @dev: Device to handle.
>   *
>   * Disable device's sytem wake-up capability and put it into D0.

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-zEK04WH6TS+LtIawmRZq
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBIhRbAdSjSd0sB4dIRAreBAJ497FIHr3HGUrkrzBoxP7kTEngY+gCgrZdw
ajkuzNkWrLJGpS91XdWIK7I=
=9VyT
-----END PGP SIGNATURE-----

--=-zEK04WH6TS+LtIawmRZq--

