Return-Path: <linux-kernel-owner+w=401wt.eu-S936083AbXGRSXd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936083AbXGRSXd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:23:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933103AbXGRSXZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:23:25 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40945 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932684AbXGRSXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:23:23 -0400
Date: Wed, 18 Jul 2007 20:23:22 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 1/2] Use menuconfig objects - ISDN
In-Reply-To: <Pine.LNX.4.64.0707182020440.5385@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707182022510.5385@fbirervta.pbzchgretzou.qr>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
 <46980610.9080705@imap.cc> <Pine.LNX.4.64.0707141200310.25352@fbirervta.pbzchgretzou.qr>
 <20070715131144.3467DFC040@xenon.ts.pxnet.com>
 <Pine.LNX.4.64.0707182020440.5385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Unclutter the ISDN menu a tiny bit by moving ISDN4Linux and the CAPI2.0
layers into their own menu.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.23/drivers/isdn/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/isdn/Kconfig
+++ linux-2.6.23/drivers/isdn/Kconfig
@@ -21,7 +21,7 @@ menuconfig ISDN
 
 if ISDN
 
-config ISDN_I4L
+menuconfig ISDN_I4L
 	tristate "Old ISDN4Linux (deprecated)"
 	---help---
 	  This driver allows you to use an ISDN adapter for networking
@@ -43,7 +43,7 @@ if ISDN_I4L
 source "drivers/isdn/i4l/Kconfig"
 endif
 
-config ISDN_CAPI
+menuconfig ISDN_CAPI
 	tristate "CAPI 2.0 subsystem"
 	help
 	  This provides the CAPI (Common ISDN Application Programming
