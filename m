Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXBEM35@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXBEM35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Feb 2007 07:29:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932252AbXBEM35
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Feb 2007 07:29:57 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2179 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXBEM34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Feb 2007 07:29:56 -0500
Message-ID: <45C72320.5040103@imap.cc>
Date: Mon, 05 Feb 2007 13:29:20 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       i4ldeveloper@listserv.isdn4linux.de, linux-serial@vger.kernel.org,
       Hansjoerg Lipp <hjlipp@web.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <greg@kroah.com>
Subject: Re: [PATCH] drivers/isdn/gigaset: new M101 driver
References: <200702012112.l11LCOO4016557@lx1.pxnet.com>	<20070201171345.bd98ce30.akpm@osdl.org>	<45C537B9.7080704@imap.cc>	<20070203175623.72a171a1.akpm@linux-foundation.org>	<45C68B71.6050904@imap.cc> <20070204205817.fe686375.akpm@linux-foundation.org>
In-Reply-To: <20070204205817.fe686375.akpm@linux-foundation.org>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig6A38BC97443378A3A1D59C52"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig6A38BC97443378A3A1D59C52
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Andrew Morton schrieb:
> On Mon, 05 Feb 2007 02:42:09 +0100 Tilman Schmidt <tilman@imap.cc> wrot=
e:
>=20
>> It's a pointer. Are reads and writes of pointer sized objects
>> guaranteed to be atomic on every platform?
>=20
> Yup - we make the same assumption about longs in various places.
>=20
> It's a bit strange to read a pointer which can be changing at the
> same time.  Because the local copy will no longer represent the
> thing which it was just copied from.

It's not that bad. The only possible concurrent change is from NULL
to non-NULL. Fearing an inconsistent read in that event was too
paranoid apparently.

Thanks for all your suggestions. I'll prepare a new patch based on
them.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig6A38BC97443378A3A1D59C52
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFxyMgMdB4Whm86/kRAutZAJwNdjq4FUdrj0WjC+kqi2aAPOR9tACfaB72
3eHKbphVJCQ2Li7aq0H+uaY=
=3QQR
-----END PGP SIGNATURE-----

--------------enig6A38BC97443378A3A1D59C52--
