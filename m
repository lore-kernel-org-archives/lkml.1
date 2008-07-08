Return-Path: <linux-kernel-owner+w=401wt.eu-S1757910AbYGHULP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757910AbYGHULP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:11:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757466AbYGHUKl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:10:41 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51553 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418AbYGHUKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:10:40 -0400
Subject: Re: [RFC 06/11] remove CONFIG_KMOD from fs
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20080708195736.GE11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net>
	 <20080708170045.990097000@sipsolutions.net>
	 <20080708195736.GE11954@cs181140183.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-iSiuowsa2p+ZqrXi/7tF"
Date: Tue, 08 Jul 2008 22:09:56 +0200
Message-Id: <1215547796.3670.13.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-iSiuowsa2p+ZqrXi/7tF
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-08 at 22:57 +0300, Adrian Bunk wrote:
> On Tue, Jul 08, 2008 at 07:00:21PM +0200, Johannes Berg wrote:
> >...
> > --- everything.orig/fs/nls/nls_base.c	2008-07-08 18:32:40.000000000 +02=
00
> > +++ everything/fs/nls/nls_base.c	2008-07-08 18:34:44.000000000 +0200
> >...
> > @@ -216,15 +214,13 @@ static struct nls_table *find_nls(char *
> >  struct nls_table *load_nls(char *charset)
> >  {
> >  	struct nls_table *nls;
> > -#ifdef CONFIG_KMOD
> >  	int ret;
> > -#endif
>=20
> That gives an "unused variable" gcc warning with CONFIG_MODULES=3Dn.

Will fix, thanks.

johannes

--=-iSiuowsa2p+ZqrXi/7tF
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc8mQAAoJEKVg1VMiehFYkdQP/10d+Vye1KpXzIqQ9Ta/5oDD
axjCvi0I3DaAtEHzayMDsyaYci2fPiIEmn2DzMPQnTNFNeoLAimhpigfE0TBWeMi
nkv2VIWfqWhrMeHZqv0GoyzgVzQSOJVRcLakZDVwHWrPS4rZdpmg94JS/1PYyuII
pESyMbkhOxzMyVfTccqApwrh1mIEySS8LXQJpNT9L52bMNJR9Qfi8mGfjpeoesZ0
OHkr7wrpf2D/SnVt1wWLSsbFS78fCCBWj1Tjyfdwqx+nX/6jbOnHecdAByxrYQSj
WLxPIu3X4IyAfYXbP/SnemwuC6NxZqaNobP0FWAWjsWNsHSBseW8gfYQRRkAfO4Z
5sRVvLF0xdIjn1mP+s9zAV+U/Eo73afEQizUm637gp7XWv7WRlSwFj4DBINRMszZ
YCLFvNuL6nMzYteno9K8Cbib1x57Cs3t3OQQwSBz6JWZhT0kquQa1ytyPSEpY49U
TMW/Pk7uQxd1De021tqsnjjyxkIT3lMami3iQ0DtuAm/2G8esU0oPmOX0IEZlamD
eJ6M7qdJwPFC2yxo5XD+jn1dzBteZQ4RHlb/kLFmegaf9BBQStNWGJ8xuCZx3Q/0
s+cbunhYUK+la7xnESFU/6Xq0N9c7awh9+f9FTyCsEcl534vQlH/l9+VYL/sFe5Z
fcDX4Xmz09BT4U7+gd/0
=kikj
-----END PGP SIGNATURE-----

--=-iSiuowsa2p+ZqrXi/7tF--

