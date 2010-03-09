Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab0CIBwz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 20:52:55 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:40253 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0CIBwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 20:52:51 -0500
Date: Tue, 9 Mar 2010 12:52:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org
Subject: Re: [PATCH] ar9170: fix for driver-core ABI change
Message-Id: <20100309125245.c25e5ca4.sfr@canb.auug.org.au>
In-Reply-To: <20100309104221.aedc5e7e.sfr@canb.auug.org.au>
References: <20100309104221.aedc5e7e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Mar_2010_12_52_45_+1100_Ay92DLu+zl5zo5f."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Mar_2010_12_52_45_+1100_Ay92DLu+zl5zo5f.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Tue, 9 Mar 2010 10:42:21 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/net/wireless/ath/ar9170/usb.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
>=20
> I have been carrying this patch in linux-next for some time as a fixup
> for the driver-core tree.  It is now needed in net-2.6 (i.e. my
> net-current) (since you merged the wireless tree) *after* you merge with
> Linus' tree i.e. the down()/up() are present in the net-2.6 tree and the
> changes to the driver core to use mutexes are in Linus' tree.

Greg tells me that the semaphore to mutex change didn't go into Linus'
tree.  However, this patch can still be applied as the device_lock/unlock
primitives did go in.  I guess that the include of mutex.h is not needed.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Mar_2010_12_52_45_+1100_Ay92DLu+zl5zo5f.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuVqe0ACgkQjjKRsyhoI8y6ogCggC5fH9B98EKDHvLEM5it76al
ZrMAn2xyC2pw9bepvBAoWMLxD2tBgHei
=tAvG
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Mar_2010_12_52_45_+1100_Ay92DLu+zl5zo5f.--
