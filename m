Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753755Ab0BMICa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Feb 2010 03:02:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65248 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752240Ab0BMICD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Feb 2010 03:02:03 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 05/39] KVM: Fix the explanation of write_emulated
Date: Sat, 13 Feb 2010 10:01:25 +0200
Message-Id: <1266048119-14325-6-git-send-email-avi@redhat.com>
In-Reply-To: <1266048119-14325-1-git-send-email-avi@redhat.com>
References: <1266048119-14325-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>

The explanation of write_emulated is confused with
that of read_emulated. This patch fix it.

Signed-off-by: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 arch/x86/include/asm/kvm_emulate.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/include/asm/kvm_emulate.h b/arch/x86/include/asm/kvm_emulate.h
index 7c18e12..9b697c2 100644
--- a/arch/x86/include/asm/kvm_emulate.h
+++ b/arch/x86/include/asm/kvm_emulate.h
@@ -74,7 +74,7 @@ struct x86_emulate_ops {
 			     struct kvm_vcpu *vcpu);
 
 	/*
-	 * write_emulated: Read bytes from emulated/special memory area.
+	 * write_emulated: Write bytes to emulated/special memory area.
 	 *  @addr:  [IN ] Linear address to which to write.
 	 *  @val:   [IN ] Value to write to memory (low-order bytes used as
 	 *                required).
-- 
1.6.5.3

