Return-Path: <linux-kernel-owner+w=401wt.eu-S1756101AbYGVTbT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101AbYGVTbT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2008 15:31:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755531AbYGVTY6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Jul 2008 15:24:58 -0400
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:43997 "EHLO
	SG2EHSOBE004.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754695AbYGVTY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2008 15:24:57 -0400
X-BigFish: VPS22(zzzz10d3izzz32i87il64h)
X-Spam-TCS-SCL: 3:0
X-FB-DOMAIN-IP-MATCH: fail
X-WSS-ID: 0K4F9WU-02-3OF-01
From: Robert Richter <robert.richter@amd.com>
To: Barry Kasindorf <barry.kasindorf@amd.com>, Ingo Molnar <mingo@elte.hu>
CC: Thomas Gleixner <tglx@linutronix.de>,
       oprofile-list <oprofile-list@lists.sourceforge.net>,
       LKML <linux-kernel@vger.kernel.org>,
       Robert Richter <robert.richter@amd.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 21/24] x86: apic: Export symbols for extended interrupt LVT functions
Date: Tue, 22 Jul 2008 21:09:05 +0200
Message-ID: <1216753748-11261-22-git-send-email-robert.richter@amd.com>
X-Mailer: git-send-email 1.5.5.4
In-Reply-To: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
References: <1216753748-11261-1-git-send-email-robert.richter@amd.com>
X-OriginalArrivalTime: 22 Jul 2008 19:23:40.0949 (UTC) FILETIME=[72D95450:01C8EC30]
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds EXPORT_SYMBOLs to allow OProfile to be built as
module.

Cc: Arjan van de Ven <arjan@infradead.org>
Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_32.c |    1 +
 arch/x86/kernel/apic_64.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_32.c b/arch/x86/kernel/apic_32.c
index fad94b0..ed3a6d7 100644
--- a/arch/x86/kernel/apic_32.c
+++ b/arch/x86/kernel/apic_32.c
@@ -672,6 +672,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
 
 /*
  * Local APIC start and shutdown
diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 42bf69f..45ec90e 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -232,6 +232,7 @@ u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
-- 
1.5.5.4


