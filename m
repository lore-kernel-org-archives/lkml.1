Return-Path: <linux-kernel-owner+w=401wt.eu-S1755556AbZJGWgO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755556AbZJGWgO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 18:36:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755372AbZJGWgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 18:36:13 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:55946 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754697AbZJGWgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 18:36:12 -0400
Subject: Re: linux-next: Tree for October 7 (libertas build failure)
From: Johannes Berg <johannes@sipsolutions.net>
To: Dan Williams <dcbw@redhat.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
       Stephen Rothwell <sfr@canb.auug.org.au>, linux-wireless@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       libertas-dev@lists.infradead.org,
       Holger Schurig <hs4233@mail.mn-solutions.de>
In-Reply-To: <1254939120.16001.45.camel@localhost.localdomain>
References: <20091007173517.abfcfa2a.sfr@canb.auug.org.au>
	 <20091007105210.409a1991.randy.dunlap@oracle.com>
	 <1254939120.16001.45.camel@localhost.localdomain>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-JuxiytzgcjjyFdQt2Mmq"
Date: Thu, 08 Oct 2009 00:34:55 +0200
Message-Id: <1254954895.3713.8.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-JuxiytzgcjjyFdQt2Mmq
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 11:12 -0700, Dan Williams wrote:

> > drivers/built-in.o: In function `lbs_cfg_free':
> > (.text+0x3479e0): undefined reference to `wiphy_unregister'
> > drivers/built-in.o: In function `lbs_cfg_free':
> > (.text+0x3479e7): undefined reference to `wiphy_free'
> > drivers/built-in.o: In function `lbs_cfg_register':
> > (.text+0x347a52): undefined reference to `wiphy_register'
> > drivers/built-in.o: In function `lbs_cfg_alloc':
> > (.text+0x347acf): undefined reference to `wiphy_new'
>=20
> Holger, perhaps we need some Kconfig updates to select cfg80211?

Depend on, please -- cfg80211 has dependencies that would otherwise be
messed up.

johannes

--=-JuxiytzgcjjyFdQt2Mmq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzReIAAoJEODzc/N7+QmaCgAP/1y+IhIC2lLiqthiOSO23gNf
ecUTj1Gxs1AXltLj1azkul7WvhLcBuH0O2Y0NdgQrwBJO0tQqOiG4fySvvA71AzT
a7Hx/NN6cV3qKCj7Iyx6FFHIj/Sm5d8xRoySm4vAmrkemj0Pk5Dz5YVFZHIGvizp
uU/QRph4Do7R51XR22ePB8NxxfM3LDh9oNLjxkEQ9khJg4PpCRS5c99VLuwKaeOZ
MQ6fD0yTT+5iAbHonRIGiBdlVCF/5Mbs+cDwJwWU0nJsMy4RHKaHH7x/UvHuorjH
ygS8gHWaiYbIvJCyO+BdHwqHRRB8RTx5ys7NyjJEgb7SlfEg6wrU18q2pkIjmZ9Z
/R1LX/zqKjX/42GFOAw9SkW1njm7NfwjLfkzOGp4CB7UnMpMZQc/ZUYBlGl6udQ8
NULaMR5hBXOZhRF5iwTB8qmT50Xi2QaNjSc8bAcIysAy3I50cP/7K6ttBxzTRzJW
oMtAE9RkZR1x/i0wJCviABjWeU0tmAdYaFI7YQgduw3x3vG63nDiU511rg866YIL
DDdo4kt21AIqKsydTmeVUWUyOpl4JxY1uLuy+HTNi4oMaiZIBGeeExjf1Xxo9Kyg
z8aMKUBcQcChhcmth/yiBDeZhGsEl2IkSClXOhJHzJHCTAF2GRfMbCld2zBTaqtD
dJ+/KT3GwnWY0YxFFuZk
=CkZN
-----END PGP SIGNATURE-----

--=-JuxiytzgcjjyFdQt2Mmq--

