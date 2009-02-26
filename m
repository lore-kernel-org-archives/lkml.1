Return-Path: <linux-kernel-owner+w=401wt.eu-S1754429AbZBZHCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429AbZBZHCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 02:02:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751896AbZBZHCG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 02:02:06 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:64636 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751763AbZBZHCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 02:02:04 -0500
Message-ID: <49A63E77.9060603@cn.fujitsu.com>
Date: Thu, 26 Feb 2009 15:02:15 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Paul Menage <menage@google.com>, LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] cpuset: cleanups and fixes
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset mainly simplifies update_tasks_nodemask() and makes it
return void (won't fail), thus fix a case that writing to cpuset.mems
returns -ENOMEM but its mems_allowed has been changed.

[PATCH 1/4] cgroups: add 'data' field to struct cgroup_scanner
[PATCH 2/4] cpuset: rewrite update_tasks_nodemask()
[PATCH 3/4] cpuset: avoid changing cpuset's mems when errno returned
[PATCH 4/4] cpuset: remove struct cpuset_hotplug_scanner

---
 include/linux/cgroup.h |    1
 kernel/cpuset.c        |  151 +++++++++++++++++++------------------------------
 2 files changed, 62 insertions(+), 90 deletions(-)
---

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
