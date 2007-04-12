Return-Path: <linux-kernel-owner+w=401wt.eu-S1946105AbXDLJvZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946105AbXDLJvZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2007 05:51:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946103AbXDLJtR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Apr 2007 05:49:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56732 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945985AbXDLJkd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2007 05:40:33 -0400
Message-Id: <20070412090850.188894000@suse.de>
References: <20070412090809.917795000@suse.de>
User-Agent: quilt/0.46-14
Date: Thu, 12 Apr 2007 02:08:50 -0700
From: jjohansen@suse.de
To: linux-kernel@vger.kernel.org
Cc: linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       chrisw@sous-sol.org, John Johansen <jjohansen@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>
Subject: [AppArmor 41/41] Add AppArmor LSM to security/Makefile
Content-Disposition: inline; filename=apparmor-intree.diff
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: John Johansen <jjohansen@suse.de>
Signed-off-by: Andreas Gruenbacher <agruen@suse.de>

---
 security/Kconfig  |    1 +
 security/Makefile |    1 +
 2 files changed, 2 insertions(+)

--- a/security/Kconfig
+++ b/security/Kconfig
@@ -94,6 +94,7 @@ config SECURITY_ROOTPLUG
 	  If you are unsure how to answer this question, answer N.
 
 source security/selinux/Kconfig
+source security/apparmor/Kconfig
 
 endmenu
 
--- a/security/Makefile
+++ b/security/Makefile
@@ -14,5 +14,6 @@ endif
 obj-$(CONFIG_SECURITY)			+= security.o dummy.o inode.o
 # Must precede capability.o in order to stack properly.
 obj-$(CONFIG_SECURITY_SELINUX)		+= selinux/built-in.o
+obj-$(CONFIG_SECURITY_APPARMOR)		+= commoncap.o apparmor/
 obj-$(CONFIG_SECURITY_CAPABILITIES)	+= commoncap.o capability.o
 obj-$(CONFIG_SECURITY_ROOTPLUG)		+= commoncap.o root_plug.o

-- 
