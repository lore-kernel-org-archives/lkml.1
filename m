Return-Path: <linux-kernel-owner+w=401wt.eu-S1761429AbXIXX2g@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761429AbXIXX2g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2007 19:28:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758509AbXIXX2I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 24 Sep 2007 19:28:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:8422 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757935AbXIXX2G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2007 19:28:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,293,1186383600"; 
   d="scan'208";a="151727334"
Date: Mon, 24 Sep 2007 16:23:14 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch] ata: libata: add per device private data
Message-Id: <20070924162314.408ece21.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Allow host controllers to store private data per device.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>

---
 include/linux/libata.h |    3 +++
 1 file changed, 3 insertions(+)

Index: libata-dev/include/linux/libata.h
===================================================================
--- libata-dev.orig/include/linux/libata.h	2007-09-24 16:13:33.000000000 -0700
+++ libata-dev/include/linux/libata.h	2007-09-24 16:15:24.000000000 -0700
@@ -474,6 +474,9 @@ struct ata_device {
 	/* error history */
 	struct ata_ering	ering;
 	int			spdn_cnt;
+
+	/* controller driver per device private data */
+	void 			*private_data;
 };
 
 /* Offset into struct ata_device.  Fields above it are maintained
