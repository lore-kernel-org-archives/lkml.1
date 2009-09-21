Return-Path: <linux-kernel-owner+w=401wt.eu-S1752535AbZIUQKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535AbZIUQKm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Sep 2009 12:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752396AbZIUQKb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Sep 2009 12:10:31 -0400
Received: from gir.skynet.ie ([193.1.99.77]:41572 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751337AbZIUQK0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Sep 2009 12:10:26 -0400
From: Mel Gorman <mel@csn.ul.ie>
To: Nick Piggin <npiggin@suse.de>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Christoph Lameter <cl@linux-foundation.org>
Cc: heiko.carstens@de.ibm.com, sachinp@in.ibm.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Mel Gorman <mel@csn.ul.ie>, Tejun Heo <tj@kernel.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 3/3] slqb: Allow SLQB to be used on PPC
Date: Mon, 21 Sep 2009 17:10:26 +0100
Message-Id: <1253549426-917-4-git-send-email-mel@csn.ul.ie>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
References: <1253549426-917-1-git-send-email-mel@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

SLQB was disabled on PPC as it would stab itself in the face when running
on machines with CPUs on memoryless nodes. As those configurations should
now work, allow SLQB to be configured again on PPC.

Signed-off-by: Mel Gorman <mel@csn.ul.ie>
---
 init/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/init/Kconfig b/init/Kconfig
index adc10ab..8f55fde 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1033,7 +1033,7 @@ config SLUB
 
 config SLQB
 	bool "SLQB (Queued allocator)"
-	depends on !PPC && !S390
+	depends on !S390
 	help
 	  SLQB is a proposed new slab allocator.
 
-- 
1.6.3.3

