Return-Path: <linux-kernel-owner+w=401wt.eu-S1753885AbXD3Kaq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885AbXD3Kaq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754546AbXD3K32
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:28 -0400
Received: from ns1.suse.de ([195.135.220.2]:51245 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965407AbXD3K2L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:11 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: zach@vmware.com, patches@x86-64.org, linux-kernel@vger.kernel.org
Subject: [PATCH] [35/40] i386: Now that the VDSO can be relocated, we can support it in VMI configurations.
Message-Id: <20070430102810.39F7D151D2@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:10 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>

---
 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
Index: linux/arch/i386/Kconfig
===================================================================
--- linux.orig/arch/i386/Kconfig
+++ linux/arch/i386/Kconfig
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !COMPAT_VDSO
+	depends on PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not
