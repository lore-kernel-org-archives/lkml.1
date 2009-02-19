Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbZBSRrB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbZBSRrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 12:47:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751706AbZBSRqw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 12:46:52 -0500
Received: from acsinet12.oracle.com ([141.146.126.234]:62754 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751506AbZBSRqw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 12:46:52 -0500
Date: Thu, 19 Feb 2009 09:47:32 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: gregkh@suse.de, evan_ko@phison.com
Subject: [PATCH] staging/phison: depends on PCI
Message-Id: <20090219094732.bacee6e1.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt706.oracle.com [141.146.40.84]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.499D9B00.00FD:SCFSTAT928724,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

phison uses PCI interfaces, so it should depend on PCI.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
cc: Evan Ko <evan_ko@phison.com>
---
 drivers/staging/phison/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20090219.orig/drivers/staging/phison/Kconfig
+++ linux-next-20090219/drivers/staging/phison/Kconfig
@@ -1,5 +1,5 @@
 config IDE_PHISON
 	tristate "PCIE ATA PS5000 IDE support"
-	depends on ATA && ATA_SFF
+	depends on PCI && ATA && ATA_SFF
 	---help---
 	  This is an experimental driver for PS5000 IDE driver.
