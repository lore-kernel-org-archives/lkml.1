Return-Path: <linux-kernel-owner+w=401wt.eu-S1753504Ab0AGXuq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753504Ab0AGXuq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 18:50:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753324Ab0AGXup
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 18:50:45 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:46538 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235Ab0AGXup (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 18:50:45 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 8 Jan 2010 08:47:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [RFC] Shared page accounting for memory cgroup
Message-Id: <20100108084727.429c40fc.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100107092736.GW3059@balbir.in.ibm.com>
References: <20100104093528.04846521.kamezawa.hiroyu@jp.fujitsu.com>
	<20100104005030.GG16187@balbir.in.ibm.com>
	<20100106130258.a918e047.kamezawa.hiroyu@jp.fujitsu.com>
	<20100106070150.GL3059@balbir.in.ibm.com>
	<20100106161211.5a7b600f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107071554.GO3059@balbir.in.ibm.com>
	<20100107163610.aaf831e6.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107083440.GS3059@balbir.in.ibm.com>
	<20100107174814.ad6820db.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107180800.7b85ed10.kamezawa.hiroyu@jp.fujitsu.com>
	<20100107092736.GW3059@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jan 2010 14:57:36 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2010-01-07 18:08:00]:
> 
> > On Thu, 7 Jan 2010 17:48:14 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > > > > "How pages are shared" doesn't show good hints. I don't hear such parameter
> > > > > is used in production's resource monitoring software.
> > > > > 
> > > > 
> > > > You mean "How many pages are shared" are not good hints, please see my
> > > > justification above. With Virtualization (look at KSM for example),
> > > > shared pages are going to be increasingly important part of the
> > > > accounting.
> > > > 
> > > 
> > > Considering KSM, your cuounting style is tooo bad.
> > > 
> > > You should add 
> > > 
> > >  - MEM_CGROUP_STAT_SHARED_BY_KSM
> > >  - MEM_CGROUP_STAT_FOR_TMPFS/SYSV_IPC_SHMEM
> > > 
> 
> No.. I am just talking about shared memory being important and shared
> accounting being useful, no counters for KSM in particular (in the
> memcg context).
> 
Think so ? The number of memcg-private pages is in interest in my point of view.

Anyway, I don't change my opinion as "sum of rss" is not necessary to be calculated
in the kernel.
If you want to provide that in memcg, please add it to global VM as /proc/meminfo.

IIUC, KSM/SHMEM has some official method in global VM.

Thanks,
-Kame

