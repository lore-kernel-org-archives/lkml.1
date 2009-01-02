Return-Path: <linux-kernel-owner+w=401wt.eu-S1757961AbZABO2T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757961AbZABO2T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 09:28:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755618AbZABO2H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 09:28:07 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:50682 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755373AbZABO2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 09:28:04 -0500
Date: Fri, 2 Jan 2009 12:27:44 -0200
From: Mauro Carvalho Chehab <mchehab@infradead.org>
To: Linux Media Mailing List <linux-media@vger.kernel.org>
Cc: DVB ML <linux-dvb@linuxtv.org>, Video <video4linux-list@redhat.com>,
       Jonathan Corbet <corbet@lwn.net>, Hans Verkuil <hverkuil@xs4all.nl>,
       Andy Walls <awalls@radix.net>,
       Erik =?ISO-8859-1?B?QW5kculu?= <erik.andren@gmail.com>,
       Hans de Goede <j.w.r.degoede@hhs.nl>,
       Leandro Costantino <lcostantino@gmail.com>,
       Jean-Francois Moine <moinejf@free.fr>, Mike Isely <isely@isely.net>,
       Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Luca Risolia <luca.risolia@studio.unibo.it>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Antoine Jacquet <royale@zerezo.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] Update MAINTAINERS entries on media drivers
Message-ID: <20090102122744.26fb7bb3@pedra.chehab.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates the MAINTAINERS entries for the media drivers.

We are doing a few changes during 2009 to improve patch handling for
drivers/media stuff.

Currently, v4l-dvb-maintainer list at linuxtv.org were used to to be v4l/dvb
driver maintainers ML, in order to keep track of patch merge requests and to
receive bug fixes. This list allows posting for everybody, but, in order to
avoid spam, the user subscribe/unsubscribe at the ML is moderated. Other
development discussions and end-user forums happened on two separated ML (one
for V4L and another for DVB).

At the beginning of 2009, we've created linux-media@vger.kernel.org, meaning to
be the main upstream development mailing list for drivers/media, including V4L
and DVB core and drivers.

The choice for vger.kernel.org were due to the fact that most of upstream lists
are there. Also, its anti-spam filtering rules are better than what we
currently have at linuxtv.org.

For now, both video4linux-list and linux-dvb ML will remain active, but more
focused on end users. It is expected that those lists will gradually be
replaced also by linux-media@vger.kernel.org.

This patch reflect those changes at linux MAINTAINERS file.

Since the development and bug fix discussions will now happen at
linux-media@vger.kernel.org, this patch does the following changes

	- replaces v4l-dvb-maintainer ML for the new
	  linux-media@vger.kernel.org;

	- replaces video4linux ML for the new linux-media@vger.kernel.org;

While here, it also:

	- Fixes the existing -git tree entries for drivers/media (since the
          repository name changed);

	- Adds the missing drivers/media -git tree entry on a few maintainers
          entries that don't point to a tree.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/MAINTAINERS b/MAINTAINERS
index 618c1ef..79c34de 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1023,16 +1023,17 @@ S:	Maintained
 BTTV VIDEO4LINUX DRIVER
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
-M:	v4l-dvb-maintainer@linuxtv.org
+L:	linux-media@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 CAFE CMOS INTEGRATED CAMERA CONTROLLER DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 CALGARY x86-64 IOMMU
@@ -1263,7 +1264,8 @@ P:	Hans Verkuil, Andy Walls
 M:	hverkuil@xs4all.nl, awalls@radix.net
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linuxtv.org
 S:	Maintained
 
@@ -1489,10 +1491,10 @@ S:	Maintained
 
 DVB SUBSYSTEM AND DRIVERS
 P:	LinuxTV.org Project
-M:	v4l-dvb-maintainer@linuxtv.org
+M:	linux-media@vger.kernel.org
 L:	linux-dvb@linuxtv.org (subscription required)
 W:	http://linuxtv.org/
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 DZ DECSTATION DZ11 SERIAL DRIVER
@@ -1882,32 +1884,37 @@ S:	Maintained
 GSPCA FINEPIX SUBDRIVER
 P:	Frank Zago
 M:	frank@zago.net
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 GSPCA M5602 SUBDRIVER
 P:	Erik Andren
 M:	erik.andren@gmail.com
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 GSPCA PAC207 SONIXB SUBDRIVER
 P:	Hans de Goede
 M:	hdegoede@redhat.com
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 GSPCA T613 SUBDRIVER
 P:	Leandro Costantino
 M:	lcostantino@gmail.com
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 GSPCA USB WEBCAM DRIVER
 P:	Jean-Francois Moine
 M:	moinejf@free.fr
 W:	http://moinejf.free.fr
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 HARDWARE MONITORING
@@ -2423,7 +2430,8 @@ P:	Hans Verkuil
 M:	hverkuil@xs4all.nl
 L:	ivtv-devel@ivtvdriver.org
 L:	ivtv-users@ivtvdriver.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.ivtvdriver.org
 S:	Maintained
 
@@ -3184,7 +3192,8 @@ S:	Maintained
 OMNIVISION OV7670 SENSOR DRIVER
 P:	Jonathan Corbet
 M:	corbet@lwn.net
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 ONENAND FLASH DRIVER
@@ -3466,8 +3475,9 @@ PVRUSB2 VIDEO4LINUX DRIVER
 P:	Mike Isely
 M:	isely@pobox.com
 L:	pvrusb2@isely.net	(subscribers-only)
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
 W:	http://www.isely.net/pvrusb2/
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 PXA2xx/PXA3xx SUPPORT
@@ -3919,7 +3929,8 @@ S:	Maintained
 SOC-CAMERA V4L2 SUBSYSTEM
 P:	Guennadi Liakhovetski
 M:	g.liakhovetski@gmx.de
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 SOEKRIS NET48XX LED SUPPORT
@@ -4342,7 +4353,8 @@ USB ET61X[12]51 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 
@@ -4491,7 +4503,8 @@ USB SN9C1xx DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 
@@ -4520,7 +4533,8 @@ USB VIDEO CLASS
 P:	Laurent Pinchart
 M:	laurent.pinchart@skynet.be
 L:	linux-uvc-devel@lists.berlios.de
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://linux-uvc.berlios.de
 S:	Maintained
 
@@ -4528,7 +4542,8 @@ USB W996[87]CF DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 
@@ -4542,7 +4557,8 @@ USB ZC0301 DRIVER
 P:	Luca Risolia
 M:	luca.risolia@studio.unibo.it
 L:	linux-usb@vger.kernel.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://www.linux-projects.org
 S:	Maintained
 
@@ -4557,7 +4573,8 @@ USB ZR364XX DRIVER
 P:	Antoine Jacquet
 M:	royale@zerezo.com
 L:	linux-usb@vger.kernel.org
-L:	video4linux-list@redhat.com
+L:	linux-media@vger.kernel.org
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 W:	http://royale.zerezo.com/zr364xx/
 S:	Maintained
 
@@ -4626,10 +4643,10 @@ S:	Maintained
 VIDEO FOR LINUX (V4L)
 P:	Mauro Carvalho Chehab
 M:	mchehab@infradead.org
-M:	v4l-dvb-maintainer@linuxtv.org
+L:	linux-media@vger.kernel.org
 L:	video4linux-list@redhat.com
 W:	http://linuxtv.org
-T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/v4l-dvb.git
+T:	git kernel.org:/pub/scm/linux/kernel/git/mchehab/linux-2.6.git
 S:	Maintained
 
 VLAN (802.1Q)

