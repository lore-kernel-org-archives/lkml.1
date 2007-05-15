Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbXEOKoR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbXEOKoR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 06:44:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXEOKoF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 06:44:05 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:3463 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754268AbXEOKoE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 06:44:04 -0400
Message-ID: <46498EE3.8010907@imap.cc>
Date: Tue, 15 May 2007 12:43:47 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Satyam Sharma <satyam.sharma@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       LKML <linux-kernel@vger.kernel.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Linux 2.6.22-rc1
References: <alpine.LFD.0.98.0705121857100.6739@woody.linux-foundation.org>	 <4647569D.7010709@imap.cc>	 <Pine.LNX.4.61.0705141918180.9570@yvahk01.tjqt.qr>	 <4648A3DF.7040004@imap.cc>	 <Pine.LNX.4.61.0705142227350.9570@yvahk01.tjqt.qr> <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
In-Reply-To: <a781481a0705141934u6b369dd5ob1715f14890af914@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig4844379BE802602F3A23F9B8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig4844379BE802602F3A23F9B8
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Satyam Sharma schrieb:

>>   * Since Jens Axboe's stance ["default y idiocy"] is to have
>>     these menus disabled by default, people should most likely
>>     enable them first before they will be able to enter them.
>=20
> I do agree that anything non-essential (even if it's just a presentatio=
n
> menu that doesn't affect builds) must be default n.

It's tricky for "make oldconfig" when introducing a new "menuconfig"
around some previously existing "config"s, because just accepting
the default for the new option then causes previously selected
ones to be silently dropped. But I don't know a perfect solution
for that. Perhaps we'll just have to live with it. Or perhaps a
warning message along the line of "deselecting option xxx" would
be in order.

> IMHO, the real problem with "default y" menuconfig's, is that they
> cause unpleasant surprises to those folks that use the text-based
> "make oldconfig". They get confronted with choices that they never
> bothered about (or even knew existed) previously, and have no
> idea how to answer them -- same problem faced by Tilman, when
> he used oldconfig.

It's actually the other way around, all those options now tucked
underneath the menuconfig were previously directly visible, so
selecting "y" (either explicitly or by default) makes everything
work as before while "n" very conveniently skips them all.
It's really quite nice if you know how it works. The only thing
that's missing is instructions for those seeing it for the first
time.

> IMHO, those using "oldconfig" are often looking towards doing
> things quickly ... doesn't help them if they have default y menu's
> that they need to "?" upon then to see what they're really about.

Well, yes and no. I am of course trying to get through the new
options as quickly as possible. But if I hit an option I don't
understand then typing "?" is the quickest way to sort it out,
so it's doubly annoying if that yields nothing.

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig4844379BE802602F3A23F9B8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGSY7kMdB4Whm86/kRAg3CAJ4vsVmcxGddt1Qi1ntHGevm+jCwdgCfaTIU
Mr14G9lp9gtUM9IAUVN893w=
=UByS
-----END PGP SIGNATURE-----

--------------enig4844379BE802602F3A23F9B8--
