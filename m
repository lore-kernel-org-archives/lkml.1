Return-Path: <linux-kernel-owner+w=401wt.eu-S1756170AbYLHCgv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756170AbYLHCgv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Dec 2008 21:36:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754088AbYLHCgm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Dec 2008 21:36:42 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:41623 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754066AbYLHCgm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Dec 2008 21:36:42 -0500
Date: Mon, 8 Dec 2008 10:58:24 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [PATCH -mmotm 0/4] cleanups/fixes for memory cgroup
Message-Id: <20081208105824.f8f5d67b.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

These are some cleanup/bug fix patches that I have now for memory cgroup.

Patches:
  [1/4] memcg: don't trigger oom at page migration
  [2/4] memcg: remove mem_cgroup_try_charge
  [3/4] memcg: avoid deadlock caused by race between oom and cpuset_attach
  [4/4] memcg: change try_to_free_pages to hierarchical_reclaim

There is no special meaning in patch order except for 1 and 2.


Thanks,
Daisuke Nishimura.
