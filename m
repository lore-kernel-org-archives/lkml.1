Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbXBJXvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbXBJXvU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 18:51:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752156AbXBJXvU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 18:51:20 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:50690 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752150AbXBJXvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 18:51:19 -0500
X-Sasl-enc: LqB5vJPjtYJO+xtaIVOk5IwkTbJuNSUz0RibsjkrAPJg 1171151477
Message-ID: <45CE5AAE.7000708@imap.cc>
Date: Sun, 11 Feb 2007 00:52:14 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Jeff Garzik <jeff@garzik.org>, nigel@nigel.suspend2.net,
       Arjan van de Ven <arjan@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <1171059968.1484.90.camel@nigel.suspend2.net> <45CD10FE.3050506@garzik.org> <20070210064319.GJ24090@1wt.eu>
In-Reply-To: <20070210064319.GJ24090@1wt.eu>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB438F8C0806BD9EEBF8C14A1"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB438F8C0806BD9EEBF8C14A1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 10.02.2007 07:43 schrieb Willy Tarreau:
> On Fri, Feb 09, 2007 at 07:25:34PM -0500, Jeff Garzik wrote:

>>>> On Sat, 2007-02-10 at 08:57 +1100, Nigel Cunningham wrote:
>>>>> Can we start to NAK new drivers that don't have proper power manage=
ment
>>>>> implemented?
[...]
>> Certainly we should ask for it, but it shouldn't be a merge-stopper.
>=20
> I think we should even proceed in the opposite direction : refuse to su=
spend
> if at least one driver does not support the feature, and enumerate the
> faulty drivers on the console. While I agree that a machine which resum=
es
> in a bad state is not funny at all to debug, at least when the user exp=
ects
> his notebook to suspend and sees that it refuses, he can complain about=
 the
> drivers which do not support it, and can even unload them first if unne=
eded.

I agree wholeheartedly. That's the correct way to handle this.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enigB438F8C0806BD9EEBF8C14A1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFzlquMdB4Whm86/kRAtItAJ94O66c4VvXdoizdpIpuPJTlTOUFwCcDfR6
wqwUjankBsB+jev9ZCKvwhw=
=KYoj
-----END PGP SIGNATURE-----

--------------enigB438F8C0806BD9EEBF8C14A1--
