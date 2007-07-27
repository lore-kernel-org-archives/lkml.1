Return-Path: <linux-kernel-owner+w=401wt.eu-S936484AbXG0Nqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936484AbXG0Nqf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2007 09:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754147AbXG0Nq1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jul 2007 09:46:27 -0400
Received: from mail.phnxsoft.com ([195.227.45.4]:4598 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754116AbXG0Nq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2007 09:46:26 -0400
Message-ID: <46A9F712.70706@imap.cc>
Date: Fri, 27 Jul 2007 15:45:54 +0200
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.4) Gecko/20070509 SeaMonkey/1.1.2 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Lee Howard <faxguy@howardsilvan.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Robert Hancock <hancockr@shaw.ca>,
       linux-serial@vger.kernel.org, tytso@mit.edu, rmk@arm.linux.org.uk,
       linux-kernel@vger.kernel.org
Subject: Re: serial flow control appears broken
References: <fa.Z6O0xFRT69zes0Mg+agt3Uiwux4@ifi.uio.no>	<46A84B4A.6070902@shaw.ca>	<46A8C6F1.4080309@howardsilvan.com> <20070726173121.70088a92@the-village.bc.nu> <46A98845.8010806@howardsilvan.com>
In-Reply-To: <46A98845.8010806@howardsilvan.com>
X-Enigmail-Version: 0.95.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCDEB0E5FA9C76DAAD1733EFD"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCDEB0E5FA9C76DAAD1733EFD
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Lee Howard schrieb:
>=20
> So, does this explain why I wouldn't have a problem at 115200 bps with =

> kernel 2.2.5 but why I do with 2.6.5 and 2.6.18?  Both hardware and=20
> software flow control work fine with 2.2.5 (meaning I don't see any=20
> error message and I don't have any data corruption), but neither works =

> to avoid the "kernel: ttyS1: 1 input overrun(s)" and consequent data=20
> corruption issue in 2.6.5 nor 2.6.18.
>=20
> Was there some associated application change in tty handling that neede=
d=20
> to occur between the 2.2 and 2.6 kernels to properly implement flow con=
trol?

Could this be related?

http://lkml.org/lkml/2007/7/18/245

Quote:
"I've recently found (using 2.6.21.4) that configuring a serial ports
(ST16654) which use the 8250 driver using setserial results in the
UART's FIFOs being disabled (unless you specify autoconfig)."

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigCDEB0E5FA9C76DAAD1733EFD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGqfcSMdB4Whm86/kRArc3AJ9pJMhthPIf7hfgV2uXBiEeO5oxMACcDHDz
o9M60LvWgfeC3rUtZ+gU46c=
=Z3mc
-----END PGP SIGNATURE-----

--------------enigCDEB0E5FA9C76DAAD1733EFD--
