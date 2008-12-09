Return-Path: <linux-kernel-owner+w=401wt.eu-S1755942AbYLIUjk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942AbYLIUjk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:39:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYLIUYn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:43 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34852 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754727AbYLIUXJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:09 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 17/44] KVM: VMX: move vmx.h to include/asm
Date: Tue,  9 Dec 2008 22:22:32 +0200
Message-Id: <1228854179-23002-18-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

vmx.h will be used by core code that is independent of KVM, so I am
moving it outside the arch/x86/kvm directory.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/{kvm => include/asm}/vmx.h |    0
 arch/x86/kvm/mmu.c                  |    2 +-
 arch/x86/kvm/vmx.c                  |    2 +-
 3 files changed, 2 insertions(+), 2 deletions(-)
 rename arch/x86/{kvm => include/asm}/vmx.h (100%)

diff --git a/arch/x86/kvm/vmx.h b/arch/x86/include/asm/vmx.h
similarity index 100%
rename from arch/x86/kvm/vmx.h
rename to arch/x86/include/asm/vmx.h
diff --git a/arch/x86/kvm/mmu.c b/arch/x86/kvm/mmu.c
index 8904e8a..fa3486d 100644
--- a/arch/x86/kvm/mmu.c
+++ b/arch/x86/kvm/mmu.c
@@ -17,7 +17,6 @@
  *
  */
 
-#include "vmx.h"
 #include "mmu.h"
 
 #include <linux/kvm_host.h>
@@ -33,6 +32,7 @@
 #include <asm/page.h>
 #include <asm/cmpxchg.h>
 #include <asm/io.h>
+#include <asm/vmx.h>
 
 /*
  * When setting this variable to true it enables Two-Dimensional-Paging
diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
index 427dbc1..ec71f64 100644
--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -16,7 +16,6 @@
  */
 
 #include "irq.h"
-#include "vmx.h"
 #include "mmu.h"
 
 #include <linux/kvm_host.h>
@@ -31,6 +30,7 @@
 
 #include <asm/io.h>
 #include <asm/desc.h>
+#include <asm/vmx.h>
 
 #define __ex(x) __kvm_handle_fault_on_reboot(x)
 
-- 
1.6.0.3

