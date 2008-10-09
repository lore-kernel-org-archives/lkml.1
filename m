Return-Path: <linux-kernel-owner+w=401wt.eu-S1756240AbYJIFbd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240AbYJIFbd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 01:31:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752719AbYJIFbY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 01:31:24 -0400
Received: from mga09.intel.com ([134.134.136.24]:1965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbYJIFbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 01:31:24 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,382,1220252400"; 
   d="scan'208";a="345785141"
Subject: [patch]fix wrong sysfs file attribute
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain
Date: Thu, 09 Oct 2008 13:31:22 +0800
Message-Id: <1223530282.30941.7.camel@sli10-desk.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This attribute just has write operation.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 drivers/base/memory.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/base/memory.c
===================================================================
--- linux.orig/drivers/base/memory.c	2008-10-09 11:41:40.000000000 +0800
+++ linux/drivers/base/memory.c	2008-10-09 11:41:52.000000000 +0800
@@ -325,7 +325,7 @@ memory_probe_store(struct class *class, 
 
 	return count;
 }
-static CLASS_ATTR(probe, 0700, NULL, memory_probe_store);
+static CLASS_ATTR(probe, 0200, NULL, memory_probe_store);
 
 static int memory_probe_init(void)
 {


