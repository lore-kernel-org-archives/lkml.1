Return-Path: <linux-kernel-owner+w=401wt.eu-S1757188AbZAVJfa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188AbZAVJfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2009 04:35:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753644AbZAVJfT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Jan 2009 04:35:19 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50791 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753546AbZAVJfS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2009 04:35:18 -0500
Date: Thu, 22 Jan 2009 18:34:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/7] cgroup/memcg updates 2009/01/22
Message-Id: <20090122183411.3cabdfd2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is an updates from previes CSS ID patch set and some updates to memcg.
But it seems people are enjoying LinuxConf.au, I'll keep this set on my box
for a while ;)

This set contains following patches 
==
[1/7] add CSS ID to cgroup.
[2/7] use CSS ID under memcg
[3/7] show more hierarchical information via memory.stat file
[4/7] fix "set limit" to return -EBUSY if it seems difficult to shrink usage.
[5/7] fix OOM-Killer under memcg's hierarchy.
[6/7] fix frequent -EBUSY at cgroup rmdir() with memory subsystem.
[7/7] support background reclaim. (for RFC)

patch 4, 7 is new.

Thanks,
-Kame

