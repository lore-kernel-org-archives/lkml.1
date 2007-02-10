Return-Path: <linux-kernel-owner+w=401wt.eu-S1946828AbXBJL4M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946828AbXBJL4M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Feb 2007 06:56:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933393AbXBJLxG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 10 Feb 2007 06:53:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:55914 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933447AbXBJLwr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Feb 2007 06:52:47 -0500
From: Andi Kleen <ak@suse.de>
References: <200702101252.033732000@suse.de>
In-Reply-To: <200702101252.033732000@suse.de>
To: Zachary Amsden <zach@vmware.com>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2.6.21 review II] [10/10] VMI: Paravirt debug defaults off
Message-Id: <20070210115238.98ADB13E10@wotan.suse.de>
Date: Sat, 10 Feb 2007 12:52:38 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
Deliberate register clobber around performance critical inline code is great for
testing, bad to leave on by default.  Many people ship with DEBUG_KERNEL turned
on, so stop making DEBUG_PARAVIRT default on.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 3a8033f42ecf arch/i386/Kconfig.debug
--- a/arch/i386/Kconfig.debug	Fri Feb 02 17:33:35 2007 -0800
+++ b/arch/i386/Kconfig.debug	Fri Feb 02 17:48:45 2007 -0800
@@ -89,7 +89,7 @@ config DOUBLEFAULT
 
 config DEBUG_PARAVIRT
 	bool "Enable some paravirtualization debugging"
-	default y
+	default n
 	depends on PARAVIRT && DEBUG_KERNEL
 	help
 	  Currently deliberately clobbers regs which are allowed to be

