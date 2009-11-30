Return-Path: <linux-kernel-owner+w=401wt.eu-S1753049AbZK3GTL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049AbZK3GTL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Nov 2009 01:19:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbZK3GTL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Nov 2009 01:19:11 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:61054 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750727AbZK3GTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Nov 2009 01:19:10 -0500
Message-ID: <4B13637E.3040400@cn.fujitsu.com>
Date: Mon, 30 Nov 2009 14:17:34 +0800
From: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jeremy Fitzhardinge <jeremy@goop.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] xen: cleanup for xen_pv_domain()/xen_hvm_domain()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnecessary judgment in xen_pv_domain() and xen_hvm_domain()

Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
---
 arch/x86/include/asm/xen/hypervisor.h |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/xen/hypervisor.h b/arch/x86/include/asm/xen/hypervisor.h
index d5b7e90..f94bd0a 100644
--- a/arch/x86/include/asm/xen/hypervisor.h
+++ b/arch/x86/include/asm/xen/hypervisor.h
@@ -50,10 +50,8 @@ extern enum xen_domain_type xen_domain_type;
 #endif
 
 #define xen_domain()		(xen_domain_type != XEN_NATIVE)
-#define xen_pv_domain()		(xen_domain() &&			\
-				 xen_domain_type == XEN_PV_DOMAIN)
-#define xen_hvm_domain()	(xen_domain() &&			\
-				 xen_domain_type == XEN_HVM_DOMAIN)
+#define xen_pv_domain()		(xen_domain_type == XEN_PV_DOMAIN)
+#define xen_hvm_domain()	(xen_domain_type == XEN_HVM_DOMAIN)
 
 #ifdef CONFIG_XEN_DOM0
 #include <xen/interface/xen.h>
-- 
1.6.1.2

