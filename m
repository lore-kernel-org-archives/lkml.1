Return-Path: <linux-kernel-owner+w=401wt.eu-S1754945AbYGWSrg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754945AbYGWSrg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 14:47:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753670AbYGWSr1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 14:47:27 -0400
Received: from outbound-wa4.frontbridge.com ([216.32.181.16]:24989 "EHLO
	WA4EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753689AbYGWSr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 14:47:26 -0400
X-BigFish: VPS29(zzzz10d3izzz32i87il68o)
X-Spam-TCS-SCL: 7:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4H2UM-02-08N-01
In-Reply-To: <20080722125315.5d34f2e6@infradead.org>
References: <20080722125315.5d34f2e6@infradead.org>
From: Robert Richter <robert.richter@amd.com>
Date: Wed, 23 Jul 2008 15:28:14 +0200
Subject: [PATCH] x86: apic: Changing export symbols to *_GPL
To: Arjan van de Ven <arjan@infradead.org>
CC: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>
Message-ID: <20080723184709.ECF218403@erda.amd.com>
X-OriginalArrivalTime: 23 Jul 2008 18:47:17.0275 (UTC) FILETIME=[87B0DEB0:01C8ECF4]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fits better here.

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_32.c |    2 +-
 arch/x86/kernel/apic_64.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index ed3a6d7..0059e7a 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -672,7 +672,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
-EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Local APIC start and shutdown
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 45ec90e..e571351 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -232,7 +232,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
-EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
+EXPORT_SYMBOL_GPL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
-- 
1.5.5.4


