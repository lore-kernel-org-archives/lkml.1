Return-Path: <linux-kernel-owner+w=401wt.eu-S1754606AbZBZIWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754606AbZBZIWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Feb 2009 03:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751776AbZBZIWQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Feb 2009 03:22:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:52792 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344AbZBZIWP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Feb 2009 03:22:15 -0500
Date: Thu, 26 Feb 2009 17:20:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: bharata@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       Balaji Rao <balajirrao@gmail.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       Paul Menage <menage@google.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC PATCH 1/2] New cgroup subsystem API (->initialize())
Message-Id: <20090226172056.d0e53e98.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49A64EB8.9020203@cn.fujitsu.com>
References: <20090225105730.GA4008@in.ibm.com>
	<20090225105831.GB4008@in.ibm.com>
	<49A604BA.9090407@cn.fujitsu.com>
	<20090226075259.GA3312@in.ibm.com>
	<49A64EB8.9020203@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Feb 2009 16:11:36 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> Bharata B Rao wrote:
> > On Thu, Feb 26, 2009 at 10:55:54AM +0800, Li Zefan wrote:
> >> Bharata B Rao wrote:
> >>> From: Balaji Rao <balajirrao@gmail.com>
> > Another thing that could be done is to enhance already existing
> > cpuacct controller to do stime/utime accouting also. cpuacct controller
> > exists precisely for doing per-cgroup accounting and is there any reason
> > why these stats shouldn't be part of cpuacct controller. If we do this,
> > users would be forced to use cpu controller and cpuacct controller
> > together. Is that a problem ?
> > 
> 
> I wondered why these stats is part of cpu subsystem but not cpuacct.
> And I don't see any problem to use these 2 subsystems together. Actually
> this is one of the advantage of cgroup.
> 
IMHO, cpuacct subsystem should count utime/stime.
current statistics is not so useful.

BTW, I wonde why cpuacct subsys walks up to root at charging...
I think we can gather all subtree information at read...

Thanks
-Kame

