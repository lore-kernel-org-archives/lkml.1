Return-Path: <linux-kernel-owner+w=401wt.eu-S1755511AbYLAMTZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511AbYLAMTZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2008 07:19:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752301AbYLAMTP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Dec 2008 07:19:15 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:41759 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753108AbYLAMTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2008 07:19:14 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 10/11] memcg: show inactive_ratio
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081201205810.1CCA.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081201211817.1CE8.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Mon,  1 Dec 2008 21:19:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add inactive_ratio field to memory.stat file.
it is useful for memcg reclam debugging.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1796,6 +1796,9 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+
+	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
+
 	return 0;
 }
 


