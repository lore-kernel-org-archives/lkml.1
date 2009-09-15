Return-Path: <linux-kernel-owner+w=401wt.eu-S1758554AbZIOTge@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758554AbZIOTge (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:36:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754991AbZIOTg3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:36:29 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:42102 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbZIOTg3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:36:29 -0400
Date: Tue, 15 Sep 2009 22:36:31 +0300 (EEST)
From: Pekka J Enberg <penberg@cs.helsinki.fi>
To: torvalds@linux-foundation.org
cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
       cl@linux-foundation.org, mingo@elte.hu
Subject: [GIT PULL] SLAB fix for 2.6.32-rc0
Message-ID: <alpine.DEB.2.00.0909152235290.20957@melkki.cs.helsinki.fi>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here's a build breakage fix from Ingo for !CONFIG_SLUB_DEBUG configs.

 			Pekka

The following changes since commit 0cb583fd2862f19ea88b02eb307d11c09e51e2f8:
   Linus Torvalds (1):
         Merge git://git.kernel.org/.../davem/ide-next-2.6

are available in the git repository at:

   ssh://master.kernel.org/pub/scm/linux/kernel/git/penberg/slab-2.6 slab/urgent

Ingo Molnar (1):
       slub: Fix build error in kmem_cache_open() with !CONFIG_SLUB_DEBUG

  mm/slub.c |    2 ++
  1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index a5789b9..0a216aa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1071,6 +1071,8 @@ static inline unsigned long kmem_cache_flags(unsigned long objsize,
  }
  #define slub_debug 0

+#define disable_higher_order_debug 0
+
  static inline unsigned long slabs_node(struct kmem_cache *s, int node)
  							{ return 0; }
  static inline unsigned long node_nr_slabs(struct kmem_cache_node *n)
