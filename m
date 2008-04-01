Return-Path: <linux-kernel-owner+w=401wt.eu-S1756239AbYDAHr7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbYDAHr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2008 03:47:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752189AbYDAHrw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Apr 2008 03:47:52 -0400
Received: from mail.gmx.net ([213.165.64.20]:35188 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752083AbYDAHrv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2008 03:47:51 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/1UGRUPY31xLUxJf412d8hJeqj8n45Ot1l2p1ICN
	vzB6hgASKo1F0J
From: Toralf =?iso-8859-1?q?F=F6rster?= <toralf.foerster@gmx.de>
To: Christoph Lameter <clameter@sgi.com>
Subject: Re: build issue for v2.6.25-rc7-187-ga9edadb in mm/slub.c
Date: Tue, 1 Apr 2008 09:47:45 +0200
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200803311459.56037.toralf.foerster@gmx.de> <Pine.LNX.4.64.0803311146280.6510@schroedinger.engr.sgi.com>
In-Reply-To: <Pine.LNX.4.64.0803311146280.6510@schroedinger.engr.sgi.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3697473.YmMkPp5UMa";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <200804010947.48205.toralf.foerster@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3697473.YmMkPp5UMa
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

At Monday 31 March 2008 20:47:32 Christoph Lameter wrote :
> Does this fix things?
>=20
>=20
Yes :-)

> Subject: Fix undefined count_partial of !CONFIG_SLABINFO
>=20
> Typo in the check if we need the count_partial function that was=20
> introduced by 53625b4204753b904addd40ca96d9ba802e6977d
>=20
> Signed-off-by: Christoph Lameter <clameter@sgi.com>
>=20
> ---
>  mm/slub.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> Index: linux-2.6/mm/slub.c
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> --- linux-2.6.orig/mm/slub.c	2008-03-31 11:29:28.000000000 -0700
> +++ linux-2.6/mm/slub.c	2008-03-31 11:32:23.000000000 -0700
> @@ -2688,7 +2688,7 @@ void kfree(const void *x)
>  }
>  EXPORT_SYMBOL(kfree);
> =20
> -#if defined(SLUB_DEBUG) || defined(CONFIG_SLABINFO)
> +#if defined(CONFIG_SLUB_DEBUG) || defined(CONFIG_SLABINFO)
>  static unsigned long count_partial(struct kmem_cache_node *n)
>  {
>  	unsigned long flags;
>=20



=2D-=20
MfG/Sincerely

Toralf F=F6rster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

--nextPart3697473.YmMkPp5UMa
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBH8eikhyrlCH22naMRAspYAJ0dEAQDWZEMVJv2X0paarhohoufkwCaAiBo
/CRpffrREIs/pdlOFPSKtLQ=
=95rG
-----END PGP SIGNATURE-----

--nextPart3697473.YmMkPp5UMa--
