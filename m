Return-Path: <linux-kernel-owner+w=401wt.eu-S1761363AbYHEN3E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761363AbYHEN3E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Aug 2008 09:29:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755652AbYHEN2u
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Aug 2008 09:28:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50688 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755506AbYHEN2s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Aug 2008 09:28:48 -0400
Date: Tue, 5 Aug 2008 23:28:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pull request: wireless-2.6 2008-08-04
Message-Id: <20080805232839.95235680.sfr@canb.auug.org.au>
In-Reply-To: <20080805.012814.215633850.davem@davemloft.net>
References: <20080804193753.GA30345@tuxdriver.com>
	<20080804.150147.78586437.davem@davemloft.net>
	<20080805021710.GA21731@tuxdriver.com>
	<20080805.012814.215633850.davem@davemloft.net>
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.11; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Aug_2008_23_28_39_+1000_GoHZK0.xw2FNjiVO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Aug_2008_23_28_39_+1000_GoHZK0.xw2FNjiVO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

On Tue, 05 Aug 2008 01:28:14 -0700 (PDT) David Miller
<davem@davemloft.net> wrote:
>
> From: "John W. Linville" <linville@tuxdriver.com>
> Date: Mon, 4 Aug 2008 22:17:10 -0400
>=20
> > On Mon, Aug 04, 2008 at 03:01:47PM -0700, David Miller wrote:
> > > I'm holding off on this pull until the list.h changes get so me lkml
> > > ACKs.
> >=20
> > Sure, np.  I created a "no-ath9k" branch in case you are feeling
> > frisky -- it is the same except for omitting the list.h changes,
> > the ath5k pci table change, and the new ath9k driver.
> >=20
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.gi=
t no-ath9k
> >=20
> > Hth!
>=20
> Due to the powerpc build failures the list.h stuff causes, I'm going
             ^^^^^^^
It was a sparc64 defconfig that failed due to the list.h changes.  The
powerpc build only failed when I added an include of <linux/bug.h> to
list.h.

The powerpc compiler got an internal error trying to compile the ath9k
code - but I don't know if there is anything we can to do to the source
to work around that.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Aug_2008_23_28_39_+1000_GoHZK0.xw2FNjiVO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkiYVYcACgkQjjKRsyhoI8wnmgCcDp5xDwUw81MpySveKaTHWRrN
Vj4AoJTltUPIFSTYDpV0mYSgP0pmHINU
=b/De
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Aug_2008_23_28_39_+1000_GoHZK0.xw2FNjiVO--
