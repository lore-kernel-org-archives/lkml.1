Return-Path: <linux-kernel-owner+w=401wt.eu-S1756436AbYG2Gq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436AbYG2Gq3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2008 02:46:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751471AbYG2GqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Jul 2008 02:46:21 -0400
Received: from xc.sipsolutions.net ([83.246.72.84]:56951 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728AbYG2GqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2008 02:46:20 -0400
Subject: Re: [PATCH] bcm5974-0.58: name changes, open/close and
	suspend/resume serialized
From: Johannes Berg <johannes@sipsolutions.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, robfitz@273k.net, akpm@osdl.org,
       jikos@jikos.cz, vojtech@suse.cz, dmonakhov@openvz.org
In-Reply-To: <20080729054132.GA5345@anvil.corenet.prv> (sfid-20080729_074139_861345_F4154FB2)
References: <4888311E.9010005@euromail.se>
	 <20080725154250.GA1861@anvil.corenet.prv> <488A1A99.2070609@euromail.se>
	 <20080725143015.ZZRA012@mailhub.coreip.homeip.net>
	 <488AD712.1020102@euromail.se>  <20080729054132.GA5345@anvil.corenet.prv>
	 (sfid-20080729_074139_861345_F4154FB2)
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-YVHjpPkc4dgmKK4pyMrO"
Date: Tue, 29 Jul 2008 08:46:13 +0200
Message-Id: <1217313973.15381.9.camel@johannes.berg>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YVHjpPkc4dgmKK4pyMrO
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2008-07-29 at 01:41 -0400, Dmitry Torokhov wrote:

> > one thing about the drivers/input/mouse/Kconfig patch:
> >=20
> > The original version contained "select USB", which was later changed
> > to "depends on USB" by Andrew Morton. I saw it reappear as "select USB"
> > in your latest patch, and simply considered it a change back, but
> > maybe it was an oversight?
> >=20
>=20
> I am of the opinion that it is OK to "select" high-level subsystems that
> don't have additional dependencies, especially if they are "past" the
> original driver in menuconfig. I don't really like the idea of forcing
> users revisiting earlier sub-menus after they selected a new subsystem
> to see if there are any new options. Plus, if user wants driver for his
> touchpad he does not really care whether it is PS/2 or USB, [s]he just
> wants it to work.

USB tends to have implicit dependencies like the ehci/ohci/uhci
controller though, so it's not going to work like that anyway starting
from a minimal config, and all defconfigs probably have USB anyway.

Therefore, I personally would keep it as "depends on" rather than
"select". YMMV.

johannes

--=-YVHjpPkc4dgmKK4pyMrO
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Johannes Berg (powerbook)

iQIcBAABAgAGBQJIjryyAAoJEKVg1VMiehFYR9kQAJOEnL5JHJVEmzp/o9l//26f
P+3Q9OiuezchkYuLz8ILglFVNLy5U9cHZYbtDB59Bdh4cuf8k6nwLtGBPGEBQTIe
+/eb/Udw0WfbZZ1ty2l1cPR1l7YloX+ztKAPE4Cuv4ayIXTk7WRrGtz23CEfKJpB
aiqe86oxMkjYcHB5AJ/Uiu5g9MT1+4S4GaffPaLTVHgEFGEC+wL22PDm5/VXw4aP
+Ss0RJaSQhyN8ZzT9HRsD8I6EB8Kbc58I566J/7ZwFfQycRSVY2+KCQIDyzsMQ5l
T+gkOsbS1Kzf687T/+KTBtMm9aKnmt5VFJDpwwKNHoOFssjvGqQBNBBMitpdznQv
7pJh5m8diyMYIoVLKM6yQ3c73mLLf8hQDHUJ1OqwOp9naY2fJ0xnSojgRfwfylrw
l9tIJ8/EmvKiORt6LuoasL6YCmDrktwfb5pdqAhtsMBzZIlc0x/LeCuWthpnV9Ll
e30NXbpOcgZsjPSz8GADKTYv0t0ocoiEWbkLjm710Jucg3D+HFoa2s+3I2GZAmPK
Y4lM3ckZ4k/GgSw2NtZok1s5B1wefPl6Ihq+Pnqu+oNclXo48ZwFcFN2Rm2Hquh4
2tTa0PMOBOBMv9xeRhXrUcUfaElzg3FsaFu1WUyy1DGBjNSFW721IvtPKuqXVyd0
Kfb7WdNZKNRk5tDLSFry
=77XC
-----END PGP SIGNATURE-----

--=-YVHjpPkc4dgmKK4pyMrO--

