Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab0BPKoq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Feb 2010 05:44:46 -0500
Received: from mx1.redhat.com ([209.132.183.28]:18400 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932780Ab0BPKfj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Feb 2010 05:35:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 01/38] KVM: export <asm/hyperv.h>
Date: Tue, 16 Feb 2010 12:34:59 +0200
Message-Id: <1266316536-28936-2-git-send-email-avi@redhat.com>
In-Reply-To: <1266316536-28936-1-git-send-email-avi@redhat.com>
References: <1266316536-28936-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Needed by <asm/kvm_para.h>.

Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/include/asm/Kbuild |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 9f828f8..493092e 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -11,6 +11,7 @@ header-y += sigcontext32.h
 header-y += ucontext.h
 header-y += processor-flags.h
 header-y += hw_breakpoint.h
+header-y += hyperv.h
 
 unifdef-y += e820.h
 unifdef-y += ist.h
-- 
1.6.5.3

