Return-Path: <linux-kernel-owner+w=401wt.eu-S1757604AbYGHUM2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757604AbYGHUM2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 16:12:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbYGHUMR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 16:12:17 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:51608 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbYGHUMR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 16:12:17 -0400
Subject: Re: [RFC 06/11] remove CONFIG_KMOD from fs
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
       Christoph Hellwig <hch@infradead.org>
In-Reply-To: <20080708195736.GE11954@cs181140183.pp.htv.fi>
References: <20080708170015.470877000@sipsolutions.net>
	 <20080708170045.990097000@sipsolutions.net>
	 <20080708195736.GE11954@cs181140183.pp.htv.fi>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-FwEQVwrH21NkRDjsELeo"
Date: Tue, 08 Jul 2008 22:11:33 +0200
Message-Id: <1215547893.3670.15.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-FwEQVwrH21NkRDjsELeo
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

Actually, would anyone object to removing the printk and just using
try_then_request_module?

johannes

--=-FwEQVwrH21NkRDjsELeo
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIc8nxAAoJEKVg1VMiehFYtH4QAIIhB+MGG2hkaRlVShdTCsXD
u7jQlGkynJ++Yp+gDvfKkPQWEMYtGfTaaib7uy39OBRoHgTXXYN7MFBZZN6aaOlV
Ux0X0Y9ZZ05xnqPokxAFnFgv4h+YE8gdp3Yz6YrSQ9vtYCLfMPTQHvk3qBabhujN
TJSqDtXro2UwyQwMhfUVQIT3a1/cI3xf6dV496C2Xgry36QdNkAuYp3GQho6nFlW
P4xI7a/ke7+TRVHp3IAEpzqrUUTyzKh7facWh1T0+CM7rViB0lBFr5Dy02eYuHQt
eHxaY7SThu+Ly4CsZWM0+tMEE/W5NzGwLoRqVnbbMkMkNMgzdcjMfzM6XB4o4W1/
HgPMyYQTkn6sM9KKDvDmy1odUWegeQ5+1oa3OUmWe4P5xSlfyJlE82jENnflblsL
VZZPe6Z5tCMMMRE7JlpyPxcRBRGUKn6XA+0WDa1jyGZMVd+tgqKY1TGZwwJNQt1J
KnzTwBcbDO9HD9C8iIf3WjDxAiuU9o6i5f6tRnttt0MVfomfg+iDQu5TDeuDfcai
pRjzKCXRJmyT8hb/+0rAE9HxTPGaFJQuvFI9W/dSY1yI3ASM99j/l24dNIHtYJIu
1r3FrPJO+bRoFDEi1a2dSB01ZNNts5g7rS4Y4H14Z+xkl327aWJu3yxKSZgPJfUx
DyuBH+RcRRnW8HjvO+oV
=uoo/
-----END PGP SIGNATURE-----

--=-FwEQVwrH21NkRDjsELeo--

