Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934279Ab0BQNrz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Feb 2010 08:47:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32279 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934174Ab0BQNpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Feb 2010 08:45:39 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 19/20] KVM: x86 emulator: code style cleanup
Date: Wed, 17 Feb 2010 15:45:29 +0200
Message-Id: <1266414330-27444-20-git-send-email-avi@redhat.com>
In-Reply-To: <1266414330-27444-1-git-send-email-avi@redhat.com>
References: <1266414330-27444-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wei Yongjun <yjwei@cn.fujitsu.com>

Just remove redundant semicolon.

Signed-off-by: Wei Yongjun <yjwei@cn.fujitsu.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/emulate.c b/arch/x86/kvm/emulate.c
index c2de9f0..dd1b935 100644
--- a/arch/x86/kvm/emulate.c
+++ b/arch/x86/kvm/emulate.c
@@ -1016,7 +1016,7 @@ done_prefixes:
 	}
 
 	if (mode == X86EMUL_MODE_PROT64 && (c->d & No64)) {
-		kvm_report_emulation_failure(ctxt->vcpu, "invalid x86/64 instruction");;
+		kvm_report_emulation_failure(ctxt->vcpu, "invalid x86/64 instruction");
 		return -1;
 	}
 
-- 
1.6.5.3

