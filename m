Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZHDO3O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZHDO3O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 10:29:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755065AbZHDO3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 10:29:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40612 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755181AbZHDO3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 10:29:12 -0400
Message-Id: <20090804142710.377919293@suse.com>
User-Agent: quilt/0.47-14.9
Date: Tue, 04 Aug 2009 10:26:23 -0400
From: Jeff Mahoney <jeffm@suse.com>
To: Greg KH <gregkh@suse.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [patch 5/5] rtl8192su: add linux/vmalloc.h
References: <20090804142618.455591385@suse.com>
Content-Disposition: inline; filename=patches.rpmify/rtl8192su-vmalloc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Some arches don't provide vmalloc.h through the includes already included
 in rtl8192su. This patch adds it.

Signed-off-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/staging/rtl8192su/r8192U_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/staging/rtl8192su/r8192U_core.c
+++ b/drivers/staging/rtl8192su/r8192U_core.c
@@ -24,6 +24,7 @@
  * Jerry chuang <wlanfae@realtek.com>
  */
 
+#include <linux/vmalloc.h>
 
 #undef LOOP_TEST
 #undef DUMP_RX


