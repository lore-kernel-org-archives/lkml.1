Return-Path: <linux-kernel-owner+w=401wt.eu-S1753941AbXFDJh3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941AbXFDJh3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 05:37:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752597AbXFDJhX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 05:37:23 -0400
Received: from hellhawk.shadowen.org ([80.68.90.175]:4207 "EHLO
	hellhawk.shadowen.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752593AbXFDJhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 05:37:22 -0400
From: Andy Whitcroft <apw@shadowen.org>
To: Andrew Morton <akpm@osdl.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, Joel Schopp <jschopp@austin.ibm.com>,
       Andy Whitcroft <apw@shadowen.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] update feature-removal-schedule.txt to include deprecated functions
References: <0a25fd03117c678f17006c5fcefaaed0@pinky>
InReply-To: <0a25fd03117c678f17006c5fcefaaed0@pinky>
Message-ID: <9dc34d13d99565d2aa2f56c5d112e788@pinky>
Date: Mon, 04 Jun 2007 10:55:56 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Now that deprecated functions are detected out of
Documentation/feature-removal-schedule.txt update this to include
kernel_thread.

Signed-off-by: Andy Whitcroft <apw@shadowen.org>
---

	This was missed from the update to checkpatch.pl version
	0.03 patch, and probabally should be folded into there.
---
diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index e88baca..bc366cb 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -87,6 +87,7 @@ Who:	Mauro Carvalho Chehab <mchehab@brturbo.com.br>
 What:	remove EXPORT_SYMBOL(kernel_thread)
 When:	August 2006
 Files:	arch/*/kernel/*_ksyms.c
+Funcs:	kernel_thread
 Why:	kernel_thread is a low-level implementation detail.  Drivers should
         use the <linux/kthread.h> API instead which shields them from
 	implementation details and provides a higherlevel interface that
