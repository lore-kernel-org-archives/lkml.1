Return-Path: <linux-kernel-owner+w=401wt.eu-S1756539AbYLEMai@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756539AbYLEMai (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2008 07:30:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750991AbYLEMa3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 5 Dec 2008 07:30:29 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:61825 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750912AbYLEMa2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2008 07:30:28 -0500
Date: Fri, 5 Dec 2008 21:22:08 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH -mmotm 0/4] patches for memory cgroup (20081205)
Message-Id: <20081205212208.31d904e0.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

These are patches that I have now.

Patches:
  [1/4] memcg: don't trigger oom at page migration
  [2/4] memcg: remove mem_cgroup_try_charge
  [3/4] memcg: avoid deadlock caused by race between oom and cpuset_attach
  [4/4] memcg: change try_to_free_pages to hierarchical_reclaim

There is no special meaning in patch order except for 1 and 2.

Any comments would be welcome.


Thanks,
Daisuke Nishimura.
