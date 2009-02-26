Return-Path: <linux-kernel-owner+w=401wt.eu-S1754519AbZBZHDR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519AbZBZHDR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:03:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750818AbZBZHC7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:02:59 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52713 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754161AbZBZHC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:02:59 -0500
Message-ID: <49A63E99.9040508@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:02:49 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/4] cgroups: add 'data' field to struct cgroup_scanner
References: <49A63E77.9060603@cn.fujitsu.com>
In-Reply-To: <49A63E77.9060603@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to pass some data to test_task() or process_task() in some cases.
Will be used later.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 include/linux/cgroup.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 9a40932..6ad1989 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -332,6 +332,7 @@ struct cgroup_scanner {
 	void (*process_task)(struct task_struct *p,
 			struct cgroup_scanner *scan);
 	struct ptr_heap *heap;
+	void *data;
 };
 
 /*
-- 1.5.4.rc3 
