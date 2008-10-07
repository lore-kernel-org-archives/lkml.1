Return-Path: <linux-kernel-owner+w=401wt.eu-S1753773AbYJGKCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753773AbYJGKCL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2008 06:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751263AbYJGKB5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Oct 2008 06:01:57 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:39660 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYJGKB4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2008 06:01:56 -0400
Date: Tue, 7 Oct 2008 19:01:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: [PATCH] memcg: update patch set v7
Message-Id: <20081007190121.d96e58a6.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew. please allow me to test under -mm if ok.

This series is against the newest -mmotm(stamp-2008-10-02-16-17)
and I think ready-to-go.

All comments are reflected.
(and CONFIG_CGROUP_MEM_RES_CTLR=n case is fixed.)

Including following patches.

[1/6] ... account swap cache under lock
[2/6] ... set page->mapping to be NULL before uncharge
[3/6] ... avoid to account not-on-LRU pages.
[4/6] ... optimize per cpu statistics on memcg.
[5/6] ... make page_cgroup->flags atomic.
[6/6] ... allocate page_cgroup at boot.

I did tests I can. But I think patch 6/6 needs wider testers.
It has some dependency to configs/archs.

(*) the newest mmotm needs some patches to be driven.

Thanks,
-Kame

