Return-Path: <linux-kernel-owner+w=401wt.eu-S1762779AbXEVVwQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762779AbXEVVwQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2007 17:52:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758650AbXEVVwE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 May 2007 17:52:04 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:40682 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758682AbXEVVwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2007 17:52:03 -0400
X-Sasl-enc: uWbWXhqBKpQirvoMYOWql7FDwN+xdCR+n4ThtnnWlioW 1179870721
Message-ID: <465366CB.7090608@imap.cc>
Date: Tue, 22 May 2007 23:55:23 +0200
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: huang ying <huang.ying.caritas@gmail.com>
CC: Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "Lars K.W. Gohlke" <lkwg82@gmx.de>, linux-kernel@vger.kernel.org
Subject: Re: How to access correctly serial port inside module?
References: <46485D84.1010902@gmx.de> <46489EF1.2020509@gmx.de>	 <Pine.LNX.4.61.0705142158340.9570@yvahk01.tjqt.qr>	 <4648E9F7.5090908@imap.cc> <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com>
In-Reply-To: <851fc09e0705162315w3380ddabh9b9f0b2198cb8457@mail.gmail.com>
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig51DCC89003F433761996DEF8"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig51DCC89003F433761996DEF8
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 17.05.2007 08:15 schrieb huang ying:
> I think the "serio" (through drivers/input/serio/serport.c) may be a
> choice too, like that in linux/drivers/input/mouse/sermouse.c, which
> is an example to program serial port in kernel space.

Interesting. I wonder if that would have been a better choice for
the Gigaset M101 driver. It seems even to have a probe mechanism
so one could try to determine if the expected device is really
connected to the port.

Is there any documentation on this interface? I find the source a
bit hard to understand, sparsely commented as it is.

Thanks
Tilman

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=C3=B6ffnet mindestens haltbar bis: (siehe R=C3=BCckseite)


--------------enig51DCC89003F433761996DEF8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGU2bLMdB4Whm86/kRAqPIAJ0eOmTULgRjW0e6ifSlGKISBKY0pQCfccZv
IlkNXJJa/J8kppcA+SJuloc=
=REP/
-----END PGP SIGNATURE-----

--------------enig51DCC89003F433761996DEF8--
