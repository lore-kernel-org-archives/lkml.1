Return-Path: <linux-kernel-owner+w=401wt.eu-S965535AbXA3OqG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965535AbXA3OqG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 09:46:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965542AbXA3OqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 09:46:06 -0500
Received: from il.qumranet.com ([62.219.232.206]:52791 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965535AbXA3OqB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 09:46:01 -0500
Subject: [PATCH 10/11] KVM: Fix mismatch between 32-bit and 64-bit abi
From: Avi Kivity <avi@qumranet.com>
Date: Tue, 30 Jan 2007 14:46:00 -0000
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, mingo@elte.hu
References: <45BF57C9.7000103@qumranet.com>
In-Reply-To: <45BF57C9.7000103@qumranet.com>
Message-Id: <20070130144600.451A4A0014@il.qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately requiring a version bump.

Signed-off-by: Avi Kivity <avi@qumranet.com>

Index: linux-2.6/include/linux/kvm.h
===================================================================
--- linux-2.6.orig/include/linux/kvm.h
+++ linux-2.6/include/linux/kvm.h
@@ -11,7 +11,7 @@
 #include <asm/types.h>
 #include <linux/ioctl.h>
 
-#define KVM_API_VERSION 2
+#define KVM_API_VERSION 3
 
 /*
  * Architectural interrupt line count, and the size of the bitmap needed
@@ -187,6 +187,7 @@ struct kvm_translation {
 	__u8  valid;
 	__u8  writeable;
 	__u8  usermode;
+	__u8  pad[5];
 };
 
 /* for KVM_INTERRUPT */
