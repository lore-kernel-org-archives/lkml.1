Return-Path: <linux-kernel-owner+w=401wt.eu-S1755223AbYICOBM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755223AbYICOBM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2008 10:01:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753113AbYICOA7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Sep 2008 10:00:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:50534 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753072AbYICOA6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2008 10:00:58 -0400
Subject: [PATCH] lockstat: documentation update
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       Christoph Hellwig <hch@infradead.org>
Content-Type: text/plain
Date: Wed, 03 Sep 2008 16:00:57 +0200
Message-Id: <1220450457.8609.150.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Christoph noted that the documentation doesn't tell in what unit the
lockstat times are reported, ammend this.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
diff --git a/Documentation/lockstat.txt b/Documentation/lockstat.txt
index 4ba4664..02f36f5 100644
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -100,6 +100,7 @@ The first lock (05-10) is a read/write lock, and shows two lines above the
 short separator. The contention points don't match the column descriptors,
 they have two: contentions and [<IP>] symbol.
 
+The integer part of the time values is in us.
 
 View the top contending locks:
 


