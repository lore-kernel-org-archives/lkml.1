Return-Path: <linux-kernel-owner+w=401wt.eu-S1761415AbZATRfV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761415AbZATRfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2009 12:35:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754995AbZATRfG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Jan 2009 12:35:06 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:13989 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753292AbZATRfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2009 12:35:05 -0500
Date: Tue, 20 Jan 2009 10:35:03 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: [PATCH 1/1] edac: remove EDACs experimental status
Message-ID: <49760b47.2I7MimCEUJOM3CRp%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.2 01/07/07
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Doug Thompson <dougthompson@xmission.com>

After 3 years, this is a patch to remove the EXPERIMENTAL tag on EDAC.
We now have many module drivers submitters in EDAC and believe EDAC
is no longer EXPERIMENTAL


Signed-off-by: Doug Thompson <dougthompson@xmission.com
---
 Kconfig |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

Index: linux-2.6.28/drivers/edac/Kconfig
===================================================================
--- linux-2.6.28.orig/drivers/edac/Kconfig
+++ linux-2.6.28/drivers/edac/Kconfig
@@ -1,13 +1,12 @@
 #
 #	EDAC Kconfig
-#	Copyright (c) 2003 Linux Networx
+#	Copyright (c) 2008 Doug Thompson www.softwarebitmaker.com
 #	Licensed and distributed under the GPL
 #
 
 menuconfig EDAC
-	bool "EDAC - error detection and reporting (EXPERIMENTAL)"
+	bool "EDAC - error detection and reporting"
 	depends on HAS_IOMEM
-	depends on EXPERIMENTAL
 	depends on X86 || PPC
 	help
 	  EDAC is designed to report errors in the core system.
