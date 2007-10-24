Return-Path: <linux-kernel-owner+w=401wt.eu-S1760430AbXJXQfp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760430AbXJXQfp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2007 12:35:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756726AbXJXQYT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Oct 2007 12:24:19 -0400
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33407 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757916AbXJXQYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2007 12:24:18 -0400
Date: Wed, 24 Oct 2007 18:24:47 +0200
From: Adrian Bunk <bunk@kernel.org>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] x86/mm/discontig_32.c: make code static
Message-ID: <20071024162447.GP30533@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

node0_bdata and paddr_to_nid() can become static.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

 arch/x86/mm/discontig_32.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

3380c9e430ab49db51bea06835e4b058f573d7b5 
diff --git a/arch/x86/mm/discontig_32.c b/arch/x86/mm/discontig_32.c
index fe608a4..13a474d 100644
--- a/arch/x86/mm/discontig_32.c
+++ b/arch/x86/mm/discontig_32.c
@@ -40,7 +40,7 @@
 
 struct pglist_data *node_data[MAX_NUMNODES] __read_mostly;
 EXPORT_SYMBOL(node_data);
-bootmem_data_t node0_bdata;
+static bootmem_data_t node0_bdata;
 
 /*
  * numa interface - we expect the numa architecture specific code to have
@@ -404,7 +404,7 @@ void __init set_highmem_pages_init(int bad_ppro)
 }
 
 #ifdef CONFIG_MEMORY_HOTPLUG
-int paddr_to_nid(u64 addr)
+static int paddr_to_nid(u64 addr)
 {
 	int nid;
 	unsigned long pfn = PFN_DOWN(addr);

