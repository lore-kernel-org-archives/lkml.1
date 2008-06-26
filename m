Return-Path: <linux-kernel-owner+w=401wt.eu-S1760199AbYFZMn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760199AbYFZMn6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 08:43:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752356AbYFZM3v
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 08:29:51 -0400
Received: from il.qumranet.com ([212.179.150.194]:32383 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbYFZM2j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 08:28:39 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 20/50] KVM: Order segment register constants in the same way as cpu operand encoding
Date: Thu, 26 Jun 2008 15:28:02 +0300
Message-Id: <1214483312-9265-21-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.6
In-Reply-To: <1214483312-9265-1-git-send-email-avi@qumranet.com>
References: <1214483312-9265-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can be used to simplify the x86 instruction decoder.

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 include/asm-x86/kvm_host.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/asm-x86/kvm_host.h b/include/asm-x86/kvm_host.h
index bacb1e2..075598b 100644
--- a/include/asm-x86/kvm_host.h
+++ b/include/asm-x86/kvm_host.h
@@ -109,12 +109,12 @@ enum {
 };
 
 enum {
+	VCPU_SREG_ES,
 	VCPU_SREG_CS,
+	VCPU_SREG_SS,
 	VCPU_SREG_DS,
-	VCPU_SREG_ES,
 	VCPU_SREG_FS,
 	VCPU_SREG_GS,
-	VCPU_SREG_SS,
 	VCPU_SREG_TR,
 	VCPU_SREG_LDTR,
 };
-- 
1.5.6

