Return-Path: <linux-kernel-owner+w=401wt.eu-S1757927AbYCKVKb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757927AbYCKVKb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 17:10:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754036AbYCKVKU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 17:10:20 -0400
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:45048 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753218AbYCKVKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 17:10:18 -0400
Date: Tue, 11 Mar 2008 21:08:41 +0000 (GMT)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: Andrew Morton <akpm@linux-foundation.org>
cc: David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org
Subject: [PATCH rc5-mm1] shmem mpol: fix build warning
Message-ID: <Pine.LNX.4.64.0803112106290.17067@blonde.site>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix #ifndef CONFIG_NUMA build warning on shmem_parse_mpol
arising from mempolicy-support-optional-mode-flags.patch

Signed-off-by: Hugh Dickins <hugh@veritas.com>
---

 mm/shmem.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- 2.6.25-rc5-mm1/mm/shmem.c	2008-03-11 14:19:36.000000000 +0000
+++ linux/mm/shmem.c	2008-03-11 16:45:37.000000000 +0000
@@ -1215,7 +1215,7 @@ static struct page *shmem_alloc_page(gfp
 #else /* !CONFIG_NUMA */
 #ifdef CONFIG_TMPFS
 static inline int shmem_parse_mpol(char *value, unsigned short *policy,
-				unsigned short flags, nodemask_t *policy_nodes)
+			unsigned short *mode_flags, nodemask_t *policy_nodes)
 {
 	return 1;
 }
