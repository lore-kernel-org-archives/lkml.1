Return-Path: <linux-kernel-owner+w=401wt.eu-S1756279AbZDKH0N@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756279AbZDKH0N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Apr 2009 03:26:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752634AbZDKHZ5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Apr 2009 03:25:57 -0400
Received: from hera.kernel.org ([140.211.167.34]:50688 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751754AbZDKHZ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Apr 2009 03:25:57 -0400
Subject: [PATCH -tip] x86: apic/x2apic_cluster.c x86_cpu_to_logical_apicid
 should be static
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, x86 maintainers <x86@kernel.org>,
       Suresh Siddha <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Sat, 11 Apr 2009 12:55:26 +0530
Message-Id: <1239434726.4418.24.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.4 (2.24.4-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: reduce kernel size a bit, avoid sparse warning

Fixes sparse warning:
  arch/x86/kernel/apic/x2apic_cluster.c:13:1: warning: symbol 'per_cpu__x86_cpu_to_logical_apicid' was not declared. Should it be static?

Signed-off-by: Jaswinder Singh Rajput <jaswinderrajput@gmail.com>
---
 arch/x86/kernel/apic/x2apic_cluster.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kernel/apic/x2apic_cluster.c b/arch/x86/kernel/apic/x2apic_cluster.c
index 4a903e2..8e4cbb2 100644
--- a/arch/x86/kernel/apic/x2apic_cluster.c
+++ b/arch/x86/kernel/apic/x2apic_cluster.c
@@ -10,7 +10,7 @@
 #include <asm/apic.h>
 #include <asm/ipi.h>
 
-DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
+static DEFINE_PER_CPU(u32, x86_cpu_to_logical_apicid);
 
 static int x2apic_acpi_madt_oem_check(char *oem_id, char *oem_table_id)
 {
-- 
1.6.0.6



