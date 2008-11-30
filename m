Return-Path: <linux-kernel-owner+w=401wt.eu-S1755699AbYK3LCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699AbYK3LCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Nov 2008 06:02:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751291AbYK3LC3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 30 Nov 2008 06:02:29 -0500
Received: from fgwmail.fujitsu.co.jp ([164.71.1.133]:57350 "EHLO
	fgwmail.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751490AbYK3LC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Nov 2008 06:02:28 -0500
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Rik van Riel <riel@redhat.com>
Subject: [PATCH 08/09] memcg: show inactive_ratio
Cc: kosaki.motohiro@jp.fujitsu.com
In-Reply-To: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20081130193502.8145.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Message-Id: <20081130200155.815D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Date: Sun, 30 Nov 2008 20:02:25 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

add inactive_ratio field to memory.stat file.


Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
---
 mm/memcontrol.c |    3 +++
 1 file changed, 3 insertions(+)

Index: b/mm/memcontrol.c
===================================================================
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -1784,6 +1784,9 @@ static int mem_control_stat_show(struct 
 		cb->fill(cb, "unevictable", unevictable * PAGE_SIZE);
 
 	}
+
+	cb->fill(cb, "inactive_ratio", mem_cont->inactive_ratio);
+
 	return 0;
 }
 


