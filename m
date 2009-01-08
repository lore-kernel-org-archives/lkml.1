Return-Path: <linux-kernel-owner+w=401wt.eu-S1758030AbZAHKMW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030AbZAHKMW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2009 05:12:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751846AbZAHKMO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Jan 2009 05:12:14 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:38385 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751586AbZAHKMN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2009 05:12:13 -0500
Date: Thu, 8 Jan 2009 19:08:18 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kamezawa.hiroyu@jp.fujitsu.com,
       balbir@linux.vnet.ibm.com, lizf@cn.fujitsu.com, menage@google.com,
       nishimura@mxp.nes.nec.co.jp
Subject: [RFC][PATCH 0/4] some memcg fixes
Message-Id: <20090108190818.b663ce20.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

These are patches that I've been testing.

They survived my test(rmdir aftre task move under memory pressure
and page migration) w/o big problem(except oom) for hours
in both use_hierarchy==0/1 case.

I want them go in 2.6.29.

They are based on mmotm-2009-01-05-12-50.

[1/4] fix for mem_cgroup_get_reclaim_stat_from_page

[2/4] fix error path of mem_cgroup_move_parent

[3/4] fix for mem_cgroup_hierarchical_reclaim

[4/4] make oom less frequently


I think 1 and 2 are ok.
I'll update them based on comments.


Thanks,
Daisuke Nishimura.
