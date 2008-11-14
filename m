Return-Path: <linux-kernel-owner+w=401wt.eu-S1755993AbYKNXAn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755993AbYKNXAn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2008 18:00:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751844AbYKNXAT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Nov 2008 18:00:19 -0500
Received: from smtp.polymtl.ca ([132.207.4.11]:52180 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466AbYKNXAR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2008 18:00:17 -0500
Message-Id: <20081114224947.651619810@polymtl.ca>
References: <20081114224733.364965865@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Fri, 14 Nov 2008 17:47:36 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Cc: akpm@linux-foundation.org, Linus Torvalds <torvalds@linux-foundation.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [patch 03/16] markers: Add missing stdargs.h include, needed due to va_list usage
Content-Disposition: inline; filename=markers-add-missing-stdargs.patch
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 14 Nov 2008 23:00:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

That seemed to cause built issue when marker.h is included early, even though
stdargs.h is included in kernel.h.

Impact: bugfix.

From: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
CC: 'Ingo Molnar' <mingo@elte.hu>
CC: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 include/linux/marker.h |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6-lttng/include/linux/marker.h
===================================================================
--- linux-2.6-lttng.orig/include/linux/marker.h	2008-11-14 16:58:54.000000000 -0500
+++ linux-2.6-lttng/include/linux/marker.h	2008-11-14 16:59:00.000000000 -0500
@@ -12,6 +12,7 @@
  * See the file COPYING for more details.
  */
 
+#include <stdarg.h>
 #include <linux/types.h>
 
 struct module;

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
