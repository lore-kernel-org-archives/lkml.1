Return-Path: <linux-kernel-owner+w=401wt.eu-S1762529AbYEESgd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762529AbYEESgd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2008 14:36:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760948AbYEES26
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 May 2008 14:28:58 -0400
Received: from smtp5.pp.htv.fi ([213.243.153.39]:33027 "EHLO smtp5.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759763AbYEES25 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2008 14:28:57 -0400
Date: Mon, 5 May 2008 21:27:50 +0300
From: Adrian Bunk <bunk@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [2.6 patch] mm/filemap.c should #include <linux/ramfs.h>
Message-ID: <20080505182749.GJ17139@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Every file should include the headers containing the externs for its 
global code (in this case for struct generic_file_vm_ops).

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---

This patch has been sent on:
- 22 Apr 2008
- 14 Apr 2008
- 31 Mar 2008
- 25 Feb 2008

31f02514a5fdca74a4f4f48f13d3450880b7f038 diff --git a/mm/filemap.c b/mm/filemap.c
index 5c74b68..9b58ae0 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -34,6 +34,8 @@
 #include <linux/cpuset.h>
 #include <linux/hardirq.h> /* for BUG_ON(!in_atomic()) only */
 #include <linux/memcontrol.h>
+#include <linux/ramfs.h>
+
 #include "internal.h"
 
 /*

