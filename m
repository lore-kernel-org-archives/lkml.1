Return-Path: <linux-kernel-owner+w=401wt.eu-S1765797AbYEVXyk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765797AbYEVXyk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2008 19:54:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759690AbYEVXyd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 May 2008 19:54:33 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:39655 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759519AbYEVXyc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2008 19:54:32 -0400
Date: Thu, 22 May 2008 16:54:27 -0700
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org
Subject: [PATCH] mm: fix filemap.c's comment re: buffer_head.h inclusion
	reason
Message-ID: <20080522235426.GA28518@tpepper-t42p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It appears mm/filemap.c's comment on why buffer_head.h is included has
gotten out of date.  Today generic_osync_inode() is coming from the fs.h
include and buffer_head.h is providing try_to_free_buffers().

Signed-off-by: Tim Pepper <lnxninja@linux.vnet.ibm.com>
Cc:            linux-mm@kvack.org

---

diff --git a/mm/filemap.c b/mm/filemap.c
index 1e6a7d3..fe4adf4 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -38,7 +38,7 @@
 /*
  * FIXME: remove all knowledge of the buffer layer from the core VM
  */
-#include <linux/buffer_head.h> /* for generic_osync_inode */
+#include <linux/buffer_head.h> /* for try_to_free_buffers */
 
 #include <asm/mman.h>
 
