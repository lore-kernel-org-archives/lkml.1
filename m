Return-Path: <linux-kernel-owner+w=401wt.eu-S1753895AbXDNV1m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895AbXDNV1m (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2007 17:27:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbXDNVVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 14 Apr 2007 17:21:19 -0400
Received: from gw.goop.org ([64.81.55.164]:59603 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753898AbXDNVUb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2007 17:20:31 -0400
Message-Id: <20070414204924.577611888@goop.org>
References: <20070414204154.871250608@goop.org>
User-Agent: quilt/0.46-1
Date: Sat, 14 Apr 2007 13:42:10 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
To: Andi Kleen <ak@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, virtualization@lists.osdl.org,
       lkml <linux-kernel@vger.kernel.org>, Zachary Amsden <zach@vmware.com>,
       Trivial <trivial@kernel.org>
Subject: [PATCH 16/28] kRemove a warning about unused variable in !CONFIG_ACPI compilation.
Content-Disposition: inline; filename=i386-acpi-remove-earlyquirk-warning.patch
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zachary Amsden <zach@vmware.com>
Signed-off-by: Zachary Amsden <zach@vmware.com>
CC: Trivial <trivial@kernel.org>

---
 arch/i386/kernel/acpi/earlyquirk.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

===================================================================
--- a/arch/i386/kernel/acpi/earlyquirk.c
+++ b/arch/i386/kernel/acpi/earlyquirk.c
@@ -21,8 +21,8 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
+#ifdef CONFIG_ACPI
 	static int warned;
-#ifdef CONFIG_ACPI
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {

-- 

