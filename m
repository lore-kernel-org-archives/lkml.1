Return-Path: <linux-kernel-owner+w=401wt.eu-S1757677AbYCST4F@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757677AbYCST4F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 15:56:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756865AbYCSThh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 15:37:37 -0400
Received: from mx1.redhat.com ([66.187.233.31]:55887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754970AbYCSThe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 15:37:34 -0400
From: Glauber de Oliveira Costa <gcosta@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu, ak@suse.de,
       Glauber Costa <gcosta@redhat.com>
Subject: [PATCH 01/79] [PATCH] change var types in __inquire_remote_apic
Date: Wed, 19 Mar 2008 14:24:56 -0300
Message-Id: <1205947580526-git-send-email-gcosta@redhat.com>
X-Mailer: git-send-email 1.5.0.6
In-Reply-To: <12059475744092-git-send-email-gcosta@redhat.com>
References: <12059475744092-git-send-email-gcosta@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

change some variables' types in __inquire_remote_apic to
match x86_64

Signed-off-by: Glauber Costa <gcosta@redhat.com>
---
 arch/x86/kernel/smpboot_32.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/smpboot_32.c b/arch/x86/kernel/smpboot_32.c
index 2dd95ba..bea2d32 100644
--- a/arch/x86/kernel/smpboot_32.c
+++ b/arch/x86/kernel/smpboot_32.c
@@ -368,10 +368,10 @@ static void unmap_cpu_to_logical_apicid(int cpu)
 
 static inline void __inquire_remote_apic(int apicid)
 {
-	int i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
+	unsigned i, regs[] = { APIC_ID >> 4, APIC_LVR >> 4, APIC_SPIV >> 4 };
 	char *names[] = { "ID", "VERSION", "SPIV" };
 	int timeout;
-	unsigned long status;
+	u32 status;
 
 	printk("Inquiring remote APIC #%d...\n", apicid);
 
-- 
1.5.0.6

