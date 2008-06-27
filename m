Return-Path: <linux-kernel-owner+w=401wt.eu-S1760428AbYF0PSg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760428AbYF0PSg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2008 11:18:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756738AbYF0PSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Jun 2008 11:18:15 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:57789 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756280AbYF0PSN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2008 11:18:13 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: YAMAMOTO Takashi <yamamoto@valinux.co.jp>, Paul Menage <menage@google.com>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Fri, 27 Jun 2008 20:48:08 +0530
Message-Id: <20080627151808.31664.36047.sendpatchset@balbir-laptop>
Subject: [RFC 0/5] Memory controller soft limit introduction (v3)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset implements the basic changes required to implement soft limits
in the memory controller. A soft limit is a variation of the currently
supported hard limit feature. A memory cgroup can exceed it's soft limit
provided there is no contention for memory.

These patches were tested on a x86_64 box, by running a programs in parallel,
and checking their behaviour for various soft limit values.

These patches were developed on top of 2.6.26-rc5-mm3. Comments, suggestions,
criticism are all welcome!

A previous version of the patch can be found at

http://kerneltrap.org/mailarchive/linux-kernel/2008/2/19/904114

TODOs:

1. Distribute the excessive (non-contended) resources between groups
   in the ratio of their soft limits
2. Merge with KAMEZAWA's and YAMAMOTO's water mark and background reclaim
   patches in the long-term

series
------
memory-controller-soft-limit-add-documentation.patch
prio_heap_delete_max.patch
prio_heap_replace_leaf.patch
memory-controller-soft-limit-res-counter-updates.patch
memory-controller-soft-limit-reclaim-on-contention.patch

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
