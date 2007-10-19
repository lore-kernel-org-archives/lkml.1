Return-Path: <linux-kernel-owner+w=401wt.eu-S1764339AbXJSFEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764339AbXJSFEu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2007 01:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751625AbXJSFEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Oct 2007 01:04:41 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54366 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbXJSFEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2007 01:04:40 -0400
Date: Fri, 19 Oct 2007 15:04:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Wilcox <matthew@wil.cx>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] Make advansys depend on CONFIG_VIRT_TO_BUS
Message-Id: <20071019150431.996522c5.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 2.4.7 (GTK+ 2.12.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

At least for now.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/scsi/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 30905ce..325533c 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -523,6 +523,7 @@ config SCSI_ADVANSYS
 	tristate "AdvanSys SCSI support"
 	depends on SCSI
 	depends on ISA || EISA || PCI
+	depends on VIRT_TO_BUS
 	help
 	  This is a driver for all SCSI host adapters manufactured by
 	  AdvanSys. It is documented in the kernel source in
-- 
1.5.3.4

