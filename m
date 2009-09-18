Return-Path: <linux-kernel-owner+w=401wt.eu-S1758531AbZIRTe3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758531AbZIRTe3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Sep 2009 15:34:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758047AbZIRTeW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Sep 2009 15:34:22 -0400
Received: from gir.skynet.ie ([193.1.99.77]:38516 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758086AbZIRTeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Sep 2009 15:34:10 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>
Subject: [PATCH 3/3] slqb: Allow SLQB to be used on PPC and S390
Date: Fri, 18 Sep 2009 20:34:11 +0100
Message-Id: <1253302451-27740-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
References: <1253302451-27740-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLQB was disabled on PPC and S390 as it would stab itself in the face
when running on machines with CPUs on memoryless nodes. As those
configurations should now work, allow SLQB to be configured again.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 init/Kconfig |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index adc10ab..c56248f 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1033,7 +1033,6 @@ config SLUB
 
 config SLQB
 	bool "SLQB (Queued allocator)"
-	depends on !PPC && !S390
 	help
 	  SLQB is a proposed new slab allocator.
 
-- 
1.6.3.3

