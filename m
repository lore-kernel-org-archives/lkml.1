Return-Path: <linux-kernel-owner+w=401wt.eu-S934467AbYBNVYd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934467AbYBNVYd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 16:24:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934173AbYBNVYM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 16:24:12 -0500
Received: from smtp6.pp.htv.fi ([213.243.153.40]:51776 "EHLO smtp6.pp.htv.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934123AbYBNVYK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 16:24:10 -0500
Date: Thu, 14 Feb 2008 23:23:49 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Cc: linux-kernel@vger.kernel.org
Subject: [2.6 patch] make marker_debug static
Message-ID: <20080214212349.GD23227@cs181133002.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the needlessly global marker_debug being static gcc can optimize 
the unused code away.

Signed-off-by: Adrian Bunk <bunk@kernel.org>

---
91577cc8ac60bf9003d0dd037a231db363003740 diff --git a/kernel/marker.c b/kernel/marker.c
index c4c2cd8..133bdbb 100644
--- a/kernel/marker.c
+++ b/kernel/marker.c
@@ -28,7 +28,7 @@ extern struct marker __start___markers[];
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-const int marker_debug;
+static const int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin

