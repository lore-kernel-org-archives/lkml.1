Return-Path: <linux-kernel-owner+w=401wt.eu-S1755947AbZETLaW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755947AbZETLaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 May 2009 07:30:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756756AbZETLUa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 20 May 2009 07:20:30 -0400
Received: from mx2.redhat.com ([66.187.237.31]:55273 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755547AbZETLSt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 May 2009 07:18:49 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org
Subject: [PATCH 29/46] KVM: x86 emulator: Decode soft interrupt instructions
Date: Wed, 20 May 2009 14:18:26 +0300
Message-Id: <1242818323-10413-30-git-send-email-avi@redhat.com>
In-Reply-To: <1242818323-10413-1-git-send-email-avi@redhat.com>
References: <1242818323-10413-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gleb Natapov <gleb@redhat.com>

Do not emulate them yet.

Signed-off-by: Gleb Natapov <gleb@redhat.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index c2f55ca..d2664fc 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -181,7 +181,8 @@ static u32 opcode_table[256] = {
 	0, ImplicitOps | Stack, 0, 0,
 	ByteOp | DstMem | SrcImm | ModRM | Mov, DstMem | SrcImm | ModRM | Mov,
 	/* 0xC8 - 0xCF */
-	0, 0, 0, ImplicitOps | Stack, 0, 0, 0, 0,
+	0, 0, 0, ImplicitOps | Stack,
+	ImplicitOps, SrcImmByte, ImplicitOps, ImplicitOps,
 	/* 0xD0 - 0xD7 */
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
 	ByteOp | DstMem | SrcImplicit | ModRM, DstMem | SrcImplicit | ModRM,
-- 
1.6.0.6

