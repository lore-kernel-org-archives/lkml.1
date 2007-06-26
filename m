Return-Path: <linux-kernel-owner+w=401wt.eu-S1755933AbXFZCY5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755933AbXFZCY5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 22:24:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752863AbXFZCYu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 22:24:50 -0400
Received: from ozlabs.org ([203.10.76.45]:57638 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbXFZCYu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 22:24:50 -0400
To: Andrew Morton <akpm@osdl.org>
Cc: <linux-kernel@vger.kernel.org>
Message-Id: <99ba99ee6346de22c83a30b02e142f091fb08f77.1182824567.git.michael@ellerman.id.au>
In-Reply-To: <1182823606.6673.1.camel@concordia.ozlabs.ibm.com>
From: Michael Ellerman <michael@ellerman.id.au>
Subject: [PATCH 1/1] Add a prototype for arch_deref_entry_point()
Date: Tue, 26 Jun 2007 12:24:49 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
---
 include/linux/kprobes.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/kprobes.h b/include/linux/kprobes.h
index bd89285..51464d1 100644
--- a/include/linux/kprobes.h
+++ b/include/linux/kprobes.h
@@ -214,6 +214,7 @@ int longjmp_break_handler(struct kprobe *, struct pt_regs *);
 int register_jprobe(struct jprobe *p);
 void unregister_jprobe(struct jprobe *p);
 void jprobe_return(void);
+unsigned long arch_deref_entry_point(void *);
 
 int register_kretprobe(struct kretprobe *rp);
 void unregister_kretprobe(struct kretprobe *rp);
-- 
1.5.1.3.g7a33b

