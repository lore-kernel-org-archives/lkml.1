Return-Path: <linux-kernel-owner+w=401wt.eu-S1761813AbYELKda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761813AbYELKda (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 06:33:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761404AbYELKc3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 06:32:29 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:51661 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761385AbYELKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 06:32:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references:sender;
        b=q1NYSSg4adBGzDDXzT1yJpKLUnAthDPaLtwpF3ASBSrDt4fZvzIkwwk4Yrv7/ZtN9GP7zz4JHizROOYnN+ARiQcliizEs92C0VhXuOfOgvlG2D92qdFMN9Ck7Ulz1mh7sD8D9BxukZFTXbYKcNIZuhN82ISg/6toW6UQ+CBNlDY=
From: Bryan Wu <cooloney@kernel.org>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, dwmw2@infradead.org
Cc: Vivi Li <vivi.li@analog.com>, Bryan Wu <cooloney@kernel.org>
Subject: [PATCH 4/4] [MM/NOMMU]: Export two symbols in nommu.c for mmap test
Date: Mon, 12 May 2008 18:32:05 +0800
Message-Id: <1210588325-11027-5-git-send-email-cooloney@kernel.org>
X-Mailer: git-send-email 1.5.5
In-Reply-To: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
References: <1210588325-11027-1-git-send-email-cooloney@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vivi Li <vivi.li@analog.com>

http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=2312

Signed-off-by: Vivi Li <vivi.li@analog.com>
Signed-off-by: Bryan Wu <cooloney@kernel.org>
---
 mm/nommu.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 56bb447..cef9d75 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -47,6 +47,8 @@ int heap_stack_gap = 0;
 
 EXPORT_SYMBOL(mem_map);
 EXPORT_SYMBOL(num_physpages);
+EXPORT_SYMBOL(high_memory);
+EXPORT_SYMBOL(max_mapnr);
 
 /* list of shareable VMAs */
 struct rb_root nommu_vma_tree = RB_ROOT;
-- 
1.5.5

