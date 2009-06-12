Return-Path: <linux-kernel-owner+w=401wt.eu-S932616AbZFLQan@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932616AbZFLQan (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 12:30:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764624AbZFLQZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 12:25:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:39092 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758932AbZFLQZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 12:25:05 -0400
From: Mike Frysinger <vapier@gentoo.org>
To: linux-kernel@vger.kernel.org
Cc: uclinux-dist-devel@blackfin.uclinux.org
Subject: [PATCH 17/27] Blackfin: convert Kconfig style to def_bool
Date: Fri, 12 Jun 2009 12:24:35 -0400
Message-Id: <1244823885-22410-18-git-send-email-vapier@gentoo.org>
X-Mailer: git-send-email 1.6.3.1
In-Reply-To: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
References: <1244823885-22410-1-git-send-email-vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Makes the file easier to read when there isn't so much clutter.

Signed-off-by: Mike Frysinger <vapier@gentoo.org>
---
 arch/blackfin/Kconfig |   36 ++++++++++++------------------------
 1 files changed, 12 insertions(+), 24 deletions(-)

diff --git a/arch/blackfin/Kconfig b/arch/blackfin/Kconfig
index 74cdcf3..2cf455a 100644
--- a/arch/blackfin/Kconfig
+++ b/arch/blackfin/Kconfig
@@ -6,24 +6,19 @@
 mainmenu "Blackfin Kernel Configuration"
 
 config MMU
-	bool
-	default n
+	def_bool n
 
 config FPU
-	bool
-	default n
+	def_bool n
 
 config RWSEM_GENERIC_SPINLOCK
-	bool
-	default y
+	def_bool y
 
 config RWSEM_XCHGADD_ALGORITHM
-	bool
-	default n
+	def_bool n
 
 config BLACKFIN
-	bool
-	default y
+	def_bool y
 	select HAVE_IDE
 	select HAVE_OPROFILE
 	select ARCH_WANT_OPTIONAL_GPIOLIB
@@ -33,36 +28,29 @@ config GENERIC_BUG
 	depends on BUG
 
 config ZONE_DMA
-	bool
-	default y
+	def_bool y
 
 config GENERIC_FIND_NEXT_BIT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HWEIGHT
-	bool
-	default y
+	def_bool y
 
 config GENERIC_HARDIRQS
-	bool
-	default y
+	def_bool y
 
 config GENERIC_IRQ_PROBE
-	bool
-	default y
+	def_bool y
 
 config GENERIC_GPIO
-	bool
-	default y
+	def_bool y
 
 config FORCE_MAX_ZONEORDER
 	int
 	default "14"
 
 config GENERIC_CALIBRATE_DELAY
-	bool
-	default y
+	def_bool y
 
 source "init/Kconfig"
 
-- 
1.6.3.1

