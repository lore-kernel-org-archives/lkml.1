Return-Path: <linux-kernel-owner+w=401wt.eu-S934199AbZKYCiM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199AbZKYCiM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 21:38:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934143AbZKYCiL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 21:38:11 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:58333 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934099AbZKYCiL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 21:38:11 -0500
Date: Wed, 25 Nov 2009 13:38:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: akpm@linux-foundation.org, dbrownell@users.sourceforge.net,
       spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Michal Simek <michal.simek@petalogix.com>
Subject: Re: [RFC] two new linux-next trees (SPI and devicetree)
Message-Id: <20091125133807.c3803d92.sfr@canb.auug.org.au>
In-Reply-To: <fa686aa40911241654w6ceb2c96nb3a6a57ac1b471f5@mail.gmail.com>
References: <fa686aa40911241654w6ceb2c96nb3a6a57ac1b471f5@mail.gmail.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__25_Nov_2009_13_38_07_+1100_piG94Yi_jaK7gci+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Nov_2009_13_38_07_+1100_piG94Yi_jaK7gci+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

On Tue, 24 Nov 2009 17:54:27 -0700 Grant Likely <grant.likely@secretlab.ca>=
 wrote:
>
> First one is a bunch of SPI patches.  I've made the offer to be SPI
> co-maintainer, but I haven't received any feedback yet from either
> akpm or dbrownell.  In the mean time, I still have a bunch of SPI
> patches (properly signed off and everything) that should have
> linux-next exposure before the merge window.  I've put them in the
> tree shown in the request-pull output below.
>=20
> David, akpm, please note:  I'm not intending to ask Linus to pull this
> tree, but I do really need some feedback on what you want me to do.
> The tree should be properly formed and signed off, so I can ask Linus
> to pull from me directly if you wish.
>=20
>   git://git.secretlab.ca/git/linux-2.6 next-spi

I have added this to linux-next from today.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Wed__25_Nov_2009_13_38_07_+1100_piG94Yi_jaK7gci+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksMmJAACgkQjjKRsyhoI8yh3ACfaoDUwcAhmXibgf2QFr1Z0m0O
P3oAnROWXl2qM4nj4+bzago2xDK8Fvva
=hXsj
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Nov_2009_13_38_07_+1100_piG94Yi_jaK7gci+--
