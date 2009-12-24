Return-Path: <linux-kernel-owner+w=401wt.eu-S1756867AbZLXABS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867AbZLXABS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Dec 2009 19:01:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752247AbZLXABQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Dec 2009 19:01:16 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:36998 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063AbZLXABQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Dec 2009 19:01:16 -0500
Date: Thu, 24 Dec 2009 11:01:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Oliver Neukum <oliver@neukum.org>
Subject: linux-next: usb tree build warning
Message-Id: <20091224110109.37ac11c9.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0beta3 (GTK+ 2.18.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__24_Dec_2009_11_01_09_+1100_/KF=fWE8TwzZX6S6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Dec_2009_11_01_09_+1100_/KF=fWE8TwzZX6S6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next build (x86_64 allmodconfig) produced this warning:

drivers/usb/core/sysfs.c: In function 'set_reset_quirk':
drivers/usb/core/sysfs.c:201: warning: unused variable 'value'

Introduced by commit 9bc2b949ea002c26fafa8c8aa82595ff56075d4f ("USB:
Export USB_QUIRK_RESET_MORPHS through sysfs").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Dec_2009_11_01_09_+1100_/KF=fWE8TwzZX6S6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAksyr0UACgkQjjKRsyhoI8x1KwCff+CDPu0rix2D2j1avoTch/x4
+q0An1VT0oMFaRObYx4PZV6V0YB0TiH0
=9M8u
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Dec_2009_11_01_09_+1100_/KF=fWE8TwzZX6S6--
