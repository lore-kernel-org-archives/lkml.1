Return-Path: <linux-kernel-owner+w=401wt.eu-S932770AbYBMLdV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932770AbYBMLdV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 06:33:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755837AbYBMLdM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 06:33:12 -0500
Received: from ip-58-28-152-52.static-xdsl.xnet.co.nz ([58.28.152.52]:43720
	"EHLO sol.unix.geek.nz" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757492AbYBMLdL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 06:33:11 -0500
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Feb 2008 06:33:11 EST
Subject: 2.6.25-rc1 on Sun Ultra 40
From: Jasper Bryant-Greene <jasper@unix.geek.nz>
To: linux-kernel@vger.kernel.org
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-VppLb94RudfZDzZo1zCb"
Date: Thu, 14 Feb 2008 00:25:08 +1300
Message-Id: <1202901908.11100.8.camel@phobos.jasper.bg>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VppLb94RudfZDzZo1zCb
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

I have been attempting to test 2.6.25-rc1 on my Sun Ultra 40 (two
dual-core Opteron 2222 CPUs).

There is some issue with the HPET clocksource which causes it to hang
the boot process if enabled, which I will look into in due course (the
HPET works fine on at least 2.6.19).

More pressing is that the system will not boot at all even with HPET
disabled - kernel gets no further than "NET: Registered protocol family
2".

I cannot think of a way to find out what the problem is, because the
system has only USB ports, and the USB keyboard is not working at this
stage, either because the system has locked up hard, or because the USB
support has not yet loaded (I tried both standard USB-HID and boot
protocol keyboard support, both compiled in). Thus I cannot use
magic-sysrq, or even scrollback to look at boot messages. There is also
no serial port to assist with the latter...

Any thoughts on a procedure for debugging this would be much
appreciated.

-j

--=-VppLb94RudfZDzZo1zCb
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.7 (GNU/Linux)

iD8DBQBHstOUJdSFNCc4WA0RAsLdAKC3+LO0hiDHEALZX04NVHOwOr7x6wCfeO2z
7w9R+3C9JmXXW9SqM69vJDY=
=zpND
-----END PGP SIGNATURE-----

--=-VppLb94RudfZDzZo1zCb--

