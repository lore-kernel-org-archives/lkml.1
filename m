Return-Path: <linux-kernel-owner+w=401wt.eu-S1756163AbYCTHqh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756163AbYCTHqh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 03:46:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753961AbYCTHp7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 03:45:59 -0400
Received: from saeurebad.de ([85.214.36.134]:34705 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbYCTHp4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 03:45:56 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: Jesper Juhl <trivial@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] Remove unused MAX_NODES_SHIFT
Date: Thu, 20 Mar 2008 08:43:48 +0100
Message-Id: <1205999028-21085-1-git-send-email-hannes@saeurebad.de>
X-Mailer: git-send-email 1.5.4.3
In-Reply-To: <>
References: <>
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

MAX_NODES_SHIFT is not referenced anywhere in the tree, so dump it.

Signed-off-by: Johannes Weiner <hannes@saeurebad.de>
---
 include/linux/mmzone.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 8d8d197..9f274a6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -699,7 +699,6 @@ extern char numa_zonelist_order[];
 extern struct pglist_data contig_page_data;
 #define NODE_DATA(nid)		(&contig_page_data)
 #define NODE_MEM_MAP(nid)	mem_map
-#define MAX_NODES_SHIFT		1
 
 #else /* CONFIG_NEED_MULTIPLE_NODES */
 
-- 
1.5.4.3
