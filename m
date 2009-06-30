Return-Path: <linux-kernel-owner+w=401wt.eu-S1758975AbZF3XRh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758975AbZF3XRh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jun 2009 19:17:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759471AbZF3XRT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jun 2009 19:17:19 -0400
Received: from ozlabs.org ([203.10.76.45]:39621 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758379AbZF3XRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jun 2009 19:17:18 -0400
Message-Id: <20090630230140.714204656@samba.org>
References: <20090630230043.464194676@samba.org>
User-Agent: quilt/0.46-1
Date: Wed, 01 Jul 2009 09:00:44 +1000
From: Anton Blanchard <anton@samba.org>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu
Cc: linux-kernel@vger.kernel.org
Subject: [patch 1/8] perf report: Fix -z option
Content-Disposition: inline; filename=pcl_skip_zero_option.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a copy and paste error, -z was setting the group option.

Signed-off-by: Anton Blanchard <anton@samba.org>
---

Index: linux-2.6-tip/tools/perf/builtin-top.c
===================================================================
--- linux-2.6-tip.orig/tools/perf/builtin-top.c	2009-07-01 08:21:13.000000000 +1000
+++ linux-2.6-tip/tools/perf/builtin-top.c	2009-07-01 08:21:24.000000000 +1000
@@ -675,7 +675,7 @@
 			    "put the counters into a counter group"),
 	OPT_STRING('s', "sym-filter", &sym_filter, "pattern",
 		    "only display symbols matchig this pattern"),
-	OPT_BOOLEAN('z', "zero", &group,
+	OPT_BOOLEAN('z', "zero", &zero,
 		    "zero history across updates"),
 	OPT_INTEGER('F', "freq", &freq,
 		    "profile at this frequency"),

-- 

