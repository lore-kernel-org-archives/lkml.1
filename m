Return-Path: <linux-kernel-owner+w=401wt.eu-S932070AbZKWTzn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932070AbZKWTzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Nov 2009 14:55:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756512AbZKWTyj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Nov 2009 14:54:39 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:35815 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756426AbZKWTyg (ORCPT
	<rfc822;groupwise-GHaskins@novell.com:0:0>);
	Mon, 23 Nov 2009 14:54:36 -0500
From: Gregory Haskins <ghaskins@novell.com>
Subject: [-next PATCH 1/4] vbus: make library code properly declared as GPL
To: linux-next@vger.kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       alacrityvm-devel@lists.sourceforge.net
Date: Mon, 23 Nov 2009 14:54:34 -0500
Message-ID: <20091123195434.8184.70297.stgit@dev.haskins.net>
In-Reply-To: <20091123195136.8184.68042.stgit@dev.haskins.net>
References: <20091123195136.8184.68042.stgit@dev.haskins.net>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This facilitates building the shm-signal and ioq libraries as kernel
modules.

Signed-off-by: Gregory Haskins <ghaskins@novell.com>
---

 lib/ioq.c        |    4 ++++
 lib/shm_signal.c |    4 ++++
 2 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/lib/ioq.c b/lib/ioq.c
index a6c8664..d5e57be 100644
--- a/lib/ioq.c
+++ b/lib/ioq.c
@@ -25,6 +25,10 @@
 #include <linux/bitops.h>
 #include <linux/module.h>
 
+MODULE_AUTHOR("Gregory Haskins");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
+
 #ifndef NULL
 #define NULL 0
 #endif
diff --git a/lib/shm_signal.c b/lib/shm_signal.c
index fbba74f..8d3e9b4 100644
--- a/lib/shm_signal.c
+++ b/lib/shm_signal.c
@@ -24,6 +24,10 @@
 #include <linux/interrupt.h>
 #include <linux/shm_signal.h>
 
+MODULE_AUTHOR("Gregory Haskins");
+MODULE_LICENSE("GPL");
+MODULE_VERSION("1");
+
 int shm_signal_enable(struct shm_signal *s, int flags)
 {
 	struct shm_signal_irq *irq = &s->desc->irq[s->locale];

