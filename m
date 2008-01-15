Return-Path: <linux-kernel-owner+w=401wt.eu-S1759000AbYAOWVS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000AbYAOWVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:21:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753323AbYAOWVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:21:06 -0500
Received: from outbound-sin.frontbridge.com ([207.46.51.80]:15966 "EHLO
	outbound6-sin-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752366AbYAOWVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:21:04 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.66.75;Service: EHS
Subject: [PATCH 2/4] RT: remove conflicting rtc_lock declaration
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:19:55 -0800
Message-Id: <1200435595.4092.17.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:20:55.0363 (UTC) FILETIME=[E5616130:01C857C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

Declaration of rtc_lock in arch/mips/kernel/time.c conflicts with time.h,
remove from include/asm-mips/time.h.

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 include/asm-mips/time.h |    2 	0 +	2 -	0 !
 1 files changed, 2 deletions(-)

Index: linux-2.6.24-rc7/include/asm-mips/time.h
===================================================================
--- linux-2.6.24-rc7.orig/include/asm-mips/time.h
+++ linux-2.6.24-rc7/include/asm-mips/time.h
@@ -19,8 +19,6 @@
 #include <linux/clockchips.h>
 #include <linux/clocksource.h>
 
-extern raw_spinlock_t rtc_lock;
-
 /*
  * RTC ops.  By default, they point to weak no-op RTC functions.
  *	rtc_mips_set_time - reverse the above translation and set time to RTC.



