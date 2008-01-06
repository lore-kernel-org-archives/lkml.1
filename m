Return-Path: <linux-kernel-owner+w=401wt.eu-S1760027AbYAFOqy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760027AbYAFOqy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2008 09:46:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758461AbYAFOkI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Jan 2008 09:40:08 -0500
Received: from il.qumranet.com ([82.166.9.18]:46647 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755872AbYAFOjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2008 09:39:47 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Subject: [PATCH 16/33] KVM: Move drivers/kvm/* to virt/kvm/
Date: Sun,  6 Jan 2008 16:39:22 +0200
Message-Id: <1199630379-28638-17-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1199630379-28638-1-git-send-email-avi@qumranet.com>
References: <1199630379-28638-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/Makefile            |    4 ++--
 {drivers => virt}/kvm/iodev.h    |    0 
 {drivers => virt}/kvm/kvm_main.c |    0 
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename {drivers => virt}/kvm/iodev.h (100%)
 rename {drivers => virt}/kvm/kvm_main.c (100%)

diff --git a/arch/x86/kvm/Makefile b/arch/x86/kvm/Makefile
index 880ffe4..af41534 100644
--- a/arch/x86/kvm/Makefile
+++ b/arch/x86/kvm/Makefile
@@ -2,9 +2,9 @@
 # Makefile for Kernel-based Virtual Machine module
 #
 
-common-objs = $(addprefix ../../../drivers/kvm/, kvm_main.o)
+common-objs = $(addprefix ../../../virt/kvm/, kvm_main.o)
 
-EXTRA_CFLAGS += -I drivers/kvm
+EXTRA_CFLAGS += -I virt/kvm
 
 kvm-objs := $(common-objs) x86.o mmu.o x86_emulate.o i8259.o irq.o lapic.o \
 	ioapic.o
diff --git a/drivers/kvm/iodev.h b/virt/kvm/iodev.h
similarity index 100%
rename from drivers/kvm/iodev.h
rename to virt/kvm/iodev.h
diff --git a/drivers/kvm/kvm_main.c b/virt/kvm/kvm_main.c
similarity index 100%
rename from drivers/kvm/kvm_main.c
rename to virt/kvm/kvm_main.c
-- 
1.5.3.7

