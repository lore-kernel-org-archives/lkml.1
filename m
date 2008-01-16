Return-Path: <linux-kernel-owner+w=401wt.eu-S1754340AbYAPM3m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754340AbYAPM3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2008 07:29:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751710AbYAPM3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Jan 2008 07:29:35 -0500
Received: from posthamster.phnxsoft.com ([195.227.45.4]:2869 "EHLO
	posthamster.phnxsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbYAPM3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2008 07:29:34 -0500
Message-ID: <478DF8AB.50400@imap.cc>
Date: Wed, 16 Jan 2008 13:29:31 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; de-AT; rv:1.8.1.11) Gecko/20071128 SeaMonkey/1.1.7 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: assigning a line discipline to a serial device from inside the kernel
X-Enigmail-Version: 0.95.6
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig0EF1E080CD0DC36F74F6B3E4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig0EF1E080CD0DC36F74F6B3E4
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable

The Siemens Gigaset M101 driver (drivers/isdn/gigaset/ser_gigaset.ko)
is implemented as a serial line discipline N_GIGASET_M101, much like
the better-known N_SLIP and N_PPP LDs. It must therefore be "pushed"
onto a serial device in order to be used.

The classic approach is a trivial userspace daemon which opens the
device, sets the LD via ioctl(~,TIOCSETD,~), and must then sleep
indefinitely while keeping the device open, because closing it
would unload the LD.

Is there a clean and acceptable way to avoid this userspace daemon
and push the LD onto the serial device from within the kernel?

Thanks,
Tilman

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig0EF1E080CD0DC36F74F6B3E4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.4 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFHjfirQ3+did9BuFsRAmbGAJ0b+OP7algwKampNoiM1H5yb1Ta4gCfZMLt
FDICYRCa0+PrlfYO6DPs3Ok=
=gVkQ
-----END PGP SIGNATURE-----

--------------enig0EF1E080CD0DC36F74F6B3E4--
