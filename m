Return-Path: <linux-kernel-owner+w=401wt.eu-S967971AbXEHTpA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967971AbXEHTpA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 15:45:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967964AbXEHToy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 15:44:54 -0400
Received: from mx1.redhat.com ([66.187.233.31]:48245 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966902AbXEHTow (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 15:44:52 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
	Directors: Michael Cunningham (USA), Charlie Peters (USA) and
	David Owens (Ireland)
From: David Howells <dhowells@redhat.com>
Subject: [PATCH 1/3] AFS: Export a couple of core functions for AFS write
	support
To: akpm@osdl.org, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       dhowells@redhat.com
Date: Tue, 08 May 2007 20:43:59 +0100
Message-ID: <20070508194358.27477.74888.stgit@warthog.cambridge.redhat.com>
User-Agent: StGIT/0.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Export a couple of core functions for AFS write support to use:

	find_get_pages_contig()
	find_get_pages_tag()

Signed-off-by: David Howells <dhowells@redhat.com>
---

 mm/filemap.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 5631d6b..b276508 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -750,6 +750,7 @@ unsigned find_get_pages_contig(struct address_space *mapping, pgoff_t index,
 	read_unlock_irq(&mapping->tree_lock);
 	return i;
 }
+EXPORT_SYMBOL(find_get_pages_contig);
 
 /**
  * find_get_pages_tag - find and return pages that match @tag
@@ -778,6 +779,7 @@ unsigned find_get_pages_tag(struct address_space *mapping, pgoff_t *index,
 	read_unlock_irq(&mapping->tree_lock);
 	return ret;
 }
+EXPORT_SYMBOL(find_get_pages_tag);
 
 /**
  * grab_cache_page_nowait - returns locked page at given index in given cache

