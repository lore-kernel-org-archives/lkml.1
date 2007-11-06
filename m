Return-Path: <linux-kernel-owner+w=401wt.eu-S1756692AbXKFSvo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756692AbXKFSvo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 13:51:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755987AbXKFSvZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 13:51:25 -0500
Received: from outbound-blu.frontbridge.com ([65.55.251.16]:1997 "EHLO
	outbound5-blu-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755734AbXKFSvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 13:51:23 -0500
X-BigFish: VP
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 163.181.251.8;Service: EHS
X-Server-Uuid: DF9F24A0-1A5C-40A5-8B0A-DEB676E72ECF
Message-ID: <20071106183646.155885000@amd.com>
References: <20071106183645.951275000@amd.com>
User-Agent: quilt/0.46-1
Date: Tue, 06 Nov 2007 19:36:47 +0100
From: "Robert Richter" <robert.richter@amd.com>
To: "Thomas Gleixner" <tglx@linutronix.de>, "Ingo Molnar" <mingo@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, "LKML" <linux-kernel@vger.kernel.org>
cc: "Robert Richter" <robert.richter@amd.com>
Subject: [patch 2/6] x86: apicdef unification: minor changes in macro
 order
X-OriginalArrivalTime: 06 Nov 2007 18:47:57.0886 (UTC)
 FILETIME=[8C7E9DE0:01C820A5]
MIME-Version: 1.0
X-WSS-ID: 6B2E696807S1612539-02-01
Content-Disposition: inline;
 filename="apicdef/0002-apicdef_64.h-minor-changes-in-macro-order.patch"
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Robert Richter <robert.richter@amd.com>
---
 include/asm-x86/apicdef_64.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

Index: linux-perfmon/include/asm-x86/apicdef_64.h
===================================================================
--- linux-perfmon.orig/include/asm-x86/apicdef_64.h
+++ linux-perfmon/include/asm-x86/apicdef_64.h
@@ -116,6 +116,7 @@
 
 #define MAX_IO_APICS 128
 #define MAX_LOCAL_APIC 256
+#define BAD_APICID 0xFFu
 
 /*
  * All x86-64 systems are xAPIC compatible.
@@ -387,6 +388,4 @@ struct local_apic {
 
 #undef u32
 
-#define BAD_APICID 0xFFu
-
 #endif

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com



