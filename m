Return-Path: <linux-kernel-owner+w=401wt.eu-S1759806AbYEVVyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759806AbYEVVyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 17:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760897AbYEVVyS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 17:54:18 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:47044 "EHLO
	emea5-mh.id5.novell.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760557AbYEVVyR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 17:54:17 -0400
From: Alexey Starikovskiy <astarikovskiy@suse.de>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] x86: move pic_mode to apic_32.c
Date: Fri, 23 May 2008 01:54:51 +0400
Message-ID: <20080522215451.1697.88047.stgit@thinkpad>
In-Reply-To: <alpine.LFD.1.10.0805222343430.3295@apollo.tec.linutronix.de>
References: <alpine.LFD.1.10.0805222343430.3295@apollo.tec.linutronix.de>
User-Agent: StGIT/0.14.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Alexey Starikovskiy <astarikovskiy@suse.de>
---

 arch/x86/kernel/apic_32.c     |    2 ++
 arch/x86/kernel/mpparse.c     |    2 --
 arch/x86/mach-visws/mpparse.c |    2 --
 3 files changed, 2 insertions(+), 4 deletions(-)


diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index 6b2c2cf..c0dd696 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -77,6 +77,8 @@ char system_vectors[NR_VECTORS] = { [0 ... NR_VECTORS-1] = SYS_VECTOR_FREE};
  */
 int apic_verbosity;
 
+int pic_mode;
+
 static unsigned int calibration_result;
 
 static int lapic_next_event(unsigned long delta,
diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index e61523a..b72c046 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -48,8 +48,6 @@ int mp_bus_id_to_pci_bus[MAX_MP_BUSSES] = {[0 ... MAX_MP_BUSSES - 1] = -1 };
 
 static int mp_current_pci_id;
 
-int pic_mode;
-
 /*
  * Intel MP BIOS table parsing routines:
  */
diff --git a/arch/x86/mach-visws/mpparse.c b/arch/x86/mach-visws/mpparse.c
index 57484e9..b7d063e 100644
--- a/arch/x86/mach-visws/mpparse.c
+++ b/arch/x86/mach-visws/mpparse.c
@@ -11,8 +11,6 @@
 /* Have we found an MP table */
 int smp_found_config;
 
-int pic_mode;
-
 extern unsigned int __cpuinitdata maxcpus;
 
 /*

