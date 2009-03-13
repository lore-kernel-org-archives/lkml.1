Return-Path: <linux-kernel-owner+w=401wt.eu-S1759304AbZCMRiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759304AbZCMRiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Mar 2009 13:38:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758540AbZCMRiF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Mar 2009 13:38:05 -0400
Received: from mx2.redhat.com ([66.187.237.31]:36586 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757725AbZCMRiE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Mar 2009 13:38:04 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 2/2] NOMMU: Make CONFIG_UNEVICTABLE_LRU available when
	CONFIG_MMU=n
To: kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com
Cc: dhowells@redhat.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, peterz@infradead.org,
       nrik.Berkhan@ge.com, uclinux-dev@uclinux.org,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, hannes@cmpxchg.org,
       riel@surriel.com, lee.schermerhorn@hp.com
Date: Fri, 13 Mar 2009 17:33:53 +0000
Message-ID: <20090313173353.10169.23515.stgit@warthog.procyon.org.uk>
In-Reply-To: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
References: <20090313173343.10169.58053.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make CONFIG_UNEVICTABLE_LRU available when CONFIG_MMU=n.  There's no logical
reason it shouldn't be available, and it can be used for ramfs.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)


diff --git a/mm/Kconfig b/mm/Kconfig
index 8c89597..b53427a 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -206,7 +206,6 @@ config VIRT_TO_BUS
 config UNEVICTABLE_LRU
 	bool "Add LRU list to track non-evictable pages"
 	default y
-	depends on MMU
 	help
 	  Keeps unevictable pages off of the active and inactive pageout
 	  lists, so kswapd will not waste CPU time or have its balancing

