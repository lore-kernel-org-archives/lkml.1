Return-Path: <linux-kernel-owner+w=401wt.eu-S1754930AbZDDEg3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930AbZDDEg3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 00:36:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751565AbZDDEgV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 00:36:21 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:19055 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbZDDEgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 00:36:21 -0400
Date: Fri, 3 Apr 2009 21:30:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>
Subject: [PATCH] filemap: fix kernel-doc warnings
Message-Id: <20090403213041.f22d4ae2.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.6.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt701.oracle.com [141.146.40.71]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A010209.49D6E378.0012:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix filemap.c kernel-doc warnings:

Warning(mm/filemap.c:575): No description found for parameter 'page'
Warning(mm/filemap.c:575): No description found for parameter 'waiter'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
---
 mm/filemap.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.29-git11.orig/mm/filemap.c
+++ linux-2.6.29-git11/mm/filemap.c
@@ -566,8 +566,8 @@ EXPORT_SYMBOL(wait_on_page_bit);
 
 /**
  * add_page_wait_queue - Add an arbitrary waiter to a page's wait queue
- * @page - Page defining the wait queue of interest
- * @waiter - Waiter to add to the queue
+ * @page: Page defining the wait queue of interest
+ * @waiter: Waiter to add to the queue
  *
  * Add an arbitrary @waiter to the wait queue for the nominated @page.
  */
