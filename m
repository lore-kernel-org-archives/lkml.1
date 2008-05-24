Return-Path: <linux-kernel-owner+w=401wt.eu-S1757992AbYEXOrY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992AbYEXOrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2008 10:47:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753498AbYEXOrQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 24 May 2008 10:47:16 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:48311 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754783AbYEXOrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2008 10:47:15 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 24 May 2008 16:46:10 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH] firewire: remove unused struct members
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
Message-ID: <tkrat.1a51acde47bf820a@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-card.c        |    1 -
 drivers/firewire/fw-device.h      |    1 -
 drivers/firewire/fw-ohci.c        |    1 -
 drivers/firewire/fw-transaction.h |    2 --
 4 files changed, 5 deletions(-)

Index: linux/drivers/firewire/fw-card.c
===================================================================
--- linux.orig/drivers/firewire/fw-card.c
+++ linux/drivers/firewire/fw-card.c
@@ -497,7 +497,6 @@ dummy_enable_phys_dma(struct fw_card *ca
 }
 
 static struct fw_card_driver dummy_driver = {
-	.name            = "dummy",
 	.enable          = dummy_enable,
 	.update_phy_reg  = dummy_update_phy_reg,
 	.set_config_rom  = dummy_set_config_rom,
Index: linux/drivers/firewire/fw-device.h
===================================================================
--- linux.orig/drivers/firewire/fw-device.h
+++ linux/drivers/firewire/fw-device.h
@@ -62,7 +62,6 @@ struct fw_device {
 	bool cmc;
 	struct fw_card *card;
 	struct device device;
-	struct list_head link;
 	struct list_head client_list;
 	u32 *config_rom;
 	size_t config_rom_length;
Index: linux/drivers/firewire/fw-ohci.c
===================================================================
--- linux.orig/drivers/firewire/fw-ohci.c
+++ linux/drivers/firewire/fw-ohci.c
@@ -2290,7 +2290,6 @@ ohci_queue_iso(struct fw_iso_context *ba
 }
 
 static const struct fw_card_driver ohci_driver = {
-	.name			= ohci_driver_name,
 	.enable			= ohci_enable,
 	.update_phy_reg		= ohci_update_phy_reg,
 	.set_config_rom		= ohci_set_config_rom,
Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -361,8 +361,6 @@ int
 fw_iso_context_stop(struct fw_iso_context *ctx);
 
 struct fw_card_driver {
-	const char *name;
-
 	/*
 	 * Enable the given card with the given initial config rom.
 	 * This function is expected to activate the card, and either

-- 
Stefan Richter
-=====-==--- -=-= ==---
http://arcgraph.de/sr/

