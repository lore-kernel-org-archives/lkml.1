Return-Path: <linux-kernel-owner+w=401wt.eu-S1752386AbXEXRAc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386AbXEXRAc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 13:00:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751900AbXEXRAG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 13:00:06 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:37374 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751889AbXEXRAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 13:00:04 -0400
X-Sasl-enc: OoZy3JChU1VA6yE/XXKzl/zP8mri5vgUHTMK6D0VTMQE 1180026001
Message-ID: <4655C554.7030000@imap.cc>
Date: Thu, 24 May 2007 19:03:16 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: "Lars K.W. Gohlke" <lkwg82@gmx.de>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de> <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr> <4648E9F7.5090908@imap.cc> <Pine.LNX.4.61.0705151020310.9570@yvahk01.tjqt.qr> <46536C0F.50101@imap.cc> <4655676A.1000102@gmx.de>
In-Reply-To: <4655676A.1000102@gmx.de>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig031C3149AC6CA01B12E76C43"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig031C3149AC6CA01B12E76C43
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 24.05.2007 12:22 schrieb Lars K.W. Gohlke:
> I will summarize the concrete scenario, which will lead to the
> understanding and further solution of deadling with serial driver.
>=20
> [scenario]
>=20
> 	1. in userspace I'm doing: > date > /dev/ttyS0
> 	2. in kernelspace I want to print out this date.
>=20
> [/scenario]

I must admit that now I do not understand anything anymore.
I thought you wanted to receive some data over an RS232 serial
port and process it in your kernel module, but this doesn't
look like that at all.

So what is it you are trying to do?
Do you just want to write something to a file in userspace and
receive it in your kernel module?
Does that userspace file have to be called /dev/ttyS0?
(If so, why?)
Or do you want an actual serial port hardware to be involved?
(If so, how?)

Regards,
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig031C3149AC6CA01B12E76C43
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGVcVcMdB4Whm86/kRAuTvAJ0awXEgs9AWSXxvGhCRf5wzinbAKgCfTUTC
A4rDuWIn7A94URR0Bg7Rp0s=
=KFjT
-----END PGP SIGNATURE-----

--------------enig031C3149AC6CA01B12E76C43--
