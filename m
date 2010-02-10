Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0BJR1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Feb 2010 12:27:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:45837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755714Ab0BJRXO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Feb 2010 12:23:14 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 37/40] KVM: Bump maximum vcpu count to 64
Date: Wed, 10 Feb 2010 19:23:06 +0200
Message-Id: <1265822589-11155-38-git-send-email-avi@redhat.com>
In-Reply-To: <1265822589-11155-1-git-send-email-avi@redhat.com>
References: <1265822589-11155-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With slots_lock converted to rcu, the entire kvm hotpath on modern processors
(with npt or ept) now scales beautifully.  Increase the maximum vcpu count to
64 to reflect this.

Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_host.h b/arch/x86/include/asm/kvm_host.h
index 6c8c7c5..741b897 100644
--- a/arch/x86/include/asm/kvm_host.h
+++ b/arch/x86/include/asm/kvm_host.h
@@ -25,7 +25,7 @@
 #include <asm/mtrr.h>
 #include <asm/msr-index.h>
 
-#define KVM_MAX_VCPUS 16
+#define KVM_MAX_VCPUS 64
 #define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
-- 
1.6.5.3

