Return-Path: <linux-kernel-owner+w=401wt.eu-S1760222AbXKNQdi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760222AbXKNQdi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2007 11:33:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756018AbXKNQdb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Nov 2007 11:33:31 -0500
Received: from nic2.axis.se ([193.13.178.10]:49809 "EHLO krynn.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755934AbXKNQda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2007 11:33:30 -0500
Date: Wed, 14 Nov 2007 17:33:22 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Mikael Starvik <mikael.starvik@axis.com>,
       Jesper Nilsson <jesper.nilsson@axis.com>, linux-kernel@vger.kernel.org
Subject: [PATCH] CRIS tlb.h should include linux/pagemap.h
Message-ID: <20071114163322.GM6347@axis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Include linux/pagemap.h for release_pages and page_cache_release.

Fixes compilation error in arch/cris/mm/init.c when CONFIG_SWAP is unset.

Signed-off-by: Jesper Nilsson <jesper.nilsson@axis.com>

---
 tlb.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/asm-cris/tlb.h b/include/asm-cris/tlb.h
index 6cc26de..7724246 100644
--- a/include/asm-cris/tlb.h
+++ b/include/asm-cris/tlb.h
@@ -1,6 +1,8 @@
 #ifndef _CRIS_TLB_H
 #define _CRIS_TLB_H
 
+#include <linux/pagemap.h>
+
 #include <asm/arch/tlb.h>
 
 /*

/^JN - Jesper Nilsson
--
               Jesper Nilsson -- jesper.nilsson@axis.com
