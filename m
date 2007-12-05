Return-Path: <linux-kernel-owner+w=401wt.eu-S1751988AbXLEQoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988AbXLEQoU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 11:44:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751439AbXLEQoI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 11:44:08 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:8554 "EHLO
	outbound8-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751432AbXLEQoH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 11:44:07 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: D6C75999-9DAF-4D89-B9AC-C25E3A0BB76A
From: "Robert Richter" <robert.richter@amd.com>
Subject: [PATCH] x86: apic: Export symbols for extended interrupt LVT
 functions
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
Message-ID: <20071205164014.E55DC8098@erda.amd.com>
Date: Wed,  5 Dec 2007 17:40:14 +0100 (CET)
X-OriginalArrivalTime: 05 Dec 2007 16:40:14.0966 (UTC)
 FILETIME=[83049160:01C8375D]
MIME-Version: 1.0
X-WSS-ID: 6B480B0E24S4488765-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 arch/x86/kernel/apic_64.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/apic_64.c b/arch/x86/kernel/apic_64.c
index 5a31a8c..a678e8f 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -209,12 +209,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_MCE, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_MCE;
 }
+EXPORT_SYMBOL(setup_APIC_eilvt_mce);
 
 u8 setup_APIC_eilvt_ibs(u8 vector, u8 msg_type, u8 mask)
 {
 	setup_APIC_eilvt(APIC_EILVT_LVTOFF_IBS, vector, msg_type, mask);
 	return APIC_EILVT_LVTOFF_IBS;
 }
+EXPORT_SYMBOL(setup_APIC_eilvt_ibs);
 
 /*
  * Program the next event, relative to now
-- 
1.5.1.6



