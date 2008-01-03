Return-Path: <linux-kernel-owner+w=401wt.eu-S1756020AbYACV7S@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756020AbYACV7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2008 16:59:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752877AbYACV6c
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Jan 2008 16:58:32 -0500
Received: from norsk5.dsl.xmission.com ([166.70.24.44]:11151 "EHLO
	master.douglaskthompson.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752649AbYACV6a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2008 16:58:30 -0500
Date: Thu, 03 Jan 2008 14:30:00 -0700
From: dougthompson@xmission.com
To: dougthompson@xmission.com, alan@lxorguk.ukuu.org.uk,
       linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: [PATCH 2/4] drivers-edac-i3000-64bit-build
Message-ID: <477d53d8.RaZRbWvnGE5mdJUI%dougthompson@xmission.com>
User-Agent: Heirloom mailx 12.1 6/15/06
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jason Uhlenkott <juhlenko@akamai.com>

Modified to run on x86_64 as well as x86

i3000_edac builds (and runs) fine on x86_64.

Signed-off-by: Jason Uhlenkott <juhlenko@akamai.com>
Signed-off-by: Doug Thompson <dougthompson@xmission.com>
---
 Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.23.8/drivers/edac/Kconfig
===================================================================
--- linux-2.6.23.8.orig/drivers/edac/Kconfig
+++ linux-2.6.23.8/drivers/edac/Kconfig
@@ -97,7 +97,7 @@ config EDAC_I82975X
 
 config EDAC_I3000
 	tristate "Intel 3000/3010"
-	depends on EDAC_MM_EDAC && PCI && X86_32
+	depends on EDAC_MM_EDAC && PCI && X86
 	help
 	  Support for error detection and correction on the Intel
 	  3000 and 3010 server chipsets.
