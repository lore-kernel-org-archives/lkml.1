Return-Path: <linux-kernel-owner+w=401wt.eu-S1756682AbYLIUcs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756682AbYLIUcs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 15:32:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755424AbYLIUYH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 15:24:07 -0500
Received: from mx2.redhat.com ([66.187.237.31]:34890 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754931AbYLIUXN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 15:23:13 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Eduardo Habkost <ehabkost@redhat.com>
Subject: [PATCH 18/44] KVM: SVM: move svm.h to include/asm
Date: Tue,  9 Dec 2008 22:22:33 +0200
Message-Id: <1228854179-23002-19-git-send-email-avi@redhat.com>
In-Reply-To: <1228854179-23002-1-git-send-email-avi@redhat.com>
References: <1228854179-23002-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eduardo Habkost <ehabkost@redhat.com>

svm.h will be used by core code that is independent of KVM, so I am
moving it outside the arch/x86/kvm directory.

Signed-off-by: Eduardo Habkost <ehabkost@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/{kvm => include/asm}/svm.h |    0
 arch/x86/kvm/kvm_svm.h              |    2 +-
 2 files changed, 1 insertions(+), 1 deletions(-)
 rename arch/x86/{kvm => include/asm}/svm.h (100%)

diff --git a/arch/x86/kvm/svm.h b/arch/x86/include/asm/svm.h
similarity index 100%
rename from arch/x86/kvm/svm.h
rename to arch/x86/include/asm/svm.h
diff --git a/arch/x86/kvm/kvm_svm.h b/arch/x86/kvm/kvm_svm.h
index 65ef0fc..8e5ee99 100644
--- a/arch/x86/kvm/kvm_svm.h
+++ b/arch/x86/kvm/kvm_svm.h
@@ -7,7 +7,7 @@
 #include <linux/kvm_host.h>
 #include <asm/msr.h>
 
-#include "svm.h"
+#include <asm/svm.h>
 
 static const u32 host_save_user_msrs[] = {
 #ifdef CONFIG_X86_64
-- 
1.6.0.3

