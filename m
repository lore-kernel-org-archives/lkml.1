Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbXLMGah@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbXLMGah (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2007 01:30:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752000AbXLMGa1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Dec 2007 01:30:27 -0500
Received: from ozlabs.org ([203.10.76.45]:44478 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbXLMGaZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2007 01:30:25 -0500
Subject: Re: [RFC] ehea: kdump support using new shutdown hook
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Dave Jones <davej@redhat.com>
Cc: Thomas Klein <osstklei@de.ibm.com>, Paul Mackerras <paulus@samba.org>,
       Christoph Raisch <raisch@de.ibm.com>,
       Jan-Bernd Themann <themann@de.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux-ppc <linuxppc-dev@ozlabs.org>, Marcus Eder <meder@de.ibm.com>,
       netdev <netdev@vger.kernel.org>,
       Stefan Roscher <stefan.roscher@de.ibm.com>,
       Michael Neuling <mikey@neuling.org>
In-Reply-To: <20071212170440.GD2359@redhat.com>
References: <200712121753.43543.osstklei@de.ibm.com>
	 <20071212170440.GD2359@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-tGfd8eIMJyAvH2YKdVzf"
Date: Thu, 13 Dec 2007 17:30:24 +1100
Message-Id: <1197527424.7695.43.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tGfd8eIMJyAvH2YKdVzf
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, 2007-12-12 at 12:04 -0500, Dave Jones wrote:
> On Wed, Dec 12, 2007 at 05:53:43PM +0100, Thomas Klein wrote:
>=20
>  > +static void ehea_update_adapter_handles(struct ehea_adapter *adapter)
>  > +{
>  > +	int i, k;
>  > +	int j =3D 0;
>  > +
>  > +	memset(adapter->res_handles, sizeof(adapter->res_handles), 0);
>=20
> arguments wrong way around.

Remind me why bzero is deprecated again? :)

cheers

--=20
Michael Ellerman
OzLabs, IBM Australia Development Lab

wwweb: http://michael.ellerman.id.au
phone: +61 2 6212 1183 (tie line 70 21183)

We do not inherit the earth from our ancestors,
we borrow it from our children. - S.M.A.R.T Person

--=-tGfd8eIMJyAvH2YKdVzf
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQBHYNGAdSjSd0sB4dIRAoFEAJ9QM6YR0cPfq81FGpxCjKh30Q7reACcCJ7i
/EUszDgbpmAvWyZO1o1oXHg=
=jX6N
-----END PGP SIGNATURE-----

--=-tGfd8eIMJyAvH2YKdVzf--

