Return-Path: <linux-kernel-owner+w=401wt.eu-S1756059AbZCEPEj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756059AbZCEPEj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Mar 2009 10:04:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZCEPEa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Mar 2009 10:04:30 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:58014 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753620AbZCEPEa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Mar 2009 10:04:30 -0500
Subject: [PATCH] x86: fix uninitialized variable in init_memory_mapping()
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: mingo@elte.hu
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 05 Mar 2009 17:04:26 +0200
Message-Id: <1236265466.31324.9.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Pekka Enberg <penberg@cs.helsinki.fi>

Impact: compile warning fix

Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
---
 arch/x86/mm/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index f7719b1..244ae9c 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -193,8 +193,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 {
 	unsigned long page_size_mask = 0;
 	unsigned long start_pfn, end_pfn;
+	unsigned long ret = 0;
 	unsigned long pos;
-	unsigned long ret;
 
 	struct map_range mr[NR_RANGE_MR];
 	int nr_range, i;
-- 
1.5.4.3



