Return-Path: <linux-kernel-owner+w=401wt.eu-S1753208AbZGDWay@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208AbZGDWay (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 18:30:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752483AbZGDWap
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 18:30:45 -0400
Received: from liberdade.minaslivre.org ([72.232.18.203]:42697 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbZGDWao (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 18:30:44 -0400
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: skuribay@ruby.dti.ne.jp
Cc: trivial@kernel.org, ralf@linux-mips.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH 1/3] Trivial: Fix filenames in their headers for the EMMA Mark-eins.
Date: Sat,  4 Jul 2009 19:30:21 -0300
Message-Id: <1246746621-10320-1-git-send-email-cascardo@holoscopio.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After some renaming, these filenames were not updated to reflect their
new locations.

Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
---
 arch/mips/emma/common/Makefile        |    2 +-
 arch/mips/emma/common/prom.c          |    2 +-
 arch/mips/emma/markeins/Makefile      |    2 +-
 arch/mips/emma/markeins/irq.c         |    2 +-
 arch/mips/emma/markeins/led.c         |    2 +-
 arch/mips/emma/markeins/platform.c    |    2 +-
 arch/mips/emma/markeins/setup.c       |    2 +-
 arch/mips/include/asm/emma/markeins.h |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/arch/mips/emma/common/Makefile b/arch/mips/emma/common/Makefile
index c392d28..faf73c3 100644
--- a/arch/mips/emma/common/Makefile
+++ b/arch/mips/emma/common/Makefile
@@ -1,5 +1,5 @@
 #
-#  arch/mips/emma2rh/common/Makefile
+#  arch/mips/emma/common/Makefile
 #       Makefile for the common code of NEC EMMA2RH based board.
 #
 #  Copyright (C) NEC Electronics Corporation 2005-2006
diff --git a/arch/mips/emma/common/prom.c b/arch/mips/emma/common/prom.c
index 120f53f..867b1cc 100644
--- a/arch/mips/emma/common/prom.c
+++ b/arch/mips/emma/common/prom.c
@@ -1,5 +1,5 @@
 /*
- *  arch/mips/emma2rh/common/prom.c
+ *  arch/mips/emma/common/prom.c
  *      This file is prom file.
  *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
diff --git a/arch/mips/emma/markeins/Makefile b/arch/mips/emma/markeins/Makefile
index 16e0017..1870f50 100644
--- a/arch/mips/emma/markeins/Makefile
+++ b/arch/mips/emma/markeins/Makefile
@@ -1,5 +1,5 @@
 #
-#  arch/mips/emma2rh/markeins/Makefile
+#  arch/mips/emma/markeins/Makefile
 #       Makefile for the common code of NEC EMMA2RH based board.
 #
 #  Copyright (C) NEC Electronics Corporation 2005-2006
diff --git a/arch/mips/emma/markeins/irq.c b/arch/mips/emma/markeins/irq.c
index 43828ae..4dc5d45 100644
--- a/arch/mips/emma/markeins/irq.c
+++ b/arch/mips/emma/markeins/irq.c
@@ -1,5 +1,5 @@
 /*
- *  arch/mips/emma2rh/markeins/irq.c
+ *  arch/mips/emma/markeins/irq.c
  *      This file defines the irq handler for EMMA2RH.
  *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
diff --git a/arch/mips/emma/markeins/led.c b/arch/mips/emma/markeins/led.c
index 377a181..1a40ce4 100644
--- a/arch/mips/emma/markeins/led.c
+++ b/arch/mips/emma/markeins/led.c
@@ -1,5 +1,5 @@
 /*
- *  arch/mips/emma2rh/markeins/led.c
+ *  arch/mips/emma/markeins/led.c
  *      This file defines the led display for Mark-eins.
  *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
diff --git a/arch/mips/emma/markeins/platform.c b/arch/mips/emma/markeins/platform.c
index 80ae12e..4399697 100644
--- a/arch/mips/emma/markeins/platform.c
+++ b/arch/mips/emma/markeins/platform.c
@@ -1,5 +1,5 @@
 /*
- *  arch/mips/emma2rh/markeins/platofrm.c
+ *  arch/mips/emma/markeins/platform.c
  *      This file sets up platform devices for EMMA2RH Mark-eins.
  *
  *  Copyright(C) MontaVista Software Inc, 2006
diff --git a/arch/mips/emma/markeins/setup.c b/arch/mips/emma/markeins/setup.c
index 67f4565..e4fdb72 100644
--- a/arch/mips/emma/markeins/setup.c
+++ b/arch/mips/emma/markeins/setup.c
@@ -1,5 +1,5 @@
 /*
- *  arch/mips/emma2rh/markeins/setup.c
+ *  arch/mips/emma/markeins/setup.c
  *      This file is setup for EMMA2RH Mark-eins.
  *
  *  Copyright (C) NEC Electronics Corporation 2004-2006
diff --git a/arch/mips/include/asm/emma/markeins.h b/arch/mips/include/asm/emma/markeins.h
index 973b062..f730c7a 100644
--- a/arch/mips/include/asm/emma/markeins.h
+++ b/arch/mips/include/asm/emma/markeins.h
@@ -1,5 +1,5 @@
 /*
- *  include/asm-mips/emma2rh/markeins.h
+ *  arch/mips/include/asm/emma/markeins.h
  *      This file is EMMA2RH board depended header.
  *
  *  Copyright (C) NEC Electronics Corporation 2005-2006
-- 
1.6.3

