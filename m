Return-Path: <linux-kernel-owner+w=401wt.eu-S1755326AbXIQIez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755326AbXIQIez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 04:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753843AbXIQIc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 04:32:29 -0400
Received: from il.qumranet.com ([82.166.9.18]:45245 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752724AbXIQIcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 04:32:23 -0400
From: Avi Kivity <avi@qumranet.com>
To: kvm-devel@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>
Subject: [PATCH 006/104] KVM: Trivial: Remove unused struct cpu_user_regs declaration
Date: Mon, 17 Sep 2007 10:30:48 +0200
Message-Id: <1190017946666-git-send-email-avi@qumranet.com>
X-Mailer: git-send-email 1.5.3
In-Reply-To: <11900179463203-git-send-email-avi@qumranet.com>
References: <11900179463203-git-send-email-avi@qumranet.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>

Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Avi Kivity <avi@qumranet.com>
---
 drivers/kvm/x86_emulate.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/kvm/x86_emulate.h b/drivers/kvm/x86_emulate.h
index ea3407d..2847d67 100644
--- a/drivers/kvm/x86_emulate.h
+++ b/drivers/kvm/x86_emulate.h
@@ -112,8 +112,6 @@ struct x86_emulate_ops {
 
 };
 
-struct cpu_user_regs;
-
 struct x86_emulate_ctxt {
 	/* Register state before/after emulation. */
 	struct kvm_vcpu *vcpu;
-- 
1.5.3

