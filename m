Return-Path: <linux-kernel-owner+w=401wt.eu-S1754797AbXKYEZb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797AbXKYEZb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2007 23:25:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752870AbXKYEZW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 Nov 2007 23:25:22 -0500
Received: from romulus.commandcorp.com ([130.205.32.3]:49981 "EHLO
	romulus.wittsend.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752738AbXKYEZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2007 23:25:20 -0500
X-Greylist: delayed 1248 seconds by postgrey-1.27 at vger.kernel.org; Sat, 24 Nov 2007 23:25:20 EST
Subject: Re: 2.6.24: Serial disabled in BIOS but serial modules still
	loaded (probably PnP related)
From: "Michael H. Warfield" <mhw@WittsEnd.com>
Reply-To: mhw@WittsEnd.com
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: mhw@WittsEnd.com, linux-serial@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
In-Reply-To: <200711242336.43712.arvidjaar@mail.ru>
References: <200711242336.43712.arvidjaar@mail.ru>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-OLvrwGIq5vKAqFhbBq7E"
Organization: Thaumaturgy & Speculums Technology
Date: Sat, 24 Nov 2007 22:55:22 -0500
Message-Id: <1195962922.5044.8.camel@canyon.wittsend.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.10.3 (2.10.3-4.fc7) 
X-Greylist: Sender succeeded SMTP AUTH authentication, not delayed by milter-greylist-3.0 (romulus.wittsend.com [IPv6:2001:4830:3000:2:280:3fff:fe03:455b]); Sat, 24 Nov 2007 23:04:25 -0500 (EST)
X-WittsEnd-MailScanner-Information: Please contact the ISP for more information
X-WittsEnd-MailScanner: Found to be clean
X-WittsEnd-MailScanner-From: mhw@wittsend.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-OLvrwGIq5vKAqFhbBq7E
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, 2007-11-24 at 23:36 +0300, Andrey Borzenkov wrote:
> I have no COM port on notebook (without port replicator which I do not ha=
ve)
> so COM is disabled in BIOS. No ttyS* is detected during boot (and no devi=
ce
> created) but I just noticed that serial modules are still loaded. Well, t=
his
> partially defeats the purpose of disabling COM port - the intention was t=
o
> free resources by *not* loading unneeded modules ...

> This may have something to do with (ACPI) PnP which apparently believes C=
OM is alive.
> Notebook is Toshiba Portege 4000.

	Nice...  What's this then?

> 00:09 PNP0501 16550A-compatible serial port
>     state =3D active
>         io 0x3f8-0x3ff
>         irq 5

	0x3f8-0x3ff is COM1 and a 16550A is the most common invocation of the
vernerable serial port.  I haven't seen a real 8250 in ages.  the 16550
is an 8250 with larger FIFO's and better rates.

	Now, it's on IRQ5 instead of IRQ4 but that's all allocatable on PCI.
Unless I'm missing something, it looks like you've got a COM port and it
looks like it's active.

	Might be related to an IR port?

> 00:0a SMCf010 SMC Fast Infrared Port
>     state =3D disabled

> 00:0b PNP0401 ECP printer port
>     state =3D disabled

	:

	Mike
--=20
Michael H. Warfield (AI4NB) | (770) 985-6132 |  mhw@WittsEnd.com
   /\/\|=3Dmhw=3D|\/\/          | (678) 463-0932 |  http://www.wittsend.com=
/mhw/
   NIC whois: MHW9          | An optimist believes we live in the best of a=
ll
 PGP Key: 0xDF1DD471        | possible worlds.  A pessimist is sure of it!


--=-OLvrwGIq5vKAqFhbBq7E
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iQCVAwUAR0jyKeHJS0bfHdRxAQK9DgQAl/ScCTRRNfa8T9+FI6as6YQxDC/4S2xW
DtMUXKxjaQS2ccpPCkt0uJyDj/50SkcAfk6rYqo+bXrAnPY1Er/l6d4J2FBjdjRo
NnDpoocxlkRYYTPtFXnlkSyThEshBwVq7c9xeY0dfTKYo7STMzH9VFrjgY8Cmd3Q
0dXaPCYNCws=
=ZmGJ
-----END PGP SIGNATURE-----

--=-OLvrwGIq5vKAqFhbBq7E--

