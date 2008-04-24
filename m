Return-Path: <linux-kernel-owner+w=401wt.eu-S1758411AbYDXPQK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758411AbYDXPQK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 11:16:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754823AbYDXPOi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 11:14:38 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:55957 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759297AbYDXPOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 11:14:34 -0400
Message-Id: <20080424151404.283234087@polymtl.ca>
References: <20080424150324.802695381@polymtl.ca>
User-Agent: quilt/0.46-1
Date: Thu, 24 Apr 2008 11:03:51 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Cc: Adrian Bunk <bunk@kernel.org>,
       Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Subject: [patch 27/37] From: Adrian Bunk <bunk@kernel.org>
Content-Disposition: inline; filename=make-marker_debug-static.patch
X-Poly-FromMTA: (dijkstra.casi.polymtl.ca [132.207.72.10]) at Thu, 24 Apr 2008 15:14:05 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the needlessly global marker_debug being static gcc can optimize the
unused code away.

Signed-off-by: Adrian Bunk <bunk@kernel.org>
Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/marker.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/marker.c~make-marker_debug-static kernel/marker.c
--- a/kernel/marker.c~make-marker_debug-static
+++ a/kernel/marker.c
@@ -28,7 +28,7 @@ extern struct marker __start___markers[]
 extern struct marker __stop___markers[];
 
 /* Set to 1 to enable marker debug output */
-const int marker_debug;
+static const int marker_debug;
 
 /*
  * markers_mutex nests inside module_mutex. Markers mutex protects the builtin
_

-- 
Mathieu Desnoyers
Computer Engineering Ph.D. Student, Ecole Polytechnique de Montreal
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
