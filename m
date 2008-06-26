Return-Path: <linux-kernel-owner+w=401wt.eu-S1755626AbYFZJ2c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbYFZJ2c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 05:28:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751519AbYFZJ2X
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 05:28:23 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:49427 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbYFZJ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 05:28:22 -0400
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hugh@veritas.com>, YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Paul Menage <menage@google.com>, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Date: Thu, 26 Jun 2008 14:58:15 +0530
Message-Id: <20080626092815.16841.54817.sendpatchset@balbir-laptop>
Subject: [0/5] memrlimit fixes
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew,

These are fixes for the memrlimit cgroup controller. Patch 1, improve
error handling has been redone. Detailed changelog can be found in every
patch. I've tested the patches by running kernbench in a memrlimit
controlled cgroup.

series
------
memrlimit-cgroup-add-better-error-handling
memrlimit-cgroup-fix-attach-task
memrlimit-fix-sleep-in-spinlock-bug
memrlimit-improve-fork-error-handling
memrlimit-fix-move-vma-accounting

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
