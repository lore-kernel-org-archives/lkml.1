Return-Path: <linux-kernel-owner+w=401wt.eu-S1755543AbYJDWxG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543AbYJDWxG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 18:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754077AbYJDWwz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 18:52:55 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:32444 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753860AbYJDWwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 18:52:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ORoqrA7JqwLkZ2xGIadb3x/hM2XnGIGsFvfccLQr3LNCFDd4YSYNSt8CemsGgZdVBZ
         u2kS+crk4QJnv+Y21gu0FnEWtHsa9YlWmCFTwI3WjmWKY3NfVz2oHZFziNSj9T/NCFQc
         LbxQ+y1fDABcvoPI2yKEigq8fANg0KRYRN8QE=
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yhlu.kernel@gmail.com>
Subject: [PATCH] x86: sparse_irq: fix typo in debug print out
Date: Sat,  4 Oct 2008 15:52:15 -0700
Message-Id: <1223160735-4782-1-git-send-email-yhlu.kernel@gmail.com>
X-Mailer: git-send-email 1.5.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yinghai Lu <yhlu.kernel@gmail.com>
---
 arch/x86/kernel/io_apic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/arch/x86/kernel/io_apic.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/io_apic.c
+++ linux-2.6/arch/x86/kernel/io_apic.c
@@ -257,7 +257,7 @@ static struct irq_cfg *irq_cfg_alloc(uns
 			panic("please boot with nr_irq_cfg= %d\n", count * 2);
 
 		phys = __pa(cfg);
-		printk(KERN_DEBUG "irq_irq ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
+		printk(KERN_DEBUG "irq_cfg ==> [%#lx - %#lx]\n", phys, phys + total_bytes);
 
 		for (i = 0; i < nr_irq_cfg; i++)
 			init_one_irq_cfg(&cfg[i]);
