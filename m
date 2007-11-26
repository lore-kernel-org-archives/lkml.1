Return-Path: <linux-kernel-owner+w=401wt.eu-S1758010AbXKZXTh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbXKZXTh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2007 18:19:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757501AbXKZXSg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 Nov 2007 18:18:36 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:40853 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757477AbXKZXSe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2007 18:18:34 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: pm list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 6/6] Hibernation: Move extern definition to header file
Date: Tue, 27 Nov 2007 00:33:04 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: LKML <linux-kernel@vger.kernel.org>, Pavel Machek <pavel@ucw.cz>
References: <200711270025.08128.rjw@sisk.pl>
In-Reply-To: <200711270025.08128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711270033.04999.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rafael J. Wysocki <rjw@sisk.pl>

Move the extern definition of resume_file[] from kernel/power/swap.c
to kernel/power/power.h .

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 kernel/power/power.h |    2 ++
 kernel/power/swap.c  |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/power/power.h
===================================================================
--- linux-2.6.orig/kernel/power/power.h
+++ linux-2.6/kernel/power/power.h
@@ -207,3 +207,5 @@ enum {
 #define TEST_MAX	(__TEST_AFTER_LAST - 1)
 
 extern int pm_test_level;
+
+extern char resume_file[];
Index: linux-2.6/kernel/power/swap.c
===================================================================
--- linux-2.6.orig/kernel/power/swap.c
+++ linux-2.6/kernel/power/swap.c
@@ -28,8 +28,6 @@
 
 #include "power.h"
 
-extern char resume_file[];
-
 #define SWSUSP_SIG	"S1SUSPEND"
 
 struct swsusp_header {
