Return-Path: <linux-kernel-owner+w=401wt.eu-S1751220AbXBQSgE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751220AbXBQSgE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Feb 2007 13:36:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030246AbXBQSgE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 17 Feb 2007 13:36:04 -0500
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:42884 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751220AbXBQSgD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Feb 2007 13:36:03 -0500
X-Sasl-enc: tcdzwCTZWNK7rpbzgDEdametmRv+qUvNJwyl/oggAqAN 1171737390
Message-ID: <45D74B46.3090602@imap.cc>
Date: Sat, 17 Feb 2007 19:36:54 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Hansjoerg Lipp <hjlipp@web.de>, gigaset307x-common@lists.sourceforge.net,
       kkeil@suse.de, kai.germaschewski@gmx.de,
       isdn4linux@listserv.isdn4linux.de, linux-kernel@vger.kernel.org
Subject: Re: Kbuild problem
References: <20070215215638.GI13958@stusta.de> <45D4F80F.8040200@imap.cc> <20070216083339.GK13958@stusta.de> <45D64691.8070901@imap.cc> <20070217105203.GR13958@stusta.de>
In-Reply-To: <20070217105203.GR13958@stusta.de>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig64CB85B673FB18D6CEFF111F"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig64CB85B673FB18D6CEFF111F
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 17.02.2007 11:52 schrieb Adrian Bunk:
> On Sat, Feb 17, 2007 at 01:04:33AM +0100, Tilman Schmidt wrote:
>> [...] I'd prefer a
>> Makefile which builds modular usb_gigaset.ko and/or ser_gigaset.ko
>> like the present one (including asyncdata.o), but when linking
>> usb-gigaset.o and ser-gigaset.o into the kernel includes asyncdata.o
>> only once. Trouble is, I don't know how to express that in Kbuild.
>>
>> Any ideas?
>=20
> CONFIG_GIGASET_M105=3Dy, CONFIG_GIGASET_M101=3Dm and similar problems m=
ight=20
> make this quite tricky.

I am no judge of that. All I know about the possibilities of Kbuild
is what the files in Documentation/kbuild tell me. From browsing
through other kernel Makefiles it would appear that there are more
possibilities though, such as if/then/else constructs.

> Shared functionality simply doesn't belong into any of the affected=20
> modules, but to a different place where all users can access it.

Alright, then so be it. But that raises another question:
asyncdata.o is only needed for M105 and M101, not for the base
driver. How do I express in Kbuild that asyncdata.o is to be added
to gigaset-y only if CONFIG_GIGASET_M105 and CONFIG_GIGASET_M101
are not both 'n'?

Thanks,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig64CB85B673FB18D6CEFF111F
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFF10tPMdB4Whm86/kRAnBBAJ4qQlQqJs1B+cgQ487xUK2V0T1jdQCePld3
nrb5c3GubV0idet78kQcX4U=
=GFP6
-----END PGP SIGNATURE-----

--------------enig64CB85B673FB18D6CEFF111F--
