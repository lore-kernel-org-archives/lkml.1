Return-Path: <linux-kernel-owner+w=401wt.eu-S1753462AbYLILDU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462AbYLILDU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2008 06:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752130AbYLILDK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Dec 2008 06:03:10 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42577 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129AbYLILDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2008 06:03:09 -0500
Date: Tue, 9 Dec 2008 20:02:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "menage@google.com" <menage@google.com>,
       "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/6] cgroup id and mix fixes (2008/12/09)
Message-Id: <20081209200213.0e2128c1.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


A misc patch set for memcg/cgroup including bug fix.

This set is against mm-of-the-moment snapshot 2008-12-08-16-36

[1/6] Documentation updates (thank you for Randy)
[2/6] fixing pre-destroy() (new implementation, Paul, please comment)
[3/6] cgroup id (removed codes around release_handler)
[4/6] mem_cgroup reclaim with scanning by ID (no big change.)
[5/6] fix active_ratio bug under hierarchy. (new one. very important, I think)
[6/6] fix oom-kill handler.

[2/6] and [3/6] adds codes to kernel/cgroup.c
[4/6] is for sanity of codes, removing cgroup_lock() for scanning.
[5/6] and [6/6] is bug fixes for use_hierarchy=1 case.
If my fixes cannot go ahead, we"ll have to find alternative, anyway.

Thanks,
-Kame

