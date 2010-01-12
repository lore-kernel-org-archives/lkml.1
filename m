Return-Path: <linux-kernel-owner+w=401wt.eu-S1753621Ab0ALCdB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab0ALCdB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jan 2010 21:33:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753018Ab0ALCdA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jan 2010 21:33:00 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47923 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751946Ab0ALCc7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jan 2010 21:32:59 -0500
Date: Tue, 12 Jan 2010 13:32:52 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Albin Tonnerre <albin.tonnerre@free-electrons.com>
Subject: Re: linux-next: origin tree build failure
Message-Id: <20100112133252.8b4591bd.sfr@canb.auug.org.au>
In-Reply-To: <alpine.LFD.2.00.1001111720290.17145@localhost.localdomain>
References: <20100112121434.49930eea.sfr@canb.auug.org.au>
	<alpine.LFD.2.00.1001111720290.17145@localhost.localdomain>
X-Mailer: Sylpheed 3.0.0beta4 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__12_Jan_2010_13_32_52_+1100_YVUlGIs+FYwzVuXl"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__12_Jan_2010_13_32_52_+1100_YVUlGIs+FYwzVuXl
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

On Mon, 11 Jan 2010 17:26:33 -0800 (PST) Linus Torvalds <torvalds@linux-fou=
ndation.org> wrote:
>
> Hmm. I think the real problem is that it allowed LZO to be enabled at all=
,=20
> despite HAVE_KERNEL_LZO not being enabled.
>=20
> In other words, I think the config dependencies for RD_LZO are just=20
> totally broken.

That may be true, however ...

OK, I grabbed your tree, reverted commit
ac4c2a3bbe5db5fc570b1d0ee1e474db7cb22585 ("zlib: optimize inffast when
copying direct from output") (see my other build error email) and then
the tree built.  :-(  I guess there is something else in the partially
created linux-next today that has triggered this build failure.   I will
investigate further.

Sorry about that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__12_Jan_2010_13_32_52_+1100_YVUlGIs+FYwzVuXl
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktL31QACgkQjjKRsyhoI8xB3ACfWUESEwbi6+Uris3WkcTAN7S2
NyAAmQG27IF09Z490ZQBrV3IZdrZeQd6
=sYpi
-----END PGP SIGNATURE-----

--Signature=_Tue__12_Jan_2010_13_32_52_+1100_YVUlGIs+FYwzVuXl--
