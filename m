Return-Path: <linux-kernel-owner+w=401wt.eu-S965355AbXA3NX2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965355AbXA3NX2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 08:23:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965362AbXA3NX2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 08:23:28 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:41142 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965355AbXA3NX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 08:23:27 -0500
To: torvalds@linux-foundation.org
Subject: [PATCH] missing exports of pm_power_off() on alpha and sparc32
Cc: linux-kernel@vger.kernel.org
Message-Id: <E1HBsxJ-0002M4-U3@ZenIV.linux.org.uk>
From: Al Viro <viro@ftp.linux.org.uk>
Date: Tue, 30 Jan 2007 13:23:25 +0000
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
---
 arch/alpha/kernel/process.c |    1 +
 arch/sparc/kernel/process.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/alpha/kernel/process.c b/arch/alpha/kernel/process.c
index 3370e6f..c151863 100644
--- a/arch/alpha/kernel/process.c
+++ b/arch/alpha/kernel/process.c
@@ -47,6 +47,7 @@
  * Power off function, if any
  */
 void (*pm_power_off)(void) = machine_power_off;
+EXPORT_SYMBOL(pm_power_off);
 
 void
 cpu_idle(void)
diff --git a/arch/sparc/kernel/process.c b/arch/sparc/kernel/process.c
index 89a28cc..113bd48 100644
--- a/arch/sparc/kernel/process.c
+++ b/arch/sparc/kernel/process.c
@@ -54,6 +54,7 @@ void (*pm_idle)(void);
  * handler when auxio is not present-- unused for now...
  */
 void (*pm_power_off)(void) = machine_power_off;
+EXPORT_SYMBOL(pm_power_off);
 
 /*
  * sysctl - toggle power-off restriction for serial console 
-- 
1.5.0-rc2.GIT


