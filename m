Return-Path: <linux-kernel-owner+w=401wt.eu-S1758987AbZCBCNR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758987AbZCBCNR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Mar 2009 21:13:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753333AbZCBCM6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Mar 2009 21:12:58 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:63363 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752296AbZCBCM5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Mar 2009 21:12:57 -0500
Message-ID: <49AB40DE.4090704@cn.fujitsu.com>
Date: Mon, 02 Mar 2009 10:13:50 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Li Zefan <lizf@cn.fujitsu.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>
Subject: [PATCH 1/4] cgroup debug: show correct file mode
References: <49AB40BF.4030706@cn.fujitsu.com>
In-Reply-To: <49AB40BF.4030706@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All control files in debug subsystem are read-only.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 kernel/cgroup_debug.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/kernel/cgroup_debug.c b/kernel/cgroup_debug.c
index daca620..2ba54c6 100644
--- a/kernel/cgroup_debug.c
+++ b/kernel/cgroup_debug.c
@@ -71,25 +71,30 @@ static struct cftype files[] =  {
 	{
 		.name = "cgroup_refcount",
 		.read_u64 = cgroup_refcount_read,
+		.mode = 0444,
 	},
 	{
 		.name = "taskcount",
 		.read_u64 = taskcount_read,
+		.mode = 0444,
 	},
 
 	{
 		.name = "current_css_set",
 		.read_u64 = current_css_set_read,
+		.mode = 0444,
 	},
 
 	{
 		.name = "current_css_set_refcount",
 		.read_u64 = current_css_set_refcount_read,
+		.mode = 0444,
 	},
 
 	{
 		.name = "releasable",
 		.read_u64 = releasable_read,
+		.mode = 0444,
 	},
 };
 
-- 1.5.4.rc3 
