Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab0CBX27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Mar 2010 18:28:59 -0500
Received: from mga09.intel.com ([134.134.136.24]:39580 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751327Ab0CBX25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Mar 2010 18:28:57 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,570,1262592000"; 
   d="scan'208";a="497158185"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH] x86/mrst: remove X86_MRST dependency on PCI_IOAPIC
Date: Tue,  2 Mar 2010 09:19:28 -0800
Message-Id: <1267550368-7435-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

PCI_IOAPIC is used for PCI hotplug, Moorestown does not have ACPI PCI
hotplug. This unnecessary dependency causes X86_MRST fail to be selected if
ACPI is not selected.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index b25da64..1ecab88 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -396,7 +396,6 @@ config X86_MRST
        bool "Moorestown MID platform"
 	depends on PCI
 	depends on PCI_GOANY
-	depends on PCI_IOAPIC
 	depends on X86_32
 	depends on X86_EXTENDED_PLATFORM
 	depends on X86_IO_APIC
-- 
1.5.6.5

