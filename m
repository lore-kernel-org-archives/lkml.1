Return-Path: <linux-kernel-owner+w=401wt.eu-S1756409AbYIYMCT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756409AbYIYMCT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 08:02:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754590AbYIYLz6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 07:55:58 -0400
Received: from mx2.redhat.com ([66.187.237.31]:48573 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754914AbYIYLz4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 07:55:56 -0400
From: Avi Kivity <avi@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: kvm@vger.kernel.org, Avi Kivity <avi@qumranet.com>
Subject: [PATCH 21/39] KVM: x86 emulator: remove bad ByteOp specifier from NEG descriptor
Date: Thu, 25 Sep 2008 14:54:53 +0300
Message-Id: <1222343711-12508-22-git-send-email-avi@redhat.com>
In-Reply-To: <1222343711-12508-1-git-send-email-avi@redhat.com>
References: <1222343711-12508-1-git-send-email-avi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Avi Kivity <avi@qumranet.com>

Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 arch/x86/kvm/x86_emulate.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/kvm/x86_emulate.c b/arch/x86/kvm/x86_emulate.c
index 5d6c144..ae30435 100644
--- a/arch/x86/kvm/x86_emulate.c
+++ b/arch/x86/kvm/x86_emulate.c
@@ -270,7 +270,7 @@ static u16 group_table[] = {
 	0, 0, 0, 0,
 	[Group3*8] =
 	DstMem | SrcImm | ModRM, 0,
-	DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
+	DstMem | SrcNone | ModRM, DstMem | SrcNone | ModRM,
 	0, 0, 0, 0,
 	[Group4*8] =
 	ByteOp | DstMem | SrcNone | ModRM, ByteOp | DstMem | SrcNone | ModRM,
-- 
1.6.0.1

