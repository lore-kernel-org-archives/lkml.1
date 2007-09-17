Return-Path: <linux-kernel-owner+w=401wt.eu-S1755160AbXIQIe1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755160AbXIQIe1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:34:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753556AbXIQIc1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:27 -0400
Received: from il.qumranet.com ([82.166.9.18]:45244 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752674AbXIQIcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:23 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 005/104] KVM: Trivial: /dev/kvm interface is no longer experimental.
Date: Mon, 17 Sep 2007 10:30:47 +0200
Message-Id: <11900179463777-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

KVM interface is no longer experimental.

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/linux/kvm.h |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/include/linux/kvm.h b/include/linux/kvm.h
index b9a4b7c..68ecced 100644
--- a/include/linux/kvm.h
+++ b/include/linux/kvm.h
@@ -4,8 +4,7 @@
 /*
  * Userspace interface for /dev/kvm - kernel based virtual machine
  *
- * Note: this interface is considered experimental and may change without
- *       notice.
+ * Note: you must update KVM_API_VERSION if you change this interface.
  */
 
 #include <asm/types.h>
-- 
1.5.3

