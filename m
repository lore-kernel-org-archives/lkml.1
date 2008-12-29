Return-Path: <linux-kernel-owner+w=401wt.eu-S1754472AbYL2KmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472AbYL2KmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 05:42:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753308AbYL2Kl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 05:41:57 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:37120 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752689AbYL2Kl4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 05:41:56 -0500
Date: Mon, 29 Dec 2008 21:41:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Neil Horman <nhorman@tuxdriver.com>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>,
       Linus <torvalds@linux-foundation.org>, netdev@vger.kernel.org,
       ppc-dev <linuxppc-dev@ozlabs.org>
Subject: Re: [PATCH] clean up of netif_rx_reschedule() changes in drivers
Message-Id: <20081229214144.43be8c1d.sfr@canb.auug.org.au>
In-Reply-To: <20081229102509.GA11111@linux.vnet.ibm.com>
References: <20081229110041.0eca977a.sfr@canb.auug.org.au>
	<20081229102509.GA11111@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Dec_2008_21_41_44_+1100_Vy=lfNnRvOVlTdOm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Dec_2008_21_41_44_+1100_Vy=lfNnRvOVlTdOm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kamalesh,

On Mon, 29 Dec 2008 15:55:29 +0530 Kamalesh Babulal <kamalesh@linux.vnet.ib=
m.com> wrote:
>
> I hit similar build failure due to the change in the netif_rx_reschedule()
>=20
> drivers/net/ehea/ehea_main.c: In function 'ehea_poll':
> drivers/net/ehea/ehea_main.c:844: warning: passing argument 1 of 'netif_r=
x_reschedule' from incompatible pointer type
> drivers/net/ehea/ehea_main.c:844: error: too many arguments to function '=
netif_rx_reschedule'
> make[3]: *** [drivers/net/ehea/ehea_main.o] Error 1

Linus already took a patch for ibmveth and ehea.

> greping through the sources for the changes missed out, we have
>=20
	.
	.
>=20
> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> --
>  drivers/net/arm/ep93xx_eth.c |    2 +-
>  drivers/net/arm/ixp4xx_eth.c |    2 +-
>  drivers/net/wan/ixp4xx_hss.c |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)

Thanks for the patch, I assume that Dave or Linus will take care of that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Dec_2008_21_41_44_+1100_Vy=lfNnRvOVlTdOm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAklYqWgACgkQjjKRsyhoI8yNdwCdFgntGytN5djrgItDgbErjx9S
YuEAn0SWGpiEYM8A0yZA9FnEHJn6mWBd
=B5Pg
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Dec_2008_21_41_44_+1100_Vy=lfNnRvOVlTdOm--
