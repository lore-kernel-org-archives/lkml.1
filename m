Return-Path: <linux-kernel-owner+w=401wt.eu-S1753400AbXDFFgo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400AbXDFFgo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2007 01:36:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753448AbXDFFgo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Apr 2007 01:36:44 -0400
Received: from mout1.freenet.de ([194.97.50.132]:44128 "EHLO mout1.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753400AbXDFFgn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2007 01:36:43 -0400
Message-ID: <4615DC61.6080606@freenet.de>
Date: Fri, 06 Apr 2007 07:36:33 +0200
From: Patrick Ringl <patrick_@freenet.de>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: christoph@lameter.com, torvalds@linux-foundation.org
Subject: [PATCH 2.6.21-rc6] mm/page_alloc.c: removal of an unused definition
 of 'setup_n_node_ids'
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Remove an empty and thus unused definition of 'setup_nr_node_ids' (in 
case of MAX_NUMNODES < 1) in order to resolve a compiler warning.

Signed-off-by: Patrick Ringl <patrick_@freenet.de>
---

--- linux-2.6.20-o/mm/page_alloc.c      2007-03-22 23:11:25.000000000 +0100
+++ linux-2.6.20/mm/page_alloc.c        2007-04-06 07:19:38.000000000 +0200
@@ -680,8 +680,6 @@ static void __init setup_nr_node_ids(voi
                highest = node;
        nr_node_ids = highest + 1;
 }
-#else
-static void __init setup_nr_node_ids(void) {}
 #endif

 #ifdef CONFIG_NUMA



