Return-Path: <linux-kernel-owner+w=401wt.eu-S1754878AbZCCUPi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878AbZCCUPi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Mar 2009 15:15:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752154AbZCCUPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Mar 2009 15:15:31 -0500
Received: from naru.obs2.net ([84.20.150.76]:60152 "EHLO narury.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751788AbZCCUPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Mar 2009 15:15:30 -0500
Date: Tue, 3 Mar 2009 22:15:27 +0200
From: Riku Voipio <riku.voipio@iki.fi>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Update email Address of Riku voipio
Message-ID: <20090303201526.GB1119@kos.to>
References: <20090128091438.GA30378@kos.to> <84144f020901280156l763b7d23o43fe0ea314aae24e@mail.gmail.com> <alpine.LNX.1.10.0901282128030.5377@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0901282128030.5377@jikos.suse.cz>
X-message-flag: Warning: message not sent with a DRM-Certified client
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 28, 2009 at 09:29:42PM +0100, Jiri Kosina wrote:
> On Wed, 28 Jan 2009, Pekka Enberg wrote:
>=20
> > > I have no longer access to the movial.fi mailbox.
> > > Update to use the iki.fi permanent redirector service.
> > > Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
> > Why not remove the email address completely from the source files and
> > add yourself to CREDITS or MAINTAINERS instead?
>=20
> Yes, I think so. IMHO the copyright notice shouldn't have e-mail address=
=20
> associated at all, or have it in a form that has been valid in the time=
=20
> the copyright has been acquired.

Like this?

=46rom da32dfd3eb28aa6ec8318e9782254dd0baa54b23 Mon Sep 17 00:00:00 2001
=46rom: Riku Voipio <riku.voipio@iki.fi>
Date: Tue, 3 Mar 2009 21:37:17 +0200
Subject: [PATCH] Update my email address


Signed-off-by: Riku Voipio <riku.voipio@iki.fi>
---
 CREDITS                     |    6 ++++++
 MAINTAINERS                 |   11 +++++++++++
 drivers/hwmon/f75375s.c     |    4 ++--
 drivers/leds/leds-pca9532.c |    4 ++--
 4 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/CREDITS b/CREDITS
index 5e07367..71807f0 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3571,6 +3571,12 @@ N: Dirk Verworner
 D: Co-author of German book ``Linux-Kernel-Programmierung''
 D: Co-founder of Berlin Linux User Group
=20
+N: Riku Voipio
+E: riku.voipio@iki.fi
+D: Author of PCA9532 LED and Fintek f75375s hwmon driver
+D: Some random ARM board patches
+S: Finland
+
 N: Patrick Volkerding
 E: volkerdi@ftp.cdrom.com
 D: Produced the Slackware distribution, updated the SVGAlib
diff --git a/MAINTAINERS b/MAINTAINERS
index 59fd2d1..0babab2 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1736,6 +1736,12 @@ M:	viro@zeniv.linux.org.uk
 L:	linux-fsdevel@vger.kernel.org
 S:	Maintained
=20
+FINTEK F75375S HARDWARE MONITOR AND FAN CONTROLLER DRIVER
+P:	Riku Voipio
+M:	riku.vipio@iki.fi
+L:	lm-sensors@lm-sensors.org
+S:	Maintained
+
 FIREWIRE SUBSYSTEM (drivers/firewire, <linux/firewire*.h>)
 P:	Kristian Hoegsberg, Stefan Richter
 M:	krh@redhat.com, stefanr@s5r6.in-berlin.de
@@ -3372,6 +3378,11 @@ P:	Jim Cromie
 M:	jim.cromie@gmail.com
 S:	Maintained
=20
+PCA9532 LED DRIVER
+P:	Riku Voipio
+M:	riku.voipio@iki.fi
+S:	Maintained
+
 PCI ERROR RECOVERY
 P:	Linas Vepstas
 M:	linas@austin.ibm.com
diff --git a/drivers/hwmon/f75375s.c b/drivers/hwmon/f75375s.c
index 1692de3..719f95b 100644
--- a/drivers/hwmon/f75375s.c
+++ b/drivers/hwmon/f75375s.c
@@ -1,7 +1,7 @@
 /*
  * f75375s.c - driver for the Fintek F75375/SP and F75373
  *             hardware monitoring features
- * Copyright (C) 2006-2007  Riku Voipio <riku.voipio@movial.fi>
+ * Copyright (C) 2006-2007  Riku Voipio
  *
  * Datasheets available at:
  *
@@ -721,7 +721,7 @@ static void __exit sensors_f75375_exit(void)
 	i2c_del_driver(&f75375_driver);
 }
=20
-MODULE_AUTHOR("Riku Voipio <riku.voipio@movial.fi>");
+MODULE_AUTHOR("Riku Voipio");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("F75373/F75375 hardware monitoring driver");
=20
diff --git a/drivers/leds/leds-pca9532.c b/drivers/leds/leds-pca9532.c
index 76ec749..bd3b431 100644
--- a/drivers/leds/leds-pca9532.c
+++ b/drivers/leds/leds-pca9532.c
@@ -1,7 +1,7 @@
 /*
  * pca9532.c - 16-bit Led dimmer
  *
- * Copyright (C) 2008 Riku Voipio <riku.voipio@movial.fi>
+ * Copyright (C) 2008 Riku Voipio
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -367,7 +367,7 @@ static void __exit pca9532_exit(void)
 	i2c_del_driver(&pca9532_driver);
 }
=20
-MODULE_AUTHOR("Riku Voipio <riku.voipio@movial.fi>");
+MODULE_AUTHOR("Riku Voipio");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("PCA 9532 LED dimmer");
=20
--=20
1.6.1.3

--=20
"rm -rf" only sounds scary if you don't have backups

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iD8DBQFJrY/eibPvMsrqrwMRAoAEAJ97Bu5SBjJupotlINEiW5/poaS35ACdFQc9
oEFNWAyQFHN+ZhSviwF2KNs=
=Jebz
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
