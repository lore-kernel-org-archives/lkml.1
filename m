Return-Path: <linux-kernel-owner+w=401wt.eu-S1758931AbYBBHsK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931AbYBBHsK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Feb 2008 02:48:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbYBBHsB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 2 Feb 2008 02:48:01 -0500
Received: from qb-out-0506.google.com ([72.14.204.239]:59525 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752214AbYBBHsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Feb 2008 02:48:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=GNcTX9nd8mLFYHpzvpBpPqL6CJaVePBVwZxjOJZkONT5Ky5Du+s31/yAVZ1XsYkKC8nkoQ10k3L5L1pnMLijTuSCKMbTivm0U85tmlMZrW9aHKSnYDd6c9XyMn4Y+TfB+MIX2djFmOXH/n9X/QtEixUHmPYaFhUtMODJ9vBSnis=
Subject: [PATCH 2/3] x86: add function prototype to vm86.h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain
Date: Fri, 01 Feb 2008 23:48:05 -0800
Message-Id: <1201938485.1844.6.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Global functions should include their prototypes.

Signed-off-by: Harvey Harrison <harvey.harrison@gmail.com>
---
 include/asm-x86/vm86.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/asm-x86/vm86.h b/include/asm-x86/vm86.h
index a5edf51..b72b9a6 100644
--- a/include/asm-x86/vm86.h
+++ b/include/asm-x86/vm86.h
@@ -195,6 +195,7 @@ struct kernel_vm86_struct {
 
 void handle_vm86_fault(struct kernel_vm86_regs *, long);
 int handle_vm86_trap(struct kernel_vm86_regs *, long, int);
+struct pt_regs * save_v86_state(struct kernel_vm86_regs *);
 
 struct task_struct;
 void release_vm86_irqs(struct task_struct *);
-- 
1.5.4.rc4.1142.gf5a97


