Return-Path: <linux-kernel-owner+w=401wt.eu-S1755768AbYAQR6w@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755768AbYAQR6w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2008 12:58:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752366AbYAQR6o
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jan 2008 12:58:44 -0500
Received: from waste.org ([66.93.16.53]:59379 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752226AbYAQR6o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2008 12:58:44 -0500
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [PATCH 3 of 3] slob: correct Kconfig description
X-Mercurial-Node: db1f4e74c5ab1536964792d53f1575402542531a
Message-Id: <db1f4e74c5ab15369647.1200592641@cinder.waste.org>
In-Reply-To: <patchbomb.1200592638@cinder.waste.org>
Date: Thu, 17 Jan 2008 11:57:21 -0600
From: Matt Mackall <mpm@selenic.com>
To: Andrew Morton <apkm@linux-foundation.com>
Cc: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Matt Mackall <mpm@selenic.com>

diff -r eff994add207 -r db1f4e74c5ab init/Kconfig
--- a/init/Kconfig	Wed Jan 16 18:14:29 2008 -0600
+++ b/init/Kconfig	Wed Jan 16 18:14:29 2008 -0600
@@ -648,11 +648,9 @@
 	depends on EMBEDDED
 	bool "SLOB (Simple Allocator)"
 	help
-	   SLOB replaces the SLAB allocator with a drastically simpler
-	   allocator.  SLOB is more space efficient than SLAB but does not
-	   scale well (single lock for all operations) and is also highly
-	   susceptible to fragmentation. SLUB can accomplish a higher object
-	   density. It is usually better to use SLUB instead of SLOB.
+	   SLOB replaces the stock allocator with a drastically simpler
+	   allocator. SLOB is generally more space efficient but
+	   does not perform as well on large systems.
 
 endchoice
 
