Return-Path: <linux-kernel-owner+w=401wt.eu-S1761053AbXENW5Q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761053AbXENW5Q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 18:57:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755222AbXENW47
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 18:56:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53698 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760751AbXENW46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 18:56:58 -0400
X-Sasl-enc: CRAwSXzlEkZ7FiO9xfqiBaHWR6c5bM3NWp7rW2rnSurA 1179183417
Message-ID: <4648E9F7.5090908@imap.cc>
Date: Tue, 15 May 2007 01:00:07 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
CC: "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>
In-Reply-To: <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEA23CCC52F6419F2AF0EDF91"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEA23CCC52F6419F2AF0EDF91
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 14.05.2007 22:00 schrieb Jan Engelhardt:
> On May 14 2007 19:40, Lars K.W. Gohlke wrote:
>>>
>>> after searching the mailing list and searching the web, I still don't=

>>> know how to access correctly the serial port (in user space known as
>>> /dev/ttyS01)
>=20
> http://kernelnewbies.org/FAQ/WhyWritingFilesFromKernelIsBad

That's not nice, sending a newbie on a wild goose chase like that.
He doesn't want to write to a file from kernel after all. Reading
FAQs is never bad, of course, but reading that particular one
won't help him at all with this questions.

Lars: Read that at your leisure if you have time. It is quite
educating, though completely irrelevant to your questions.

>>> would somebody be so kind to give me an example:
>>>
>>> with this behaviour:
>>>
>>> 1. read from port
>>> 2. output via printk()
>>> 3. write to port
>=20
> inb/inw/inl, printk, outb/outw/outl.

This is even less nice. You're sending him down the road of
directly programming UART registers, knowing full well (I hope)
that this a Bad Thing. What will you tell him when he comes back
covered in bruises?

Lars: Ignore this advice. You don't want to use in[bwl]/out[bwl]
to directly access serial port hardware for which the kernel has
a working driver already. That way lies pain, as I know from
experience. Read up on the line discipline interface instead, as
described in my previous reply.

HTH
T.

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigEA23CCC52F6419F2AF0EDF91
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSOn3MdB4Whm86/kRAuPfAJ47kfEQK2s4RzRAiCzYc955xl8fkwCeND8x
wH0B4kziik3B7kcz+S6iJhA=
=yyTy
-----END PGP SIGNATURE-----

--------------enigEA23CCC52F6419F2AF0EDF91--
