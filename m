Return-Path: <linux-kernel-owner+w=401wt.eu-S1763966AbYEVDtH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763966AbYEVDtH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 23:49:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756079AbYEVDsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 23:48:53 -0400
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:42622 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753517AbYEVDsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 23:48:53 -0400
Subject: [PATCH] for_each_online_pgdat: kerneldoc fix
From: Fernando Luis =?ISO-8859-1?Q?V=E1zquez?= Cao 
	<fernando@oss.ntt.co.jp>
To: akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain
Organization: NTT Open Source Software Center
Date: Thu, 22 May 2008 12:48:51 +0900
Message-Id: <1211428131.3207.18.camel@sebastian.kern.oss.ntt.co.jp>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for_each_pgdat was renamed for_each_online_pgdat and kerneldoc comments
should be updated accordingly.

Signed-off-by: Fernando Luis Vazquez Cao <fernando@oss.ntt.co.jp>
---

diff -urNp linux-2.6.26-rc3-git3-orig/include/linux/mmzone.h linux-2.6.26-rc3-git3/include/linux/mmzone.h
--- linux-2.6.26-rc3-git3-orig/include/linux/mmzone.h	2008-05-22 12:26:59.000000000 +0900
+++ linux-2.6.26-rc3-git3/include/linux/mmzone.h	2008-05-22 12:33:00.000000000 +0900
@@ -703,7 +703,7 @@ extern struct pglist_data *next_online_p
 extern struct zone *next_zone(struct zone *zone);
 
 /**
- * for_each_pgdat - helper macro to iterate over all nodes
+ * for_each_online_pgdat - helper macro to iterate over all online nodes
  * @pgdat - pointer to a pg_data_t variable
  */
 #define for_each_online_pgdat(pgdat)			\


