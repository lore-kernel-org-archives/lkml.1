Return-Path: <linux-kernel-owner+w=401wt.eu-S1756725AbYCTO6t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756725AbYCTO6t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 10:58:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755995AbYCTO6h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 10:58:37 -0400
Received: from crystal.sipsolutions.net ([195.210.38.204]:40552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755094AbYCTO6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 10:58:36 -0400
Subject: Re: [PATCH/RFC] introduce ARCH_CAN_UNALIGNED_ACCESS Kconfig symbol
From: Johannes Berg <johannes@sipsolutions.net>
To: Will Newton <will.newton@gmail.com>
Cc: Daniel Drake <dsd@gentoo.org>,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>
In-Reply-To: <87a5b0800803200739v6d222afck850f221eae1edd70@mail.gmail.com> (sfid-20080320_143913_214765_488C899F)
References: <1206023695.16475.137.camel@johannes.berg>
	 <87a5b0800803200739v6d222afck850f221eae1edd70@mail.gmail.com>
	 (sfid-20080320_143913_214765_488C899F)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-HXUuBJ2INb6D0oeDiMrA"
Date: Thu, 20 Mar 2008 15:58:17 +0100
Message-Id: <1206025097.16475.139.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HXUuBJ2INb6D0oeDiMrA
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


On Thu, 2008-03-20 at 14:39 +0000, Will Newton wrote:
> On Thu, Mar 20, 2008 at 2:34 PM, Johannes Berg
> <johannes@sipsolutions.net> wrote:
>=20
> >  +For some ethernet hardware that cannot DMA to unaligned addresses lik=
e
> >  +4*n+2 or non-ethernet hardware, this can be a problem, and it is then
> >  +required to copy the incoming frame into an aligned buffer. Because t=
his is
> >  +unnecessary on architectures that can do unaligned accesses, the code=
 can be
> >  +made depend on CONFIG_ARCH_CAN_UNALIGNED_ACCESS like so:
> >  +
> >  +#ifdef CONFIG_ARCH_CAN_UNALIGNED_ACCESS
> >  +       skb =3D copy skb
> >  +#else
> >  +       skb =3D original skb
> >  +#endif
>=20
> Is this logic reversed?

Euh, indeed, thanks. Will repost after having more comments.

johannes

--=-HXUuBJ2INb6D0oeDiMrA
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIVAwUAR+J7iKVg1VMiehFYAQJybRAAqGr095wjFY1emELqFL2BspwuyWkX9CKW
Hs3p/z3GdakkP0WvH8x80ZIZZSJg09ijazjOHdiqcOXGsSSIMDlK4S2dHOiswhpM
qa9+MwBxy1wxql9YXHfMUpyesdNzQyNVZ39/PrNyMGnn6oAUNSy/lWLVmhjhTzqE
v9GdpOrKGJuDtGaI6NoEqpMf6/jcDWA0D8CCZDUjtuBgE0HsAnQRRL4uwuT+pMrG
Sc3CIE8gR1M+skJrxE7NOPMoeoBLc7byA4SKVzJ0a3fuIDwCSRAYsx5FIzllSUo3
RsgO87UtmUzCn+JNwEZXL9b0f1PpyFHuVgvZ144iEcxDcQrJ5pRJaghG3g+Gm6ZD
Fjl3F1kRenPqvjwEH8bxu3q1UA+osoXIIi8/HKCoLkVIRJmX3nPkMZgZwKHoBgR5
x0FwEH2hoZZf/pjsJGTGCmJPeg6km+S4Kkt0aCxWUCNntmuot6Dwf844O02M8JqA
knsigj3UDMqGvUUe4BjVTRvg4neLn4AVAxEna9T0AYhj1P0MoKLqTShO/CMeiEjo
PVNT3XVsIEPeMzhUC7bGZiZxgdDpPuUBhZ5Z5k98Lm2aL/WMoehcbF/kr1PZRmfO
6+m6oj3W70tSK+d2fGOQUzWH6JOH+L+bPv3M2umah4Ski6XOrffR0OLE7x1bmd6q
zjqj3AdY7s8=
=aVm4
-----END PGP SIGNATURE-----

--=-HXUuBJ2INb6D0oeDiMrA--

