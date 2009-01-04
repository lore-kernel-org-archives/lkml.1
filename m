Return-Path: <linux-kernel-owner+w=401wt.eu-S1758041AbZADP0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758041AbZADP0m (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 10:26:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752982AbZADP0b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 10:26:31 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:44049 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400AbZADP0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 10:26:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 4 Jan 2009 16:26:11 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 04/11] firewire: core: topology header fix
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
Message-ID: <tkrat.928cd67e528eb745@s5r6.in-berlin.de>
References: <tkrat.3905b2754a8fc519@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-topology.h |    6 ++++++
 1 file changed, 6 insertions(+)

Index: linux/drivers/firewire/fw-topology.h
===================================================================
--- linux.orig/drivers/firewire/fw-topology.h
+++ linux/drivers/firewire/fw-topology.h
@@ -19,6 +19,11 @@
 #ifndef __fw_topology_h
 #define __fw_topology_h
 
+#include <linux/list.h>
+#include <linux/slab.h>
+
+#include <asm/atomic.h>
+
 enum {
 	FW_NODE_CREATED,
 	FW_NODE_UPDATED,
@@ -64,6 +69,7 @@ static inline void fw_node_put(struct fw
 		kfree(node);
 }
 
+struct fw_card;
 void fw_destroy_nodes(struct fw_card *card);
 
 int fw_compute_block_crc(u32 *block);

-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/

