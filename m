Return-Path: <linux-kernel-owner+w=401wt.eu-S1759433AbXFQGzV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759433AbXFQGzV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 02:55:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXFQGzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 02:55:10 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45182 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756010AbXFQGzI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 02:55:08 -0400
Date: Sun, 17 Jun 2007 16:55:09 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Roland Dreier <rdreier@cisco.com>
Cc: "jidong xiao" <jidong.xiao@gmail.com>,
       "Randy Dunlap" <randy.dunlap@oracle.com>,
       "Vegard Nossum" <vegard.nossum@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to printk unsigned long long variable?
Message-Id: <20070617165509.9c1256a2.sfr@canb.auug.org.au>
In-Reply-To: <ada1wgdhxft.fsf@cisco.com>
References: <4104961b0706150759l66fd713boac1a747637e73ee@mail.gmail.com>
	<19f34abd0706150804w69ce36c0i9e7f9a015895ac0c@mail.gmail.com>
	<20070615083355.f5bdb784.randy.dunlap@oracle.com>
	<4104961b0706150839t1a54ccdaq4ddc747d04538a19@mail.gmail.com>
	<adaabv1i49q.fsf@cisco.com>
	<4104961b0706150918me1d809fu66ee07738284c21c@mail.gmail.com>
	<ada1wgdhxft.fsf@cisco.com>
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.13; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__17_Jun_2007_16_55_09_+1000_X6NOHkGbVK/YztuV"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__17_Jun_2007_16_55_09_+1000_X6NOHkGbVK/YztuV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, 15 Jun 2007 11:41:58 -0700 Roland Dreier <rdreier@cisco.com> wrote:
>
>  > dma_mask should be a pointer, I mean, the element in struct device, se=
e below,
>=20
> Sorry, you're right.
>=20
> So print it as (unsigned long long) *dev->dma_mask.

And the reason you need to cast it is because u64 is "unsigned long" on
some architectures and "unsigned long long" on others.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__17_Jun_2007_16_55_09_+1000_X6NOHkGbVK/YztuV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFGdNrRFdBgD/zoJvwRAnC9AKCEghqI7zg5kaM04A/GwNiTl8NRqgCgkZ+8
NCDiHpMjn1+WrE8CmoIIAg4=
=OejU
-----END PGP SIGNATURE-----

--Signature=_Sun__17_Jun_2007_16_55_09_+1000_X6NOHkGbVK/YztuV--
