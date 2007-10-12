Return-Path: <linux-kernel-owner+w=401wt.eu-S1759626AbXJLHdS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759626AbXJLHdS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2007 03:33:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752175AbXJLHdE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Oct 2007 03:33:04 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:37241 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbXJLHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2007 03:33:03 -0400
Date: Fri, 12 Oct 2007 16:34:12 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>
Subject: [BUGFIX][PATCH][ for -mm] bugfix for memory cgroup controller [0/5]
 intro
Message-Id: <20071012163412.2f1ca1ea.kamezawa.hiroyu@jp.fujitsu.com>
Organization: Fujitsu
X-Mailer: Sylpheed 2.4.2 (GTK+ 2.10.11; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This set is a fix for memory cgroup against 2.6.23-mm1.
Not including any new feature.

Patches:
[1/5] ... fix refcnt handling in charge mem_cgroup_charge()
[2/5] ... fix error handling path in mem_cgroup_charge()
[3/5] ... check page->cgroup under lock again.
[4/5] ... fix mem_cgroup_isolate_pages() to skip !PageLRU() pages.
[5/5] ... fix page migration under memory controller, fixes leak.

Tested on x86-64/fake-NUMA system.

Thanks,
-Kame

