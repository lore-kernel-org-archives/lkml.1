Return-Path: <linux-kernel-owner+w=401wt.eu-S1760338AbYJKU3t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760338AbYJKU3t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2008 16:29:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754038AbYJKU3m
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 11 Oct 2008 16:29:42 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:54863 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753552AbYJKU3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2008 16:29:41 -0400
X-Greylist: delayed 3705 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Oct 2008 16:29:41 EDT
Date: Sat, 11 Oct 2008 20:27:53 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH linux-tip] x86: Change OPTIMIZE_INLINING help to say enabling makes smaller kernels
Message-ID: <20081011192753.GA13493@silver.sucs.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The OPTIMIZE_INLINING help currently says "The gcc 4.x series have a
rewritten inlining algorithm and disabling this option will generate a
smaller kernel there."

This contradicts other parts of the help text and my own tests:
5463127 2008-10-11 19:51 vmlinux.no-opt
5456152 2008-10-11 19:56 vmlinux.opt

Reword text to say that enabling OPTIMIZE_INLINING will lead to smaller
kernels with gcc 4.x or later.

Signed-off-by: Sitsofe Wheeler <sitsofe@yahoo.com>
---

diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 6a75bc2..bdddfbc 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -395,10 +395,10 @@ config OPTIMIZE_INLINING
 	  developers have marked 'inline'. Doing so takes away freedom from gcc to
 	  do what it thinks is best, which is desirable for the gcc 3.x series of
 	  compilers. The gcc 4.x series have a rewritten inlining algorithm and
-	  disabling this option will generate a smaller kernel there. Hopefully
-	  this algorithm is so good that allowing gcc4 to make the decision can
-	  become the default in the future, until then this option is there to
-	  test gcc for this.
+	  enabling this option will generate a smaller kernel there. Hopefully
+	  this algorithm is so good that allowing gcc 4.x and above to make the
+	  decision will become the default in the future. Until then this option
+	  is there to test gcc for this.
 
 	  If unsure, say N.
 
-- 
Sitsofe | http://sucs.org/~sits/
