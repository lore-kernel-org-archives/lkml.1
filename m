Return-Path: <linux-kernel-owner+w=401wt.eu-S1752251AbYHLFjR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752251AbYHLFjR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2008 01:39:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751058AbYHLFjB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Aug 2008 01:39:01 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49794 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875AbYHLFjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2008 01:39:00 -0400
Date: Tue, 12 Aug 2008 15:38:51 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@redhat.com>, Jeff Dike <jdike@addtoit.com>
Subject: Re: linux-next: Tree for August 11
Message-Id: <20080812153851.179fc90d.sfr@canb.auug.org.au>
In-Reply-To: <48A09CE5.70402@ct.jp.nec.com>
References: <20080811164617.7b06df12.sfr@canb.auug.org.au>
	<48A09CE5.70402@ct.jp.nec.com>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Aug_2008_15_38_51_+1000_xzHoOl7Kg4n7u9sP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Aug_2008_15_38_51_+1000_xzHoOl7Kg4n7u9sP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Hiroshi,

On Mon, 11 Aug 2008 13:11:17 -0700 Hiroshi Shimamoto <h-shimamoto@ct.jp.nec=
.com> wrote:
>
> I got an error on um defconfig;
>=20
> arch/um/drivers/line.c: In function 'line_ioctl':
> arch/um/drivers/line.c:306: error: implicit declaration of function 'tioc=
linux'
> make[1]: *** [arch/um/drivers/line.o] Error 1
>=20
>=20
> This commit may cause it.
>=20
> commit 1aa5f1fab397054a9133bcaf511973db5a6b97be
> Author: Alan Cox <alan@redhat.com>
> Date:   Mon Aug 11 10:27:35 2008 +1000
>=20
>     tty-fixup-uml
>=20
>     Add a new nicer hook for tioclinux

It looks like it may be fixed in today's linux-next as that patch has
been updated.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Aug_2008_15_38_51_+1000_xzHoOl7Kg4n7u9sP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkihIesACgkQjjKRsyhoI8x3iwCfUEXEW7KR12/XxIf4BCx5xj85
O1kAn3ug2nes6i4bt2QM7sywMGFmfr99
=S9kg
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Aug_2008_15_38_51_+1000_xzHoOl7Kg4n7u9sP--
