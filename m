Return-Path: <linux-kernel-owner+w=401wt.eu-S935637AbXEVWOm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935637AbXEVWOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 18:14:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S935486AbXEVWOc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 18:14:32 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41921 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935496AbXEVWOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 18:14:31 -0400
X-Sasl-enc: GnyyPWn9Jlhx6faMJnbBcHEBtdLHiVRSUKe7k3ejsZ+V 1179872069
Message-ID: <46536C0F.50101@imap.cc>
Date: Wed, 23 May 2007 00:17:51 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0AECE937E8B4A8F6F9D96F39"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0AECE937E8B4A8F6F9D96F39
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 15.05.2007 10:43 schrieb Jan Engelhardt:
> On May 15 2007 01:00, Tilman Schmidt wrote:
>> Am 14.05.2007 22:00 schrieb Jan Engelhardt:
>>> On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>>>>> after searching the mailing list and searching the web, I still don=
't
>>>>> know how to access correctly the serial port (in user space known a=
s
>>>>> /dev/ttyS01)
>>> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad
>> That's not nice, sending a newbie on a wild goose chase like that.
>> He doesn't want to write to a file from kernel after all. Reading
>> FAQs is never bad, of course, but reading that particular one
>> won't help him at all with this questions.
>=20
> The original poster is quite unclear about how he wants to access the
> serial port. [...]
> Unfortunately, my magic sphere is out of order, so I could only take
> a really really vague guess at what was wanted.

He asked about "the correct way". The document you cited will just
warn him against one of the many incorrect ones. That's less helpful
than not answering at all.

>>> inb/inw/inl, printk, outb/outw/outl.
>> This is even less nice. You're sending him down the road of
>> directly programming UART registers, knowing full well (I hope)
>> that this a Bad Thing.
>=20
> This is how 8250.c works.

Exactly. Which is one reason why other parts of the kernel should not
do it themselves. (Another being of course that if you do it that way,
your code will only work with that particular type of serial port
hardware. As the last of the Ten Commandments for C Programmers has
been declaring for ages, you shouldn't assume that "All the world's a
VAX^WPC.")

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0AECE937E8B4A8F6F9D96F39
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGU2wPMdB4Whm86/kRAsRoAJ9b8Ow2311Gj2ZlgOsn+k3tV/i5XACePny6
ZuCevBfwcyJFUWDOG2nkVPE=
=EdZA
-----END PGP SIGNATURE-----

--------------enig0AECE937E8B4A8F6F9D96F39--
