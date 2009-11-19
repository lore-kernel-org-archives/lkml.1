Return-Path: <linux-kernel-owner+w=401wt.eu-S1755624AbZKSVyX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755624AbZKSVyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Nov 2009 16:54:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752749AbZKSVyW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Nov 2009 16:54:22 -0500
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:42017 "EHLO
	TX2EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZKSVyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Nov 2009 16:54:22 -0500
X-SpamScore: 2
X-BigFish: VS2(zzzz1202h10c0jzzz2dh6bh87h61h)
X-Spam-TCS-SCL: 0:0
X-FB-DOMAIN-IP-MATCH: fail
Message-ID: <4B05BE7D.30500@am.sony.com>
Date: Thu, 19 Nov 2009 13:54:05 -0800
From: Frank Rowand <frank.rowand@am.sony.com>
Reply-To: frank.rowand@am.sony.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: peterz@infradead.org, mingo@redhat.com
CC: tom.leiming@gmail.com, linux-kernel@vger.kernel.org
Subject: [PATCH] LOCKSTAT: Add usage info to Documentation/lockstat.txt
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Nov 2009 21:54:02.0879 (UTC) FILETIME=[CEAF58F0:01CA6962]
X-Reverse-DNS: mail7.fw-bc.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add usage info to Documentation/lockstat.txt

Signed-off-by: Frank Rowand <frank.rowand@am.sony.com>

---
 Documentation/lockstat.txt |   12 	12 +	0 -	0 !
 1 files changed, 12 insertions(+)

Index: b/Documentation/lockstat.txt
===================================================================
--- a/Documentation/lockstat.txt
+++ b/Documentation/lockstat.txt
@@ -62,8 +62,20 @@ applicable).
 It also tracks 4 contention points per class. A contention point is a call site
 that had to wait on lock acquisition.
 
+ - CONFIGURATION
+
+Lock statistics are enabled via CONFIG_LOCK_STATS.
+
  - USAGE
 
+Enable collection of statistics:
+
+# echo 1 >/proc/sys/kernel/lock_stat
+
+Disable collection of statistics:
+
+# echo 0 >/proc/sys/kernel/lock_stat
+
 Look at the current lock statistics:
 
 ( line numbers not part of actual output, done for clarity in the explanation

