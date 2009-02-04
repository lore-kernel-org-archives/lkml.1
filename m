Return-Path: <linux-kernel-owner+w=401wt.eu-S1754803AbZBDGxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754803AbZBDGxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 01:53:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751527AbZBDGxQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 01:53:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42060 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbZBDGxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 01:53:16 -0500
Date: Wed, 4 Feb 2009 15:52:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: balbir@linux.vnet.ibm.com, Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [-mm patch] Show memcg information during OOM (v3)
Message-Id: <20090204155203.3733dc8e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49893A5A.7000506@cn.fujitsu.com>
References: <20090203172135.GF918@balbir.in.ibm.com>
	<4988E727.8030807@cn.fujitsu.com>
	<20090204033750.GB4456@balbir.in.ibm.com>
	<20090204142455.83c38ad6.kamezawa.hiroyu@jp.fujitsu.com>
	<20090204064249.GC4456@balbir.in.ibm.com>
	<49893A5A.7000506@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 14:48:58 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> >> BTW, I wonder can't we show the path of mount point ?
> >> /group_A/01 is /cgroup/group_A/01 and /group_A/ is /cgroup/group_A/ on this system.
> >> Very difficult ?
> >>
> > 
> > No, it is not very difficult, we just need to append the mount point.
> > The reason for not doing it is consistency with output of
> > /proc/<pid>/cgroup and other places where cgroup_path prints the path
> > relative to the mount point. Since we are talking about memory, the
> > administrator should know where it is mounted. Do you strongly feel
> > the need to add mount point? My concern is consistency with other
> > cgroup output (look at /proc/sched_debug) for example.
> > 
> 
> Another reason to not do so is, we can mount a specific hierarchy to
> multiple mount points.
> 	# mount -t cgroup -o memory /mnt
> 	# mount -t cgroup -o memory /cgroup
> 	# mkdir /mnt/0
> Now, /mnt/0 is the same with /cgroup/0.
> 
Thank you for clarification. Current logic seems right.

Thanks.
-Kame

