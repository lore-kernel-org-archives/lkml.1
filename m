Return-Path: <linux-kernel-owner+w=401wt.eu-S1755596AbYDVHGt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596AbYDVHGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 03:06:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755452AbYDVHGZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 03:06:25 -0400
Received: from fms-01.valinux.co.jp ([210.128.90.1]:52014 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755285AbYDVHGY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 03:06:24 -0400
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: jeremy@goop.org
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org,
       xen-ia64-devel@lists.xensource.com, eddie.dong@intel.com,
       yamahata@valinux.co.jp
Subject: [PATCH 1/3] xen: Move manage.c to drivers/xen for ia64/xen support.
Date: Tue, 22 Apr 2008 16:00:04 +0900
Message-Id: <12088476061989-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12088476062604-git-send-email-yamahata@valinux.co.jp>
References: <12088476062604-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move arch/x86/xen/manage.c under drivers/xen/to share codes
with x86 and ia64.
ia64/xen also uses manage.c

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/Makefile              |    2 +-
 drivers/xen/Makefile               |    2 +-
 {arch/x86 => drivers}/xen/manage.c |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {arch/x86 => drivers}/xen/manage.c (100%)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 3d8df98..40b119b 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
 obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
-			time.o manage.o xen-asm.o grant-table.o
+			time.o xen-asm.o grant-table.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 37af04f..363286c 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y	+= grant-table.o features.o events.o
+obj-y	+= grant-table.o features.o events.o manage.o
 obj-y	+= xenbus/
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
diff --git a/arch/x86/xen/manage.c b/drivers/xen/manage.c
similarity index 100%
rename from arch/x86/xen/manage.c
rename to drivers/xen/manage.c
-- 
1.5.3

