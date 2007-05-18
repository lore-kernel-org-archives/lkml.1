Return-Path: <linux-kernel-owner+w=401wt.eu-S1762958AbXERGzX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762958AbXERGzX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2007 02:55:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756315AbXERGzJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 May 2007 02:55:09 -0400
Received: from pasmtpa.tele.dk ([80.160.77.114]:33231 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756196AbXERGzH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2007 02:55:07 -0400
Date: Fri, 18 May 2007 08:56:05 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: [PATCH 09/14] mm/slab: fix section mismatch warning
Message-ID: <20070518065605.GI12284@uranus.ravnborg.org>
References: <20070518064126.GA12193@uranus.ravnborg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070518064126.GA12193@uranus.ravnborg.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>From 8727055cf189053a0605919611cec5f3c725dc82 Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Thu, 17 May 2007 23:48:19 +0200
Subject: [PATCH 09/14] mm/slab: fix section mismatch warning

Use the new __init_refok marker to avoid the
section mismatch warning from slab.c

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 mm/slab.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/slab.c b/mm/slab.c
index 528243e..2e71a32 100644
--- a/mm/slab.c
+++ b/mm/slab.c
@@ -2037,7 +2037,7 @@ static size_t calculate_slab_order(struct kmem_cache *cachep,
 	return left_over;
 }
 
-static int setup_cpu_cache(struct kmem_cache *cachep)
+static int __init_refok setup_cpu_cache(struct kmem_cache *cachep)
 {
 	if (g_cpucache_up == FULL)
 		return enable_cpucache(cachep);
-- 
1.5.1.rc3.20.gaa453

