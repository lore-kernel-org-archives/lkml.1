Return-Path: <linux-kernel-owner+w=401wt.eu-S932579AbXBKWUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579AbXBKWUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Feb 2007 17:20:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932580AbXBKWUS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Feb 2007 17:20:18 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:53864 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932579AbXBKWUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Feb 2007 17:20:16 -0500
X-Sasl-enc: x0s7W5vYlEB8meZkk5e/MnNvfd4li+szzvdQyXE/j9Dp 1171232413
Message-ID: <45CF96D0.8070004@imap.cc>
Date: Sun, 11 Feb 2007 23:21:04 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Arjan van de Ven <arjan@infradead.org>,
       nigel@nigel.suspend2.net, LKML <linux-kernel@vger.kernel.org>
Subject: Re: NAK new drivers without proper power management?
References: <1171058269.1484.64.camel@nigel.suspend2.net> <1171059433.8675.195.camel@laptopd505.fenrus.org> <20070210193851.GA3956@ucw.cz> <200702102320.39531.rjw@sisk.pl> <20070211194202.GC15445@elf.ucw.cz>
In-Reply-To: <20070211194202.GC15445@elf.ucw.cz>
X-Enigmail-Version: 0.94.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0E5C8289FE3636EE9076CE58"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0E5C8289FE3636EE9076CE58
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.02.2007 20:42 schrieb Pavel Machek:
[...]
>> What about this:
>>
>> "If the device requires that, implement .suspend and .resume or at lea=
st
>> define .suspend that will always return -ENOSYS (then people will know=
 they
>> have to unload the driver before the suspend).  Similarly, if you aren=
't sure
>> whether or not the device requires .suspend and .resume, define .suspe=
nd that
>> will always return -ENOSYS."
>=20
> Sounds ok to me. Where should this text go?
> Documentation/SubmittingDrivers ?


Documentation/power/devices.txt?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
- In theory, there is no difference between theory and practice.
  In practice, there is.


--------------enig0E5C8289FE3636EE9076CE58
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFz5bZMdB4Whm86/kRAr/HAJ94UhMAR4hb+WBXu7HpmGqkrWJrhgCfSYGj
CAGEd9ZKAmIG2Vu9VuV80BA=
=ZnRp
-----END PGP SIGNATURE-----

--------------enig0E5C8289FE3636EE9076CE58--
