Return-Path: <linux-kernel-owner+w=401wt.eu-S1752908AbZDMS7s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908AbZDMS7s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Apr 2009 14:59:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751467AbZDMS7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 13 Apr 2009 14:59:39 -0400
Received: from 178-47-31-89.wifiinternet.cz ([89.31.47.178]:39644 "EHLO
	monstr.eu" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbZDMS7i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Apr 2009 14:59:38 -0400
From: monstr@monstr.eu
To: jeff@garzik.org
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org,
       Michal Simek <monstr@monstr.eu>
Subject: [PATCH 1/1] microblaze: Fix problem with removing zero length files
Date: Mon, 13 Apr 2009 20:56:57 +0200
Message-Id: <1239649017-5850-1-git-send-email-monstr@monstr.eu>
X-Mailer: git-send-email 1.5.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michal Simek <monstr@monstr.eu>

Adding one new line was recommended solution.
Test with make distclean

Signed-off-by: Michal Simek <monstr@monstr.eu>
---
 arch/microblaze/include/asm/auxvec.h   |    1 +
 arch/microblaze/include/asm/cputable.h |    1 +
 arch/microblaze/include/asm/hw_irq.h   |    1 +
 arch/microblaze/include/asm/user.h     |    1 +
 arch/microblaze/include/asm/vga.h      |    1 +
 5 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/microblaze/include/asm/auxvec.h b/arch/microblaze/include/asm/auxvec.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/auxvec.h
+++ b/arch/microblaze/include/asm/auxvec.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/cputable.h b/arch/microblaze/include/asm/cputable.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/cputable.h
+++ b/arch/microblaze/include/asm/cputable.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/hw_irq.h b/arch/microblaze/include/asm/hw_irq.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/hw_irq.h
+++ b/arch/microblaze/include/asm/hw_irq.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/user.h b/arch/microblaze/include/asm/user.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/user.h
+++ b/arch/microblaze/include/asm/user.h
@@ -0,0 +1 @@
+
diff --git a/arch/microblaze/include/asm/vga.h b/arch/microblaze/include/asm/vga.h
index e69de29..8b13789 100644
--- a/arch/microblaze/include/asm/vga.h
+++ b/arch/microblaze/include/asm/vga.h
@@ -0,0 +1 @@
+
-- 
1.5.5.1

