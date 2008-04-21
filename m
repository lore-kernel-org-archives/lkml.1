Return-Path: <linux-kernel-owner+w=401wt.eu-S1755479AbYDUIs3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479AbYDUIs3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:48:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754145AbYDUIsQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:48:16 -0400
Received: from smtp4.pp.htv.fi ([213.243.153.38]:34686 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980AbYDUIsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:48:15 -0400
Date: Mon, 21 Apr 2008 11:47:46 +0300
From: Adrian Bunk <bunk@kernel.org>
To: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: remove Xgt_desc_struct
Message-ID: <20080421084746.GG26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comment says it should have been removed in 2.6.25.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
e6db8b4f8a66ea73d82efe0abb884530b34c5df4 diff --git a/include/asm-x86/processor.h b/include/asm-x86/processor.h
index 6e26c7c..c4a8d99 100644
--- a/include/asm-x86/processor.h
+++ b/include/asm-x86/processor.h
@@ -3,9 +3,6 @@
 
 #include <asm/processor-flags.h>
 
-/* migration helper, for KVM - will be removed in 2.6.25: */
-#define Xgt_desc_struct	desc_ptr
-
 /* Forward declaration, a strange C thing */
 struct task_struct;
 struct mm_struct;

