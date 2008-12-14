Return-Path: <linux-kernel-owner+w=401wt.eu-S1755180AbYLNSWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180AbYLNSWZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2008 13:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754577AbYLNSVv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Dec 2008 13:21:51 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:35775 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754781AbYLNSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2008 13:21:50 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 14 Dec 2008 19:21:31 +0100 (CET)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: [PATCH 4/4] firewire: core: remove outdated comment
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Jay Fenlason <fenlason@redhat.com>
In-Reply-To: <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
Message-ID: <tkrat.b960d880b995975c@s5r6.in-berlin.de>
References: <20081124163728.GA5826@redhat.com>
 <492AEED8.9030102@s5r6.in-berlin.de> <492AEF9D.5010307@s5r6.in-berlin.de>
 <tkrat.7bf80e1dd5c90f36@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
---
 drivers/firewire/fw-transaction.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

Index: linux/drivers/firewire/fw-transaction.c
===================================================================
--- linux.orig/drivers/firewire/fw-transaction.c
+++ linux/drivers/firewire/fw-transaction.c
@@ -502,12 +502,7 @@ fw_core_add_address_handler(struct fw_ad
 EXPORT_SYMBOL(fw_core_add_address_handler);
 
 /**
- * Deallocate a range of addresses allocated with fw_allocate.  This
- * will call the associated callback one last time with a the special
- * tcode TCODE_DEALLOCATE, to let the client destroy the registered
- * callback data.  For convenience, the callback parameters offset and
- * length are set to the start and the length respectively for the
- * deallocated region, payload is set to NULL.
+ * fw_core_remove_address_handler - unregister an address handler
  */
 void fw_core_remove_address_handler(struct fw_address_handler *handler)
 {

-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/

