Return-Path: <linux-kernel-owner+w=401wt.eu-S964972AbXBFQmv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964972AbXBFQmv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Feb 2007 11:42:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965161AbXBFQmv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Feb 2007 11:42:51 -0500
Received: from tim.rpsys.net ([194.106.48.114]:37236 "EHLO tim.rpsys.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964972AbXBFQmu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Feb 2007 11:42:50 -0500
Subject: [PATCH] input: Schedule removal of compaq touchscreen emulation
	(tsdev.c)
From: Richard Purdie <rpurdie@rpsys.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org,
       Linux-Input <linux-input@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Date: Tue, 06 Feb 2007 16:42:39 +0000
Message-Id: <1170780159.5826.71.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.6.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Schedule removal of Compaq touchscreen emulation (drivers/input/tsdev.c)

Its old, was obsolete when it was written by the authors own admission
and much better userspace solutions like tslib now exist. The name is
also confusing.

Signed-off-by: Richard Purdie <rpurdie@rpsys.net> 

 Documentation/feature-removal-schedule.txt |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

Index: linux/Documentation/feature-removal-schedule.txt
===================================================================
--- linux.orig/Documentation/feature-removal-schedule.txt	2007-02-06 09:40:43.000000000 +0000
+++ linux/Documentation/feature-removal-schedule.txt	2007-02-06 11:36:31.000000000 +0000
@@ -325,3 +325,17 @@ Why:	Unmaintained for years, superceded 
 Who:	Jeff Garzik <jeff@garzik.org>
 
 ---------------------------
+
+What:   Compaq touchscreen device emulation
+When:   Oct 2007
+Files:  drivers/input/tsdev.c
+Why:    The code says it was obsolete when it was written in 2001.
+        tslib is a userspace library which does anything tsdev can do and
+        much more besides in userspace where this code belongs. There is no
+        longer any need for tsdev and applications should have converted to
+        use tslib by now.
+        The name "tsdev" is also extremely confusing and lots of people have
+        it loaded when they don't need/use it.
+Who:    Richard Purdie <rpurdie@rpsys.net>
+
+---------------------------


