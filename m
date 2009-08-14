Return-Path: <linux-kernel-owner+w=401wt.eu-S1753589AbZHNUky@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753589AbZHNUky (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Aug 2009 16:40:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753395AbZHNUkx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Aug 2009 16:40:53 -0400
Received: from vms173015pub.verizon.net ([206.46.173.15]:41264 "EHLO
	vms173015pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032AbZHNUkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Aug 2009 16:40:51 -0400
From: Len Brown <lenb@kernel.org>
To: x86@kernel.org, sfi-devel@simplefirmware.org, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>
Subject: [PATCH 02/11] ACPI, PCI: Change PREFIX to "PCI" from "ACPI" in
 mmconfig-shared.c
Date: Fri, 14 Aug 2009 16:38:06 -0400
Message-id: <97512a9e5460234eabf1aa35db782e670ba3b830.1250281826.git.len.brown@intel.com>
X-Mailer: git-send-email 1.6.4.122.g6ffd7
In-reply-to: <1250282295-25216-1-git-send-email-lenb@kernel.org>
References: <1250282295-25216-1-git-send-email-lenb@kernel.org>
In-reply-to: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
References: <0763223ab0ef5c0016b7a179c1acccaabbefea02.1250281826.git.len.brown@intel.com>
X-Patchwork-Hint: ignore
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Len Brown <len.brown@intel.com>

Signed-off-by: Len Brown <len.brown@intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/mmconfig-shared.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/mmconfig-shared.c b/arch/x86/pci/mmconfig-shared.c
index 81d3466..b707a01 100644
--- a/arch/x86/pci/mmconfig-shared.c
+++ b/arch/x86/pci/mmconfig-shared.c
@@ -18,7 +18,7 @@
 #include <asm/e820.h>
 #include <asm/pci_x86.h>
 
-#define PREFIX "ACPI: "
+#define PREFIX "PCI: "
 
 /* aperture is up to 256MB but BIOS may reserve less */
 #define MMCONFIG_APER_MIN	(2 * 1024*1024)
-- 
1.6.0.6

