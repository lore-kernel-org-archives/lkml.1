Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZEVG0n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZEVG0n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 02:26:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751821AbZEVG0O
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 02:26:14 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:64489 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752290AbZEVG0M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 02:26:12 -0400
Message-ID: <4A1645D4.5010001@cn.fujitsu.com>
Date: Fri, 22 May 2009 14:27:32 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: [PATCH] memcg: remove forward declaration from sched.h
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This forward declaration seems pointless.

compile tested.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 sched.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/linux/sched.h	2009-05-22 13:43:01.000000000 +0800
+++ b/include/linux/sched.h	2009-05-22 13:38:59.000000000 +0800
@@ -93,7 +93,6 @@ struct sched_param {
 
 #include <asm/processor.h>
 
-struct mem_cgroup;
 struct exec_domain;
 struct futex_pi_state;
 struct robust_list_head;
