Return-Path: <linux-kernel-owner+w=401wt.eu-S1764835AbYFFQpJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764835AbYFFQpJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2008 12:45:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752288AbYFFQo5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jun 2008 12:44:57 -0400
Received: from relay2.sgi.com ([192.48.171.30]:33009 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751173AbYFFQo4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2008 12:44:56 -0400
Date: Fri, 6 Jun 2008 11:44:55 -0500
From: Dean Nelson <dcn@sgi.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: [Patch 03/18] define BYTES_PER_WORD
Message-ID: <20080606164455.GD13695@sgi.com>
References: <20080606164034.GA13695@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080606164034.GA13695@sgi.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a BYTES_PER_WORD #define.

Signed-off-by: Dean Nelson <dcn@sgi.com>

---

 drivers/misc/sgi-xp/xp.h |    3 +++
 1 file changed, 3 insertions(+)

Index: linux-2.6/drivers/misc/sgi-xp/xp.h
===================================================================
--- linux-2.6.orig/drivers/misc/sgi-xp/xp.h	2008-05-30 13:59:29.580809165 -0500
+++ linux-2.6/drivers/misc/sgi-xp/xp.h	2008-05-30 14:00:00.200614111 -0500
@@ -19,6 +19,9 @@
 #include <asm/sn/types.h>
 #include <asm/sn/bte.h>
 
+/* >>> Add this #define to some linux header file some day. */
+#define BYTES_PER_WORD	sizeof(void *)
+
 #ifdef USE_DBUG_ON
 #define DBUG_ON(condition)	BUG_ON(condition)
 #else
