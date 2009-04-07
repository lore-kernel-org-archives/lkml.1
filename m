Return-Path: <linux-kernel-owner+w=401wt.eu-S1756665AbZDGPRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756665AbZDGPRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:17:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758785AbZDGPIM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:08:12 -0400
Received: from one.firstfloor.org ([213.235.205.2]:48881 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbZDGPIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:08:09 -0400
From: Andi Kleen <andi@firstfloor.org>
References: <20090407507.636692542@firstfloor.org>
In-Reply-To: <20090407507.636692542@firstfloor.org>
To: seto.hidetoshi@jp.fujitsu.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       mingo@elte.hu, tglx@linutronix.de
Subject: [PATCH] [23/28] x86: MCE: Improve documentation
Message-Id: <20090407150806.76A7E1D0470@basil.firstfloor.org>
Date: Tue,  7 Apr 2009 17:08:06 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Document that check_interval set to 0 means no polling.
Noticed by Hidetoshi Seto

Also add a reference from boot options to the sysfs tunables

Cc: seto.hidetoshi@jp.fujitsu.com

Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 Documentation/x86/x86_64/boot-options.txt |    2 ++
 Documentation/x86/x86_64/machinecheck     |    4 +++-
 2 files changed, 5 insertions(+), 1 deletion(-)

Index: linux/Documentation/x86/x86_64/machinecheck
===================================================================
--- linux.orig/Documentation/x86/x86_64/machinecheck	2009-04-07 16:09:59.000000000 +0200
+++ linux/Documentation/x86/x86_64/machinecheck	2009-04-07 16:09:59.000000000 +0200
@@ -41,7 +41,9 @@
 	the polling interval.  When the poller stops finding MCEs, it
 	triggers an exponential backoff (poll less often) on the polling
 	interval. The check_interval variable is both the initial and
-	maximum polling interval.
+	maximum polling interval. 0 means no polling for corrected machine
+	check errors (but some corrected errors might be still reported
+	in other ways)
 
 tolerant
 	Tolerance level. When a machine check exception occurs for a non
Index: linux/Documentation/x86/x86_64/boot-options.txt
===================================================================
--- linux.orig/Documentation/x86/x86_64/boot-options.txt	2009-04-07 16:09:59.000000000 +0200
+++ linux/Documentation/x86/x86_64/boot-options.txt	2009-04-07 16:09:59.000000000 +0200
@@ -5,6 +5,8 @@
 
 Machine check
 
+   Please see Documentation/x86/x86_64/machinecheck for sysfs runtime tunables.
+
    mce=off disable machine check
    mce=bootlog Enable logging of machine checks left over from booting.
                Disabled by default on AMD because some BIOS leave bogus ones.
