Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXDNV3j@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXDNV3j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:29:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753893AbXDNVVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:06 -0400
Received: from gw.goop.org ([64.81.55.164]:59574 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753847AbXDNVUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:22 -0400
Message-Id: <20070414204924.872624858@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:14 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>
Subject: [PATCH 20/28] Now that the VDSO can be relocated, we can support it in VMI configurations.
Content-Disposition: inline; filename=vmi-supports-compat-vdso.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>

---
 arch/i386/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/Kconfig
+++ b/arch/i386/Kconfig
@@ -220,7 +220,7 @@ config PARAVIRT
 
 config VMI
 	bool "VMI Paravirt-ops support"
-	depends on PARAVIRT && !COMPAT_VDSO
+	depends on PARAVIRT
 	help
 	  VMI provides a paravirtualized interface to the VMware ESX server
 	  (it could be used by other hypervisors in theory too, but is not

-- 

