Return-Path: <linux-kernel-owner+w=401wt.eu-S1758284AbYC1VVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758284AbYC1VVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 17:21:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755352AbYC1VVh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 17:21:37 -0400
Received: from smtp02.mtu.ru ([62.5.255.49]:50443 "EHLO smtp02.mtu.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755037AbYC1VVg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 17:21:36 -0400
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
To: dsd@gentoo.org, trivial@kernel.org, linux-kernel@vger.kernel.org,
       sebastien.dugue@bull.net, randy.dunlap@oracle.com
Subject: [PATCH 1/1 v2] Fix typos in Documentation/unaligned-memory-access.txt
Date: Sat, 29 Mar 2008 00:21:34 +0300
Message-Id: <1206739294-9704-1-git-send-email-dmitri.vorobiev@gmail.com>
X-Mailer: git-send-email 1.5.3.6
X-DCC-STREAM-Metrics: smtp02.mtu.ru 10002; Body=0 Fuz1=0 Fuz2=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deletes a couple of superfluous word occurrences in the
document Documentation/unaligned-memory-access.txt.

Thanks to Sebastien Dugue for the remark about English usage.
---
 Documentation/unaligned-memory-access.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/unaligned-memory-access.txt b/Documentation/unaligned-memory-access.txt
index 6223eac..b0472ac 100644
--- a/Documentation/unaligned-memory-access.txt
+++ b/Documentation/unaligned-memory-access.txt
@@ -57,7 +57,7 @@ here; a summary of the common scenarios is presented below:
    unaligned access to be corrected.
  - Some architectures are not capable of unaligned memory access, but will
    silently perform a different memory access to the one that was requested,
-   resulting a a subtle code bug that is hard to detect!
+   resulting in a subtle code bug that is hard to detect!
 
 It should be obvious from the above that if your code causes unaligned
 memory accesses to happen, your code will not work correctly on certain
@@ -209,7 +209,7 @@ memory and you wish to avoid unaligned access, its usage is as follows:
 
 	u32 value = get_unaligned((u32 *) data);
 
-These macros work work for memory accesses of any length (not just 32 bits as
+These macros work for memory accesses of any length (not just 32 bits as
 in the examples above). Be aware that when compared to standard access of
 aligned memory, using these macros to access unaligned memory can be costly in
 terms of performance.
-- 
1.5.3.6

