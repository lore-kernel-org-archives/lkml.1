Return-Path: <linux-kernel-owner+w=401wt.eu-S1752028AbXEXSin@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbXEXSin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 14:38:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750779AbXEXSih
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 14:38:37 -0400
Received: from mx.laposte.net ([81.255.54.16]:3483 "EHLO mx.laposte.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776AbXEXSig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 14:38:36 -0400
Subject: [BUG] USB input death then system freeze
From: Nicolas Mailhot <nicolas.mailhot@laposte.net>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-usb-devel@lists.sourceforge.net
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-e24GXo7uvUDSft9Y3kTr"
Organization: Adresse perso
Date: Thu, 24 May 2007 20:38:23 +0200
Message-Id: <1180031903.4309.6.camel@rousalka.dyndns.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.11.2 (2.11.2-1.fc8) 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--=-e24GXo7uvUDSft9Y3kTr
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Most recent kernel where this bug did *NOT* occur: pre 2.6.21 mm
kernels, non-mm 2.6.22-rc2
Distribution: Fedora Devel
Hardware Environment: EHCI input on external powered hub with CK804 mainboa=
rd
Software Environment: Nothing specific
Problem Description:

After a few hours of activity 2.6.22-rc1-mm1 and 2.6.22-rc2-mm1 will lose U=
SB
HID INPUT (keyboard or mice with no priority), then the system will freeze

If the mouse/tackball is lost first switching to the console and moving the=
 ball
will output random text. Restarting gpm will rescue the mouse (but the syst=
em
will lock up soon after anyway)

Same system with similar config works fine with mainline or older mm kernel=
s

Last trace capture in logs before lockup:

Kernel:
drivers/hid/usbhid/hid-core.c: input irq status -75 received

Xorg:
ProcXCloseDevice to close or not ?
ProcXCloseDevice to close or not ?
(II) nek4k-enhanced-usb-0000:00:02.1-8.1/input1: Off
(II) track-expl-usb-0000:00:02.1-8.3/input0: Off


Steps to reproduce:
Just run the system for some time

More info there (logs, configs, etc)
http://bugzilla.kernel.org/show_bug.cgi?id=3D8535

--=20
Nicolas Mailhot

--=-e24GXo7uvUDSft9Y3kTr
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Ceci est une partie de message
	=?ISO-8859-1?Q?num=E9riquement?= =?ISO-8859-1?Q?_sign=E9e?=

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iEYEABECAAYFAkZV258ACgkQI2bVKDsp8g16PgCg1iuB8NJzOsqXnosqPqYOg2eU
pfQAoPljOG7/H/ksXW6zVAig3DpcxXdO
=VJ0T
-----END PGP SIGNATURE-----

--=-e24GXo7uvUDSft9Y3kTr--
