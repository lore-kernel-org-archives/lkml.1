Return-Path: <linux-kernel-owner+w=401wt.eu-S1763589AbYBMPVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763589AbYBMPVS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 10:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755478AbYBMPVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 10:21:07 -0500
Received: from outbound-dub.frontbridge.com ([213.199.154.16]:64829 "EHLO
	outbound8-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755266AbYBMPVG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 10:21:06 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-WSS-ID: 0JW6NYC-01-5PB-01
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <20080213151841.520543000@amd.com>
References: <20080213151811.804698000@amd.com>
User-Agent: quilt/0.46-1
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>
cc: "LKML" <linux-kernel@vger.kernel.org>,
       "Robert Richter" <robert.richter@amd.com>
Subject: [patch 1/2] x86: apic: Export symbols for extended interrupt
 LVT functions
Date: Wed, 13 Feb 2008 16:19:36 +0100 (CET)
X-OriginalArrivalTime: 13 Feb 2008 15:19:36.0633 (UTC)
 FILETIME=[D8100A90:01C86E53]
MIME-Version: 1.0
X-WSS-ID: 6BADD54E07S10443438-01-01
Content-Disposition: inline;
 filename=0001-x86-apic-Export-symbols-for-extended-interrupt-LVT.patch
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
index d8d03e0..2a9f4bc 100644
--- a/arch/x86/kernel/apic_64.c
+++ b/arch/x86/kernel/apic_64.c
@@ -215,12 +215,14 @@ u8 setup_APIC_eilvt_mce(u8 vector, u8 msg_type, u8 mask)
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

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



