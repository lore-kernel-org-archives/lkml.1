Return-Path: <linux-kernel-owner+w=401wt.eu-S1759871AbXIYEls@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759871AbXIYEls (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 00:41:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754914AbXIYEll
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 00:41:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40218 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904AbXIYElk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 00:41:40 -0400
Date: Tue, 25 Sep 2007 14:41:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       lkml - Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Anton Blanchard <anton@au1.ibm.com>, paulus <paulus@au1.ibm.com>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       "Ryan S. Arnold" <rsa@us.ibm.com>, Dave Jones <davej@codemonkey.org.uk>
Subject: Re: [PATCH] Delay creation of khcvd thread
Message-Id: <20070925144125.b25fbe23.sfr@canb.auug.org.au>
In-Reply-To: <1190694461.27805.295.camel@localhost.localdomain>
References: <1190691984.27805.270.camel@localhost.localdomain>
	<20070925140454.566803e5.sfr@canb.auug.org.au>
	<1190694461.27805.295.camel@localhost.localdomain>
X-Mailer: Sylpheed 2.4.6 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__25_Sep_2007_14_41_25_+1000_.yD9G.pY_+QlvvI+"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2007_14_41_25_+1000_.yD9G.pY_+QlvvI+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

On Tue, 25 Sep 2007 14:27:41 +1000 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> HVC console is also used by iSeries, so add that to HVC_DRIVER help.
>=20
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>=20
> diff -r 85d39cbbd21c drivers/char/Kconfig
> --- a/drivers/char/Kconfig	Tue Sep 25 14:23:07 2007 +1000
> +++ b/drivers/char/Kconfig	Tue Sep 25 14:26:01 2007 +1000
> @@ -569,7 +569,7 @@ config HVC_DRIVER
>  	bool
>  	help
>  	  Generic "hypervisor virtual console" infrastructure for various
> -	  hypervisors (pSeries, Xen, lguest).
> +	  hypervisors (pSeries, iSeries, Xen, lguest).
>  	  It will automatically be selected if one of the back-end console driv=
ers
>  	  is selected.

Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>

;-)
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__25_Sep_2007_14_41_25_+1000_.yD9G.pY_+QlvvI+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFG+JF5TgG2atn1QN8RAgmcAJ0RvH1fZqBcYSGKcZMnzDKVZ6Hn5ACfav4l
dPQu0PG5Z4nr6aEv6X632LA=
=jQQ/
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2007_14_41_25_+1000_.yD9G.pY_+QlvvI+--
