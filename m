Return-Path: <linux-kernel-owner+w=401wt.eu-S1759106AbYAOWUK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759106AbYAOWUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 17:20:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758906AbYAOWTy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 17:19:54 -0500
Received: from mail-dub.bigfish.com ([213.199.154.10]:58894 "EHLO
	mail6-dub-R.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756474AbYAOWTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 17:19:53 -0500
X-BigFish: V
X-MS-Exchange-Organization-Antispam-Report: OrigIP: 160.33.98.75;Service: EHS
Subject: [PATCH 1/4] RT: remove duplicate time/Kconfig
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
To: linux-kernel@vger.kernel.org
Cc: mingo@redhat.com, tglx@linutronix.de
Content-Type: text/plain
Date: Tue, 15 Jan 2008 14:18:45 -0800
Message-Id: <1200435525.4092.14.camel@bx740>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 (2.12.1-3.fc8) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 15 Jan 2008 22:19:44.0926 (UTC) FILETIME=[BB658BE0:01C857C4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frank Rowand <frank.rowand@am.sony.com>

time/Kconfig added by preempt-realtime-mips.patch duplicates other entry,
resulting in kernel make error:

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>
---
 arch/mips/Kconfig |    2 	0 +	2 -	0 !
 1 files changed, 2 deletions(-)

Index: linux-2.6.24-rc7/arch/mips/Kconfig
===================================================================
--- linux-2.6.24-rc7.orig/arch/mips/Kconfig
+++ linux-2.6.24-rc7/arch/mips/Kconfig
@@ -1775,8 +1775,6 @@ config NR_CPUS
 	  performance should round up your number of processors to the next
 	  power of two.
 
-source "kernel/time/Kconfig"
-
 #
 # Timer Interrupt Frequency Configuration
 #



