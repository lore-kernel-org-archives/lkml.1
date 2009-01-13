Return-Path: <linux-kernel-owner+w=401wt.eu-S1756043AbZAMKdv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756043AbZAMKdv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 05:33:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753170AbZAMKdm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 05:33:42 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:58652 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752969AbZAMKdm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 05:33:42 -0500
Date: Tue, 13 Jan 2009 18:45:33 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Pavel Emelyanov <xemul@openvz.org>, Li Zefan <lizf@cn.fujitsu.com>,
       Paul Menage <menage@google.com>, nishimura@mxp.nes.nec.co.jp
Subject: [PATCH -rc] some fixes for memcg
Message-Id: <20090113184533.6ffd2af9.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew.

These are some fixes for memcg that has been pushed into mainline.

They are based on 2.6.29-rc1.

[1/4] fix mem_cgroup_get_reclaim_stat_from_page

[2/4] fix error path of mem_cgroup_move_parent

[3/4] fix hierarchical reclaim

[4/4] make oom less frequently


Thanks,
Daisuke Nishimura.
