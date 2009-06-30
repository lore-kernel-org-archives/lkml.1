Return-Path: <linux-kernel-owner+w=401wt.eu-S1760150AbZF3XRs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760150AbZF3XRs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:17:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759613AbZF3XRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:19 -0400
Received: from ozlabs.org ([203.10.76.45]:39623 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758533AbZF3XRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:18 -0400
Message-Id: <20090630230140.802078956@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:45 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 2/8] perf_counter tools: Remove zlib dependency
Content-Disposition: inline; filename=pcl_nozlib.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The zlib devel libraries may not be installed and since we aren't using zlib
we may as well remove it.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/Makefile
===================================================================
--- linux-2.6-tip.orig/tools/perf/Makefile	2009-07-01 08:21:13.000000000 +1000
+++ linux-2.6-tip/tools/perf/Makefile	2009-07-01 08:21:28.000000000 +1000
@@ -379,12 +379,6 @@
 	endif
 endif
 
-ifdef ZLIB_PATH
-	BASIC_CFLAGS += -I$(ZLIB_PATH)/include
-	EXTLIBS += -L$(ZLIB_PATH)/$(lib) $(CC_LD_DYNPATH)$(ZLIB_PATH)/$(lib)
-endif
-EXTLIBS += -lz
-
 ifdef NEEDS_SOCKET
 	EXTLIBS += -lsocket
 endif

-- 

