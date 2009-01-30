Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbZA3KSV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbZA3KSV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jan 2009 05:18:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754819AbZA3KRv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Jan 2009 05:17:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:54361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZA3KRt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jan 2009 05:17:49 -0500
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, lnxninja@linux.vnet.ibm.com,
       Andi Kleen <ak@linux.intel.com>
Subject: [PATCH] Remove empty setup_portio_remap inlines in bigsmp/summit
Date: Fri, 30 Jan 2009 11:17:08 +0100
Message-Id: <1233310639-27916-3-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1233310639-27916-2-git-send-email-andi@firstfloor.org>
References: <1233310639-27916-1-git-send-email-andi@firstfloor.org>
 <1233310639-27916-2-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

These are all unused inlines

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/include/asm/bigsmp/apic.h |    4 ----
 arch/x86/kernel/bigsmp_32.c        |    4 ----
 arch/x86/kernel/summit_32.c        |    4 ----
 3 files changed, 0 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/bigsmp/apic.h b/arch/x86/include/asm/bigsmp/apic.h
index ee29d66..646697e 100644
--- a/arch/x86/include/asm/bigsmp/apic.h
+++ b/arch/x86/include/asm/bigsmp/apic.h
@@ -95,10 +95,6 @@ static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
 	return physids_promote(0xFFL);
 }
 
-static inline void bigsmp_setup_portio_remap(void)
-{
-}
-
 static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
diff --git a/arch/x86/kernel/bigsmp_32.c b/arch/x86/kernel/bigsmp_32.c
index b1f9193..b74f070 100644
--- a/arch/x86/kernel/bigsmp_32.c
+++ b/arch/x86/kernel/bigsmp_32.c
@@ -114,10 +114,6 @@ static inline physid_mask_t bigsmp_ioapic_phys_id_map(physid_mask_t phys_map)
 	return physids_promote(0xFFL);
 }
 
-static inline void bigsmp_setup_portio_remap(void)
-{
-}
-
 static inline int bigsmp_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
diff --git a/arch/x86/kernel/summit_32.c b/arch/x86/kernel/summit_32.c
index 84ff9eb..a04bc99 100644
--- a/arch/x86/kernel/summit_32.c
+++ b/arch/x86/kernel/summit_32.c
@@ -294,10 +294,6 @@ static inline physid_mask_t summit_apicid_to_cpu_present(int apicid)
 	return physid_mask_of_physid(0);
 }
 
-static inline void summit_setup_portio_remap(void)
-{
-}
-
 static inline int summit_check_phys_apicid_present(int boot_cpu_physical_apicid)
 {
 	return 1;
-- 
1.5.6.5

