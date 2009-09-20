Return-Path: <linux-kernel-owner+w=401wt.eu-S1754714AbZITQv1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754714AbZITQv1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Sep 2009 12:51:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754637AbZITQvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Sep 2009 12:51:25 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59174 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754618AbZITQvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Sep 2009 12:51:24 -0400
X-Sasl-enc: pqFMGSSoQCYhWkv1spk9S0nVIQ9TupadM/N0tmg+kdo4 1253465487
Message-ID: <4AB65D83.1080506@imap.cc>
Date: Sun, 20 Sep 2009 18:51:15 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Arjan van de Ven <arjan@infradead.org>
CC: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Status of Bug 8094 -  ipaq oops on connecting "Vodafone VPA-II"
 ?
References: <4AB630AD.90207@imap.cc>	<20090920150549.GC11621@kroah.com>	<4AB6581F.5040908@imap.cc> <20090920183744.395fc407@infradead.org>
In-Reply-To: <20090920183744.395fc407@infradead.org>
X-Enigmail-Version: 0.95.7
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB2198F2D6C3F250101901FB2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB2198F2D6C3F250101901FB2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Arjan van de Ven schrieb:
> On Sun, 20 Sep 2009 18:28:15 +0200
> Tilman Schmidt <tilman@imap.cc> wrote:
>=20
>> Greg KH schrieb:
>>> Can you provide a log message that shows the problem you are having
>>> with the 2.6.31 kernel?
>> Attached. Currently only from an Nvidia-tainted kernel, though.
>> If you need it reproduced on an untainted kernel it'll have to
>> wait until I can reboot the machine.
>>
>> The Oops location according to gdb is:
>>
>> (gdb) info line *ipaq_open+0x1cf
>> Line 656 of "drivers/usb/serial/ipaq.c" starts at address 0x986
>> <ipaq_open+457> and ends at 0x98f <ipaq_open+466>.
>>
>=20
> btw this is what scripts/markup_oops.pl is for... it gives a very nice
> diagnostic

Unfortunately that script doesn't work on my machine:

ts@xenon:~/kernel/linux-2.6.31-work> ./scripts/markup_oops.pl < /tmp/mdab=
ug.txt=20
No vmlinux specified, assuming /lib/modules/2.6.31-vanilla/build/vmlinux
Can't locate object method "from_hex" via package "Math::BigInt" at ./scr=
ipts/markup_oops.pl line 176, <STDIN> line 98.

And as it's openSUSE based I can't simply update my Perl packages
from CPAN. But I can live with the gdb method.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigB2198F2D6C3F250101901FB2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.4-svn0 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org

iD8DBQFKtl2MQ3+did9BuFsRAguvAKCO1OMnkxRT5DnhO+HKgwb+soEehgCeOZbM
sKEU25rVZIEYsgJL7BkdfRg=
=tqhB
-----END PGP SIGNATURE-----

--------------enigB2198F2D6C3F250101901FB2--
