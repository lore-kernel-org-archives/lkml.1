Return-Path: <linux-kernel-owner+w=401wt.eu-S936197AbXGRSXz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936197AbXGRSXz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2007 14:23:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932969AbXGRSXo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jul 2007 14:23:44 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:40949 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934624AbXGRSXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2007 14:23:43 -0400
Date: Wed, 18 Jul 2007 20:23:42 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Tilman Schmidt <tilman@imap.cc>
cc: Andrew Morton <akpm@linux-foundation.org>, Karsten Keil <kkeil@suse.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [patch 2/2] Use menuconfig objects - ISDN/Gigaset
In-Reply-To: <Pine.LNX.4.64.0707182020440.5385@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64.0707182023230.5385@fbirervta.pbzchgretzou.qr>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
 <Pine.LNX.4.64.0707101107340.11053@fbirervta.pbzchgretzou.qr>
 <46980610.9080705@imap.cc> <Pine.LNX.4.64.0707141200310.25352@fbirervta.pbzchgretzou.qr>
 <20070715131144.3467DFC040@xenon.ts.pxnet.com>
 <Pine.LNX.4.64.0707182020440.5385@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Change Kconfig objects from "menu, config" into "menuconfig" so
that the user can disable the whole feature without having to
enter the menu first.

Signed-off-by: Jan Engelhardt <jengelh@gmx.de>

---
 drivers/isdn/gigaset/Kconfig |    8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

Index: linux-2.6.23/drivers/isdn/gigaset/Kconfig
===================================================================
--- linux-2.6.23.orig/drivers/isdn/gigaset/Kconfig
+++ linux-2.6.23/drivers/isdn/gigaset/Kconfig
@@ -1,6 +1,4 @@
-menu "Siemens Gigaset"
-
-config ISDN_DRV_GIGASET
+menuconfig ISDN_DRV_GIGASET
 	tristate "Siemens Gigaset support (isdn)"
 	select CRC_CCITT
 	select BITREVERSE
@@ -53,6 +51,4 @@ config GIGASET_UNDOCREQ
 	  features like configuration mode of M105, say yes. If you
 	  care about your device, say no.
 
-endif
-
-endmenu
+endif # ISDN_DRV_GIGASET != n
