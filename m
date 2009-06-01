Return-Path: <linux-kernel-owner+w=401wt.eu-S1756732AbZFAJYs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756732AbZFAJYs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jun 2009 05:24:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754062AbZFAJYl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Jun 2009 05:24:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46455 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752258AbZFAJYk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jun 2009 05:24:40 -0400
Date: Mon, 1 Jun 2009 19:24:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org,
       jwboyer@linux.vnet.ibm.com, grant.likely@secretlab.ca, paulus@samba.org
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
Message-Id: <20090601192432.9ad7fd94.sfr@canb.auug.org.au>
In-Reply-To: <20090531100843.GB18650@n2100.arm.linux.org.uk>
References: <1243408083.13460.14.camel@debian-nb>
	<20090531100843.GB18650@n2100.arm.linux.org.uk>
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.16.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__1_Jun_2009_19_24_32_+1000_MpOClwNPCRFKralu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__1_Jun_2009_19_24_32_+1000_MpOClwNPCRFKralu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, 31 May 2009 11:08:43 +0100 Russell King - ARM Linux <linux@arm.linu=
x.org.uk> wrote:
>
> > diff --git a/arch/arm/include/asm/of_platform.h b/arch/arm/include/asm/=
of_platform.h
> > new file mode 100644
> > index 0000000..53b4650
> > --- /dev/null
> > +++ b/arch/arm/include/asm/of_platform.h
> > +/* Platform drivers register/unregister */
> > +static inline int of_register_platform_driver(struct of_platform_drive=
r *drv)
> > +{
> > +	return of_register_driver(drv, &of_platform_bus_type);
> > +}
> > +static inline void of_unregister_platform_driver(struct of_platform_dr=
iver *drv)
> > +{
> > +	of_unregister_driver(drv);
> > +}
>=20
> Not sure why this isn't generic code.

They are both in include/linux/of_platform.h since commit
0763ed2355198cdef2f6a2098e9d52eb1fe4365d ("of: make
of_(un)register_platform_driver common code") - added to Linus' tree
on May 5.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__1_Jun_2009_19_24_32_+1000_MpOClwNPCRFKralu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkojnlAACgkQjjKRsyhoI8xiugCgk/bM/dQMNEZOKvL8900x6vU9
ZPYAn2j2oQeyDi28dX8qD7FP2mtQtDRK
=86Nb
-----END PGP SIGNATURE-----

--Signature=_Mon__1_Jun_2009_19_24_32_+1000_MpOClwNPCRFKralu--
