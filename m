Return-Path: <linux-kernel-owner+w=401wt.eu-S1759007AbZEaP1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759007AbZEaP1R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 May 2009 11:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755679AbZEaP1F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 May 2009 11:27:05 -0400
Received: from smtp.wellnetcz.com ([212.24.148.102]:55030 "EHLO
	smtp.wellnetcz.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755130AbZEaP1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 May 2009 11:27:04 -0400
From: Jiri Slaby <jirislaby@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Jiri Slaby <jirislaby@gmail.com>
Subject: [PATCH 1/1] rapidio: fix kerneldoc for rio_mem_ops
Date: Sun, 31 May 2009 17:25:38 +0200
Message-Id: <1243783538-18770-1-git-send-email-jirislaby@gmail.com>
X-Mailer: git-send-email 1.6.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add structure name to the kerneldoc comment, so that we won't get
a kdoc error:
Error(include/linux/rio.h:336): cannot understand prototype: 'struct rio_mem_ops '

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
---
 include/linux/rio.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/rio.h b/include/linux/rio.h
index dd61538..9710506 100644
--- a/include/linux/rio.h
+++ b/include/linux/rio.h
@@ -327,7 +327,7 @@ extern struct resource rio_resource;
 #define release_rio_region(start, n) __release_region(&rio_resource, (start), (n))
 
 /**
- * Struct for RIO memory definition.
+ * struct rio_mem_ops - struct for RIO memory definition.
  * @map_inb: The function for mapping inbound memory window.
  * @map_outb: The function for mapping outbound memory window.
  * @unmap_inb: The function for unmapping inbound memory window.
-- 
1.6.3

