Return-Path: <linux-kernel-owner+w=401wt.eu-S1753537AbZAELTU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbZAELTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2009 06:19:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752644AbZAELTK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Jan 2009 06:19:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752083AbZAELTH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2009 06:19:07 -0500
Message-ID: <4961EC6A.8010008@cn.fujitsu.com>
Date: Mon, 05 Jan 2009 19:18:02 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] [RESEND] sched: mark sched_create_sysfs_power_savings_entries()
 as __init
References: <4961E98D.3050305@cn.fujitsu.com>
In-Reply-To: <4961E98D.3050305@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Impact: cleanup

The only caller is cpu_dev_init() which is marked as __init.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---

resend with SOB added

---
 kernel/sched.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/sched.c b/kernel/sched.c
index 545c6fc..9a8e296 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -8060,7 +8060,7 @@ static SYSDEV_CLASS_ATTR(sched_smt_power_savings, 0644,
 		   sched_smt_power_savings_store);
 #endif
 
-int sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
+int __init sched_create_sysfs_power_savings_entries(struct sysdev_class *cls)
 {
 	int err = 0;
 
-- 1.5.4.rc3
