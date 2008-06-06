Return-Path: <linux-kernel-owner+w=401wt.eu-S1763638AbYFFQmZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763638AbYFFQmZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:42:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYFFQmR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:42:17 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:60596 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751874AbYFFQmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:42:16 -0400
Date: Fri, 6 Jun 2008 11:42:15 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 01/18] define is_shub() and is_uv() macros
Message-ID: <20080606164215.GB13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606164034.GA13695@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define the is_shub()/is_uv() macros if they've not already been defined.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xp.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

Index: linux-2.6/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xp.h	2008-04-30 20:38:56.000000000 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xp.h	2008-05-01 08:31:32.494004605 -0500
@@ -25,6 +25,22 @@
 #define DBUG_ON(condition)
 #endif
 
+#ifndef is_shub1
+#define is_shub1()	0
+#endif
+
+#ifndef is_shub2
+#define is_shub2()	0
+#endif
+
+#ifndef is_shub
+#define is_shub()	(is_shub1() || is_shub2())
+#endif
+
+#ifndef is_uv
+#define is_uv()		0
+#endif
+
 /*
  * Define the maximum number of logically defined partitions the system
  * can support. It is constrained by the maximum number of hardware
