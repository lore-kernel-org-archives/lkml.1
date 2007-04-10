Return-Path: <linux-kernel-owner+w=401wt.eu-S1753673AbXDJAIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753673AbXDJAIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2007 20:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753679AbXDJAIc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Apr 2007 20:08:32 -0400
Received: from smtp-outbound-1.vmware.com ([65.113.40.141]:53688 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753675AbXDJAIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2007 20:08:31 -0400
Date: Mon, 9 Apr 2007 17:06:05 -0700
Message-Id: <200704100006.l3A06534020602@zach-dev.vmware.com>
Subject: [PATCH 2/10] I386 acpi remove earlyquirk warning.patch
From: Zachary Amsden <zach@vmware.com>
To: Andrew Morton <akpm@osdl.org>, Andi Kleen <ak@muc.de>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Chris Wright <chrisw@sous-sol.org>,
       Virtualization Mailing List <virtualization@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Zachary Amsden <zach@vmware.com>
CC: Trivial <trivial@kernel.org>
X-OriginalArrivalTime: 10 Apr 2007 00:08:31.0174 (UTC) FILETIME=[5F443660:01C77B04]
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove a warning about unused variable in !CONFIG_ACPI compilation.

Signed-off-by: Zachary Amsden <zach@vmware.com>

diff -r 1969f6c3440a arch/i386/kernel/acpi/earlyquirk.c
--- a/arch/i386/kernel/acpi/earlyquirk.c	Fri Apr 06 14:27:45 2007 -0700
+++ b/arch/i386/kernel/acpi/earlyquirk.c	Fri Apr 06 14:29:46 2007 -0700
@@ -21,8 +21,8 @@ static int __init nvidia_hpet_check(stru
 
 static int __init check_bridge(int vendor, int device)
 {
+#ifdef CONFIG_ACPI
 	static int warned;
-#ifdef CONFIG_ACPI
 	/* According to Nvidia all timer overrides are bogus unless HPET
 	   is enabled. */
 	if (!acpi_use_timer_override && vendor == PCI_VENDOR_ID_NVIDIA) {
