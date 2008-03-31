Return-Path: <linux-kernel-owner+w=401wt.eu-S1756283AbYCaOux@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756283AbYCaOux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:50:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYCaOh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:37:59 -0400
Received: from bzq-179-150-194.static.bezeqint.net ([212.179.150.194]:51306
	"EHLO il.qumranet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752403AbYCaOhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:37:38 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 40/40] KVM: Increase the number of user memory slots per vm
Date: Mon, 31 Mar 2008 17:37:24 +0300
Message-Id: <1206974244-9716-41-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.4.5
In-Reply-To: <1206974244-9716-1-git-send-email-avi@qumranet.com>
References: <1206974244-9716-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm_host.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index f4deb99..eb88d32 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -25,7 +25,7 @@
 #include <asm/kvm_host.h>
 
 #define KVM_MAX_VCPUS 16
-#define KVM_MEMORY_SLOTS 8
+#define KVM_MEMORY_SLOTS 32
 /* memory slots that does not exposed to userspace */
 #define KVM_PRIVATE_MEM_SLOTS 4
 
-- 
1.5.4.5

