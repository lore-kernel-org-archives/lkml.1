Return-Path: <linux-kernel-owner+w=401wt.eu-S933147AbYBVFLM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933147AbYBVFLM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 00:11:12 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753283AbYBVFH7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 00:07:59 -0500
Received: from fms-01.valinux.co.jp ([210.128.90.1]:35780 "EHLO
	mail.valinux.co.jp" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750991AbYBVFHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 00:07:51 -0500
From: Isaku Yamahata <yamahata@valinux.co.jp>
To: linux-kernel@vger.kernel.org
Cc: linux-ia64@vger.kernel.org, yamahata@valinux.co.jp
Subject: [PATCH 05/11] xen: move features.c from arch/x86/xen/features.c to drivers/xen.
Date: Fri, 22 Feb 2008 14:07:42 +0900
Message-Id: <12036568693679-git-send-email-yamahata@valinux.co.jp>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <12036568683779-git-send-email-yamahata@valinux.co.jp>
References: <12036568683779-git-send-email-yamahata@valinux.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ia64/xen also uses it too, so move it into common place.

Signed-off-by: Isaku Yamahata <yamahata@valinux.co.jp>
---
 arch/x86/xen/Makefile                |    2 +-
 drivers/xen/Makefile                 |    2 +-
 {arch/x86 => drivers}/xen/features.c |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {arch/x86 => drivers}/xen/features.c (100%)

diff --git a/arch/x86/xen/Makefile b/arch/x86/xen/Makefile
index 343df24..c5e9aa4 100644
--- a/arch/x86/xen/Makefile
+++ b/arch/x86/xen/Makefile
@@ -1,4 +1,4 @@
-obj-y		:= enlighten.o setup.o features.o multicalls.o mmu.o \
+obj-y		:= enlighten.o setup.o multicalls.o mmu.o \
 			events.o time.o manage.o xen-asm.o
 
 obj-$(CONFIG_SMP)	+= smp.o
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index 56592f0..609fdda 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,2 +1,2 @@
-obj-y	+= grant-table.o
+obj-y	+= grant-table.o features.o
 obj-y	+= xenbus/
diff --git a/arch/x86/xen/features.c b/drivers/xen/features.c
similarity index 100%
rename from arch/x86/xen/features.c
rename to drivers/xen/features.c
-- 
1.5.3

