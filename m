Return-Path: <linux-kernel-owner+w=401wt.eu-S1755988AbXENTja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988AbXENTja (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2007 15:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754286AbXENTjX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 May 2007 15:39:23 -0400
Received: from 85.8.24.16.se.wasadata.net ([85.8.24.16]:54113 "EHLO
	smtp.drzeus.cx" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752277AbXENTjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2007 15:39:22 -0400
Message-ID: <4648BAC9.5020405@drzeus.cx>
Date: Mon, 14 May 2007 21:38:49 +0200
From: Pierre Ossman <drzeus-mmc@drzeus.cx>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=_hera.drzeus.cx-25460-1179171560-0001-2"
To: LKML <linux-kernel@vger.kernel.org>
CC: Nicolas FERRE <nicolas.ferre@rfo.atmel.com>,
       Andrew Victor <andrew@sanpeople.com>,
       Ralf Baechle <ralf@linux-mips.org>,
       Manuel Lauss <mano@roarinelk.homelinux.net>,
       Yoichi Yuasa <yoichi_yuasa@tripeaks.co.jp>,
       Pavel Pisa <pisa@cmp.felk.cvut.cz>,
       Sascha Hauer <s.hauer@pengutronix.de>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
       "=?ISO-8859-1?Q?Juha_Yrj=F6l=E4?=" <juha.yrjola@solidboot.com>,
       Carlos Aguiar <carlos.aguiar@indt.org.br>,
       "Briglia >> \"Anderson F. Briglia\"" <anderson.briglia@indt.org.br>,
       Kyungmin Park <kmpark@infradead.org>, "Khasim, Syed" <x0khasim@ti.com>
Subject: [RFC] Orphaning MMC host drivers
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME-formatted message.  If you see this text it means that your
E-mail software does not support MIME-formatted messages.

--=_hera.drzeus.cx-25460-1179171560-0001-2
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit

I've reached the point where I've grown tired of trying to figure out who has
hardware for what. I intend to commit the following in a few days so if you care
about the quality of the drivers it's time to step up to the plate.

There's a rather long list of cc here, but I've included everyone that has been
involved in the drivers in one way or another in case one or two maintainers can
actually be found.

Even if you don't feel like maintaining this, feel free to suggest mailing lists
that should be added to the entries.

Rgds

-- 
     -- Pierre Ossman

  Linux kernel, MMC maintainer        http://www.kernel.org
  PulseAudio, core developer          http://pulseaudio.org
  rdesktop, core developer          http://www.rdesktop.org

--=_hera.drzeus.cx-25460-1179171560-0001-2
Content-Type: text/x-patch; name="maint.patch"; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="maint.patch"

commit 11c3d5e4b871fc69d72f67811d4eb6bfd7084c43
Author: Pierre Ossman <drzeus@drzeus.cx>
Date:   Mon May 14 21:25:26 2007 +0200

    mmc: mark unmaintained drivers
    
    Most of the host controller drivers in the MMC layer lacks an
    official maintainer. Make sure this is mentioned in MAINTAINERS
    in case someone wants to pick up the ball.
    
    Signed-off-by: Pierre Ossman <drzeus@drzeus.cx>

diff --git a/MAINTAINERS b/MAINTAINERS
index 68a56ad..8f1b60c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -346,6 +346,9 @@ P:	Ivan Kokshaysky
 M:	ink@jurassic.park.msu.ru
 S:	Maintained for 2.4; PCI support for 2.6.
 
+AMD AU1XX0 MMC DRIVER
+S:	Orphan
+
 AMD GEODE PROCESSOR/CHIPSET SUPPORT
 P:	Jordan Crouse
 M:	info-linux@geode.amd.com
@@ -418,6 +421,9 @@ P:	Ian Molton
 M:	spyro@f2s.com
 S:	Maintained
 
+ARM PRIMECELL MMCI PL180/1 DRIVER
+S:	Orphan
+
 ARM/ADI ROADRUNNER MACHINE SUPPORT
 P:	Lennert Buytenhek
 M:	kernel@wantstofly.org
@@ -649,6 +655,9 @@ L:	linux-atm-general@lists.sourceforge.net (subscribers-only)
 W:	http://linux-atm.sourceforge.net
 S:	Maintained
 
+ATMEL AT91 MCI DRIVER
+S:	Orphan
+
 ATMEL MACB ETHERNET DRIVER
 P:	Haavard Skinnemoen
 M:	hskinnemoen@atmel.com
@@ -2382,6 +2391,9 @@ M:	stelian@popies.net
 W:	http://popies.net/meye/
 S:	Maintained
 
+MOTOROLA I.MX MMCI DRIVER
+S:	Orphan
+
 MOUSE AND MISC DEVICES [GENERAL]
 P:	Alessandro Rubini
 M:	rubini@ipvvis.unipv.it
@@ -2902,6 +2914,9 @@ M:	nico@cam.org
 L:	linux-arm-kernel@lists.arm.linux.org.uk	(subscribers-only)
 S:	Maintained
 
+PXA MMCI DRIVER
+S:	Orphan
+
 QLOGIC QLA2XXX FC-SCSI DRIVER
 P:	Andrew Vasquez
 M:	linux-driver@qlogic.com
@@ -3417,6 +3432,9 @@ P:      Alex Dubov
 M:      oakad@yahoo.com
 S:      Maintained
 
+TI OMAP MMC INTERFACE DRIVER
+S:	Orphan
+
 TI OMAP RANDOM NUMBER GENERATOR SUPPORT
 P:	Deepak Saxena
 M:	dsaxena@plexity.net

--=_hera.drzeus.cx-25460-1179171560-0001-2--
