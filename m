Return-Path: <linux-kernel-owner+w=401wt.eu-S1755563AbXLZLYp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563AbXLZLYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:24:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752662AbXLZLHP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:07:15 -0500
Received: from il.qumranet.com ([82.166.9.18]:50483 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752110AbXLZLGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:10 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Zhang Xiantao <xiantao.zhang@intel.com>
Subject: [PATCH 47/55] KVM: Portability: Move some includes to x86.c
Date: Wed, 26 Dec 2007 13:05:52 +0200
Message-Id: <1198667160-22953-48-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhang Xiantao <xiantao.zhang@intel.com>

Move some includes to x86.c from kvm_main.c, since the related functions
have been moved to x86.c

Signed-off-by: Zhang Xiantao <xiantao.zhang@intel.com>
Acked-by: Carsten Otte <cotte@de.ibm.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/kvm_main.c |    2 --
 drivers/kvm/x86.c      |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/kvm_main.c b/drivers/kvm/kvm_main.c
index 99ad04f..31dafa3 100644
--- a/drivers/kvm/kvm_main.c
+++ b/drivers/kvm/kvm_main.c
@@ -17,7 +17,6 @@
 
 #include "kvm.h"
 #include "x86.h"
-#include "x86_emulate.h"
 #include "irq.h"
 
 #include <linux/kvm.h>
@@ -44,7 +43,6 @@
 #include <linux/mman.h>
 
 #include <asm/processor.h>
-#include <asm/msr.h>
 #include <asm/io.h>
 #include <asm/uaccess.h>
 #include <asm/desc.h>
diff --git a/drivers/kvm/x86.c b/drivers/kvm/x86.c
index 394da66..4282a0f 100644
--- a/drivers/kvm/x86.c
+++ b/drivers/kvm/x86.c
@@ -16,6 +16,7 @@
 
 #include "kvm.h"
 #include "x86.h"
+#include "x86_emulate.h"
 #include "segment_descriptor.h"
 #include "irq.h"
 
@@ -25,6 +26,7 @@
 #include <linux/module.h>
 
 #include <asm/uaccess.h>
+#include <asm/msr.h>
 
 #define MAX_IO_MSRS 256
 #define CR0_RESERVED_BITS						\
-- 
1.5.3.7

