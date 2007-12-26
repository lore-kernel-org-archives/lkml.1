Return-Path: <linux-kernel-owner+w=401wt.eu-S1753881AbXLZLUQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753881AbXLZLUQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2007 06:20:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752509AbXLZLG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Dec 2007 06:06:59 -0500
Received: from il.qumranet.com ([82.166.9.18]:50465 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751924AbXLZLGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2007 06:06:08 -0500
From: Avi Kivity <avi@qumranet.com>
To: linux-kernel@vger.kernel.org, kvm-devel@lists.sourceforge.net
Cc: Izik Eidus <izike@qumranet.com>
Subject: [PATCH 42/55] KVM: x86 emulator: remove 8 bytes operands emulator for call near instruction
Date: Wed, 26 Dec 2007 13:05:47 +0200
Message-Id: <1198667160-22953-43-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3.7
In-Reply-To: <1198667160-22953-1-git-send-email-avi@qumranet.com>
References: <1198667160-22953-1-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Izik Eidus <izike@qumranet.com>

it is removed beacuse it isnt supported on a real host

Signed-off-by: Izik Eidus <izike@qumranet.com>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/kvm/x86_emulate.c b/drivers/kvm/x86_emulate.c
index 64888a6..e697947 100644
--- a/drivers/kvm/x86_emulate.c
+++ b/drivers/kvm/x86_emulate.c
@@ -1558,9 +1558,6 @@ special_insn:
 		case 4:
 			rel = insn_fetch(s32, 4, c->eip);
 			break;
-		case 8:
-			rel = insn_fetch(s64, 8, c->eip);
-			break;
 		default:
 			DPRINTF("Call: Invalid op_bytes\n");
 			goto cannot_emulate;
-- 
1.5.3.7

