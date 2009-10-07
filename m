Return-Path: <linux-kernel-owner+w=401wt.eu-S1756251AbZJGXPb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251AbZJGXPb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:15:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756178AbZJGXPa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:15:30 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56059 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755942AbZJGXP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:15:29 -0400
Subject: Re: [PATCH] wireless: make WEXT_SPY and WEXT_PRIV select WEXT_CORE
From: Johannes Berg <johannes@sipsolutions.net>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
       linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4ACD1C3D.3030506@oracle.com>
References: <20091007105720.a2457e5b.randy.dunlap@oracle.com>
	 <1254949672-24022-1-git-send-email-linville@tuxdriver.com>
	 <4ACD0E5A.7060106@oracle.com> <1254954842.3713.7.camel@johannes.local>
	 <4ACD1C3D.3030506@oracle.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-i8HOQPuHxf1j810yA2nB"
Date: Thu, 08 Oct 2009 01:14:16 +0200
Message-Id: <1254957256.3713.10.camel@johannes.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-i8HOQPuHxf1j810yA2nB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2009-10-07 at 15:54 -0700, Randy Dunlap wrote:

> > But they also select WIRELESS_EXT, which should cause WEXT_CORE to be
> > turned on. Is it possible that is failing?
>=20
> # CONFIG_WIRELESS is not set
> CONFIG_WIRELESS_EXT=3Dy
> CONFIG_WEXT_SPY=3Dy
> CONFIG_WEXT_PRIV=3Dy
>=20
> WEXT_CORE is not enabled.  I haven't found the culprit, but I suspect "se=
lect".

Interesting.

> but what in WIRELESS_EXT would also cause WEXT_CORE to be enabled?

Well, the way WEXT_CORE is defined as def_bool y ought to, no?

johannes

--=-i8HOQPuHxf1j810yA2nB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIcBAABAgAGBQJKzSDEAAoJEODzc/N7+QmaM+kQAIgIGAE4zkKCsckaF4tY7/DA
iXsK8Jk1GS0nBrwZJ/hM9ivYkSPORALkSWbWxH1FNuJhZ0abrea/4ZGgmicqPa6Y
HODRn5fSb2wY3IkHs2xxkZa80HqzWUquNWLY2Ko4QAll3M2MSnVS+K99HcHVRaW0
BfLGFWbLOzehObuwW/5s9/NNn3iqqd+oJ9Q+GIh0AcMglxdWfSpgDCazI95qCeiE
oxjCbob/Bmko4qqILTIwSC1lqpo+Fr0pPZlZvCeYYEKtT1BUSYXFUJmEFVvKuNbe
nRHcXiDywe7UJH3R+UH3tNMyIA8BaFy2L/u68ixok0zfCSJIHvGUXgssb8GUHEMG
FMjyEZJC+zqlLVX+GiobRmi0tvrZ8K4vnFWc4sh6dzQAz6TeK5zx35iGipf6oMU/
NNZo0dxoRzVmYOR2PJ44mo7fMJrtAShg/KbmSwiEsigjuNLE5Y6/ehF1hRN4672b
jNSC99YpdUdt9/i+kHQ8Ak6BnEI+A+mZl+VKeq/u84/U6R1fox+g7elWZNnWasrt
+MlctL4MiXmdL8QSiWkJE4y133KKKC2YKQbIqf1uYW88k2hV5oXVRV18qVxdj52r
fTxcx3J/W9vva9kH0YSKIjAHaXhUeRICKXxEsh4ZoocCN1M1RKYz1eTsaWBN/3G7
qRs+G5ya5Sc0bPCvydGD
=sWN5
-----END PGP SIGNATURE-----

--=-i8HOQPuHxf1j810yA2nB--

