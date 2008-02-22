Return-Path: <linux-kernel-owner+w=401wt.eu-S933558AbYBVUDb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933558AbYBVUDb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2008 15:03:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932139AbYBVT73
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 Feb 2008 14:59:29 -0500
Received: from smtp4.pp.htv.fi ([213.243.153.38]:44821 "EHLO smtp4.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1765993AbYBVT70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2008 14:59:26 -0500
Date: Fri, 22 Feb 2008 21:58:37 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86: don't make swapper_pg_pmd global
Message-ID: <20080222195837.GI1409@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There doesn't seem to be any reason for swapper_pg_pmd being global.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
f07e9bb8705fc9b1b1d7d00883764f993cb09a4b diff --git a/arch/x86/kernel/head_32.S b/arch/x86/kernel/head_32.S
index 25eb985..fd8ca53 100644
--- a/arch/x86/kernel/head_32.S
+++ b/arch/x86/kernel/head_32.S
@@ -606,7 +606,7 @@ ENTRY(_stext)
 .section ".bss.page_aligned","wa"
 	.align PAGE_SIZE_asm
 #ifdef CONFIG_X86_PAE
-ENTRY(swapper_pg_pmd)
+swapper_pg_pmd:
 	.fill 1024*KPMDS,4,0
 #else
 ENTRY(swapper_pg_dir)

