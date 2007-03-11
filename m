Return-Path: <linux-kernel-owner+w=401wt.eu-S933580AbXCKNyW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933580AbXCKNyW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 09:54:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933586AbXCKNxe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 09:53:34 -0400
Received: from il.qumranet.com ([82.166.9.18]:43432 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752251AbXCKNxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 09:53:30 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@osdl.org>, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 06/15] KVM: Remove minor wart from KVM_CREATE_VCPU ioctl
Date: Sun, 11 Mar 2007 15:53:18 +0200
Message-Id: <1173621207242-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.0.2
In-Reply-To: <11736212072915-git-send-email-avi@qumranet.com>
References: <11736212072915-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

That ioctl does not transfer any data, so it should be an _IO rather than an
_IOW.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index c6dd4a7..d89189a 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -241,7 +241,7 @@ struct kvm_cpuid {
  * KVM_CREATE_VCPU receives as a parameter the vcpu slot, and returns
  * a vcpu fd.
  */
-#define KVM_CREATE_VCPU           _IOW(KVMIO, 11, int)
+#define KVM_CREATE_VCPU           _IO(KVMIO, 11)
 #define KVM_GET_DIRTY_LOG         _IOW(KVMIO, 12, struct kvm_dirty_log)
 
 /*
-- 
1.5.0.2

