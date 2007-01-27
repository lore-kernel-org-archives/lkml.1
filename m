Return-Path: <linux-kernel-owner+w=401wt.eu-S932101AbXA0VZG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932101AbXA0VZG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jan 2007 16:25:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932106AbXA0VZG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Jan 2007 16:25:06 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42637 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932101AbXA0VZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jan 2007 16:25:04 -0500
X-Sasl-enc: Dbym5ITdltpcVVpVpR3Ca4ZEWtzkVc+V69vk4wAcfvst 1169933102
Message-ID: <45BBC444.8090109@imap.cc>
Date: Sat, 27 Jan 2007 22:29:40 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@osdl.org>,
       Hansjoerg Lipp <hjlipp@web.de>
Subject: Re: mm snapshot broken-out-2007-01-26-00-36.tar.gz uploaded
References: <200701260837.l0Q8blBr011622@shell0.pdx.osdl.net> <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
In-Reply-To: <6bffcb0e0701270837i1ec40560l6e61e8876177e9da@mail.gmail.com>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig32957911300B03F24DB735F5"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig32957911300B03F24DB735F5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: quoted-printable

Am 27.01.2007 17:37 schrieb Michal Piotrowski:
> On 26/01/07, akpm@osdl.org <akpm@osdl.org> wrote:
>> The mm snapshot broken-out-2007-01-26-00-36.tar.gz has been uploaded t=
o
>>
>>    ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/mm/broken-out-200=
7-01-26-00-36.tar.gz
>>
>=20
> It's probably not mm snapshot related. This driver is just broken.

It probably *is* mm snapshot related. This driver compiles and works
just fine in 2.6.19.2, 2.6.20-rc6 and 2.6.20-rc4-mm1.

> drivers/isdn/gigaset/bas-gigaset.c: In function 'dump_urb':
> drivers/isdn/gigaset/bas-gigaset.c:258: error: 'struct urb' has no
> member named 'bandwidth'

In current stable and mm releases, 'struct urb' *does* have a member
named 'bandwidth'. If some mm patch removes that member then it is
the responsibility of that patch to adapt all users of that structure
accordingly.

HTH
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig32957911300B03F24DB735F5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD4DBQFFu8RMMdB4Whm86/kRAl9aAJigZPCq782hI048NJYpXPCoM6tFAJ9o6iGY
uUO/OEZOa+wNAX0pz1GTZA==
=DCzV
-----END PGP SIGNATURE-----

--------------enig32957911300B03F24DB735F5--
