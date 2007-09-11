Return-Path: <linux-kernel-owner+w=401wt.eu-S1764226AbXIKSqT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764226AbXIKSqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2007 14:46:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758733AbXIKSqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Sep 2007 14:46:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:26977 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757585AbXIKSqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2007 14:46:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.20,239,1186383600"; 
   d="scan'208";a="302559168"
Date: Tue, 11 Sep 2007 11:41:59 -0700
From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
To: jeff@garzik.org
Cc: akpm@linux-foundation.org, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [patch] ata: increase allowed config flags
Message-Id: <20070911114159.4854ba4c.kristen.c.accardi@intel.com>
X-Mailer: Sylpheed 2.3.1 (GTK+ 2.10.13; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

In anticipation of more features, increase number of config flags
allowed, and move the init flags.

Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: Hugh Dickens <hugh@veritas.com>

Index: 2.6-mm/include/linux/libata.h
===================================================================
--- 2.6-mm.orig/include/linux/libata.h
+++ 2.6-mm/include/linux/libata.h
@@ -140,11 +140,11 @@ enum {
 	ATA_DFLAG_ACPI_PENDING	= (1 << 5), /* ACPI resume action pending */
 	ATA_DFLAG_ACPI_FAILED	= (1 << 6), /* ACPI on devcfg has failed */
 	ATA_DFLAG_AN		= (1 << 7), /* device supports AN */
-	ATA_DFLAG_CFG_MASK	= (1 << 8) - 1,
+	ATA_DFLAG_CFG_MASK	= (1 << 12) - 1,
 
-	ATA_DFLAG_PIO		= (1 << 8), /* device limited to PIO mode */
-	ATA_DFLAG_NCQ_OFF	= (1 << 9), /* device limited to non-NCQ mode */
-	ATA_DFLAG_SPUNDOWN	= (1 << 10), /* XXX: for spindown_compat */
+	ATA_DFLAG_PIO		= (1 << 12), /* device limited to PIO mode */
+	ATA_DFLAG_NCQ_OFF	= (1 << 13), /* device limited to non-NCQ mode */
+	ATA_DFLAG_SPUNDOWN	= (1 << 14), /* XXX: for spindown_compat */
 	ATA_DFLAG_INIT_MASK	= (1 << 16) - 1,
 
 	ATA_DFLAG_DETACH	= (1 << 16),
