Return-Path: <linux-kernel-owner+w=401wt.eu-S965360AbXCUWg2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965360AbXCUWg2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2007 18:36:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965381AbXCUWg1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Mar 2007 18:36:27 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:38663 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965360AbXCUWgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2007 18:36:24 -0400
X-Sasl-enc: RCPasyiMMQwgMAf9DMvnbdpAj+2shfY35LZrtMlC42zh 1174516583
Message-ID: <4601B3D0.3060600@imap.cc>
Date: Wed, 21 Mar 2007 23:38:08 +0100
From: Tilman Schmidt <tilman@imap.cc>
Organization: me - organized??
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de-AT; rv:1.8.0.9) Gecko/20061211 SeaMonkey/1.0.7 Mnenhy/0.7.4.666
MIME-Version: 1.0
To: linux list <linux-kernel@vger.kernel.org>
Subject: 2.6.21-rc3-mm2: KDE processes die while system is idle
X-Enigmail-Version: 0.94.2.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig5FD330629C67CAC51A3CA27B"
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig5FD330629C67CAC51A3CA27B
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On a SuSE 10.0 system running kernel 2.6.21-rc3-mm2, it has now
happened for the 4th time that I came back after a couple of hours
to find that all KDE processes of the session I had left running had
died. The X server and applications (2x konsole, emacs, ksysguard)
were still running, but the K menu, dashboard and window decorations
had vanished, and window manager functionality was unavailable.
Running ps from an ssh connection confirmed that of the processes
that should normally be running, kdeinit and all processes labelled
"[kdeinit]" were missing.

No non-X processes are affected. The syslog contains no hint of
anything wrong. If I kill the X server with alt/ctrl/Bksp and log
in to a new KDE session, all is well again.

This has never happened with mainline or previous -mm kernels, so
I'm led to believe that it is tied to some change in 2.6.21-rc3-mm2.

Unfortunately the effect is not easily reproduced. So far it only
happened when I left the machine running logged in but idle,
sometimes after a few hours, but sometimes not even after two days.
So bisecting appears impractical.

I'll try 2.6.21-rc4-mm1 next.

Ideas?

--=20
Tilman Schmidt                          E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig5FD330629C67CAC51A3CA27B
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3rc1 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFGAbPYMdB4Whm86/kRAmn8AJ9NHFiyccfxOjlc4ZIygVn1rWdPUACeORie
MrROXqSjfsuMP2rzTeRFzOI=
=+/YQ
-----END PGP SIGNATURE-----

--------------enig5FD330629C67CAC51A3CA27B--
