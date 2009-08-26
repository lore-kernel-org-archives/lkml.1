Return-Path: <linux-kernel-owner+w=401wt.eu-S1757251AbZHZKiF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251AbZHZKiF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Aug 2009 06:38:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757137AbZHZKd1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Aug 2009 06:33:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757127AbZHZKaO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Aug 2009 06:30:14 -0400
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 42/47] KVM: Add missing #include
Date: Wed, 26 Aug 2009 13:30:04 +0300
Message-Id: <1251282609-12835-43-git-send-email-avi@redhat.com>
In-Reply-To: <1251282609-12835-1-git-send-email-avi@redhat.com>
References: <1251282609-12835-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/kvm_para.h |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/kvm_para.h b/arch/x86/include/asm/kvm_para.h
index b8a3305..c584076 100644
--- a/arch/x86/include/asm/kvm_para.h
+++ b/arch/x86/include/asm/kvm_para.h
@@ -1,6 +1,8 @@
 #ifndef _ASM_X86_KVM_PARA_H
 #define _ASM_X86_KVM_PARA_H
 
+#include <linux/types.h>
+
 /* This CPUID returns the signature 'KVMKVMKVM' in ebx, ecx, and edx.  It
  * should be used to determine that a VM is running under KVM.
  */
-- 
1.6.4.1

