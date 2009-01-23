Return-Path: <linux-kernel-owner+w=401wt.eu-S1760717AbZAWINS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760717AbZAWINS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2009 03:13:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753499AbZAWINH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Jan 2009 03:13:07 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:46658 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753796AbZAWING (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2009 03:13:06 -0500
Date: Fri, 23 Jan 2009 17:04:48 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: nishimura@mxp.nes.nec.co.jp, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "menage@google.com" <menage@google.com>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/7] memcg : use CSS ID in memcg
Message-Id: <20090123170448.5eac1026.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20090123162232.5a81e0d3.nishimura@mxp.nes.nec.co.jp>
References: <20090122183411.3cabdfd2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090122183557.3b058e98.kamezawa.hiroyu@jp.fujitsu.com>
	<20090123162232.5a81e0d3.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +static s64 mem_cgroup_local_usage(struct mem_cgroup_stat *stat)
> > +{
> > +	s64 ret;
> > +
> It would be better to initialize it to 0.
> 
> > +	ret = mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_CACHE);
> > +	ret += mem_cgroup_read_stat(stat, MEM_CGROUP_STAT_RSS);
> > +	return ret;
> > +}
> > +
Ah, ret is initialized by mem_cgroup_read_stat...

please ignore the above comment.


Thanks,
Daisuke Nishimura.
