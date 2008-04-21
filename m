Return-Path: <linux-kernel-owner+w=401wt.eu-S1759909AbYDUIxA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759909AbYDUIxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 04:53:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758811AbYDUIvc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 04:51:32 -0400
Received: from smtp6.pp.htv.fi ([213.243.153.40]:41180 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758799AbYDUIvc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 04:51:32 -0400
Date: Mon, 21 Apr 2008 11:51:03 +0300
From: Adrian Bunk <bunk@kernel.org>
To: Arjan van de Ven <arjan@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make x86/mm/dump_pagetables.c:pt_dump_init() static
Message-ID: <20080421085103.GA26897@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes the needlessly global pt_dump_init() static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
ef2be4c3ac52a07d3f423ab3f3c84c4bf43915a3 diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 6791b83..2c24bea 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -324,7 +324,7 @@ static const struct file_operations ptdump_fops = {
 	.release	= single_release,
 };
 
-int pt_dump_init(void)
+static int pt_dump_init(void)
 {
 	struct dentry *pe;
 

