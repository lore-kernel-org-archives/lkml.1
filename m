Return-Path: <linux-kernel-owner+w=401wt.eu-S1754489AbYLHLqY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489AbYLHLqY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Dec 2008 06:46:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753753AbYLHLiN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 8 Dec 2008 06:38:13 -0500
Received: from mx2.redhat.com ([66.187.237.31]:44445 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753487AbYLHLhg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Dec 2008 06:37:36 -0500
From: Avi Kivity <avi@redhat.com>
To: kvm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
       Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Subject: [PATCH 25/45] KVM: x86 emulator: Add decode entries for 0x04 and 0x05 opcodes (add acc, imm)
Date: Mon,  8 Dec 2008 13:36:36 +0200
Message-Id: <1228736216-15787-26-git-send-email-avi@redhat.com>
In-Reply-To: <1228736216-15787-1-git-send-email-avi@redhat.com>
References: <1228736216-15787-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>

Add decode entries for 0x04 and 0x05 (ADD) opcodes, execution is already
implemented.

Signed-off-by: Guillaume Thouvenin <guillaume.thouvenin@ext.bull.net>
Signed-off-by: Avi Kivity <avi@redhat.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index a391e21..57d7cc4 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -80,7 +80,7 @@ static u16 opcode_table[256] = {
 	/* 0x00 - 0x07 */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-	0, 0, 0, 0,
+	ByteOp | DstAcc | SrcImm, DstAcc | SrcImm, 0, 0,
 	/* 0x08 - 0x0F */
 	ByteOp | DstMem | SrcReg | ModRM, DstMem | SrcReg | ModRM,
 	ByteOp | DstReg | SrcMem | ModRM, DstReg | SrcMem | ModRM,
-- 
1.6.0.3

