Return-Path: <linux-kernel-owner+w=401wt.eu-S1754755AbYLNUsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754755AbYLNUsF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 15:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751584AbYLNUry
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 15:47:54 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:38777 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751493AbYLNUrx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 15:47:53 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 21:47:36 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firewire: core: remove unused definitions
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
Message-ID: <tkrat.c22984b78c619e27@s5r6.in-berlin.de>
References: <tkrat.aa7114dbd92c6a7d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.h |   12 ------------
 1 file changed, 12 deletions(-)

Index: linux/drivers/firewire/fw-transaction.h
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.h
+++ linux/drivers/firewire/fw-transaction.h
@@ -138,12 +138,6 @@ typedef void (*fw_address_callback_t)(st
 				      void *data, size_t length,
 				      void *callback_data);
 
-typedef void (*fw_bus_reset_callback_t)(struct fw_card *handle,
-					int node_id, int generation,
-					u32 *self_ids,
-					int self_id_count,
-					void *callback_data);
-
 struct fw_packet {
 	int speed;
 	int generation;
@@ -184,12 +178,6 @@ struct fw_transaction {
 	void *callback_data;
 };
 
-static inline struct fw_packet *
-fw_packet(struct list_head *l)
-{
-	return list_entry(l, struct fw_packet, link);
-}
-
 struct fw_address_handler {
 	u64 offset;
 	size_t length;

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

