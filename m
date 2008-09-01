Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYIADcS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYIADcS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2008 23:32:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbYIADcJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Aug 2008 23:32:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:38450 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750927AbYIADcJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2008 23:32:09 -0400
Date: Sun, 31 Aug 2008 20:31:55 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm <akpm@linux-foundation.org>
Subject: [PATCH] kernel/resource.c: fix new kernel-doc warning
Message-Id: <20080831203155.b38e4959.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Brightmail-Tracker: AAAAAQAAAAI=
X-Whitelist: TRUE
X-Whitelist: TRUE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix kernel-doc warning for new function:

Warning(linux-2.6.27-rc5-git2//kernel/resource.c:448): No description found for parameter 'root'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.27-rc5-git2.orig/kernel/resource.c
+++ linux-2.6.27-rc5-git2/kernel/resource.c
@@ -438,7 +438,7 @@ int insert_resource(struct resource *par
 
 /**
  * insert_resource_expand_to_fit - Insert a resource into the resource tree
- * @parent: parent of the new resource
+ * @root: root resource descriptor
  * @new: new resource to insert
  *
  * Insert a resource into the resource tree, possibly expanding it in order
