Return-Path: <linux-kernel-owner+w=401wt.eu-S965509AbXD3Kao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965509AbXD3Kao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2007 06:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754545AbXD3K3X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Apr 2007 06:29:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965336AbXD3K2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2007 06:28:07 -0400
From: Andi Kleen <ak@suse.de>
References: <200704301227.598020000@suse.de>
In-Reply-To: <200704301227.598020000@suse.de>
To: zach@vmware.com, trivial@kernel.org, patches@x86-64.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] [32/40] i386: kRemove a warning about unused variable in !CONFIG_ACPI compilation.
Message-Id: <20070430102807.05448151D3@wotan.suse.de>
Date: Mon, 30 Apr 2007 12:28:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
Signed-off-by: Andi Kleen <ak@suse.de>
CC: Trivial <trivial@kernel.org>

---
 arch/i386/kernel/acpi/earlyquirk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
Index: linux/arch/i386/kernel/acpi/earlyquirk.c
===================================================================
--- linux.orig/arch/i386/kernel/acpi/earlyquirk.c
+++ linux/arch/i386/kernel/acpi/earlyquirk.c
@@ -21,8 +21,8 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
-	static int warned;
 #ifdef CONFIG_ACPI
+	static int warned;
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
