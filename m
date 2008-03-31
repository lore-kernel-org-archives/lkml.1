Return-Path: <linux-kernel-owner+w=401wt.eu-S1757238AbYCaOuj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757238AbYCaOuj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:50:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753536AbYCaOh6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:58 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51320
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274AbYCaOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 39/40] KVM: Add API for determining the number of supported memory slots
Date: Mon, 31 Mar 2008 17:37:23 +0300
Message-Id: <1206974244-9716-40-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86.c  |    3 +++
 include/linux/kvm.h |    1 +
 2 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 955d2ee..b7c32f6 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -814,6 +814,9 @@ int kvm_dev_ioctl_check_extension(long ext)
 	case KVM_CAP_NR_VCPUS:
 		r = KVM_MAX_VCPUS;
 		break;
+	case KVM_CAP_NR_MEMSLOTS:
+		r = KVM_MEMORY_SLOTS;
+		break;
 	default:
 		r = 0;
 		break;
diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index deb9c38..e92e703 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -235,6 +235,7 @@ struct kvm_vapic_addr {
 #define KVM_CAP_EXT_CPUID 7
 #define KVM_CAP_CLOCKSOURCE 8
 #define KVM_CAP_NR_VCPUS 9       /* returns max vcpus per vm */
+#define KVM_CAP_NR_MEMSLOTS 10   /* returns max memory slots per vm */
 
 /*
  * ioctls for VM fds
-- 
1.5.4.5

