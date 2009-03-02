Return-Path: <linux-kernel-owner+w=401wt.eu-S1759455AbZCBCOd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759455AbZCBCOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:14:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759263AbZCBCN7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:13:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:49202 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759253AbZCBCN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:13:58 -0500
Message-ID: <49AB4118.2040004@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 10:14:48 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>
Subject: [PATCH 2/4] cpuacct: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>
In-Reply-To: <49AB40BF.4030706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

cpuacct.usage_percpu is read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/sched.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index e66f009..638aa4d 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -9734,6 +9734,7 @@ static struct cftype files[] = {
 	{
 		.name = "usage_percpu",
 		.read_seq_string = cpuacct_percpu_seq_read,
+		.mode = 0444,
 	},
 
 };
-- 1.5.4.rc3 
