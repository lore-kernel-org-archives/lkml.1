Return-Path: <linux-kernel-owner+w=401wt.eu-S1757042AbZEVIgL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042AbZEVIgL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 May 2009 04:36:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756826AbZEVIf5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 22 May 2009 04:35:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:56632 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756767AbZEVIfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 May 2009 04:35:54 -0400
Date: Fri, 22 May 2009 17:34:21 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Paul Menage <menage@google.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linux Containers <containers@lists.linux-foundation.org>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       libcg-devel@lists.sourceforge.net, dhaval@linux.vnet.ibm.com
Subject: Re: [PATCH] cgroups: handle failure of cgroup_populate_dir() at
 mount/remount
Message-Id: <20090522173421.ecacb40e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4A1663C2.4080401@cn.fujitsu.com>
References: <4A16153C.2080004@cn.fujitsu.com>
	<20090522172545.1e5e5f81.kamezawa.hiroyu@jp.fujitsu.com>
	<4A1663C2.4080401@cn.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 May 2009 16:35:14 +0800
Li Zefan <lizf@cn.fujitsu.com> wrote:

> KAMEZAWA Hiroyuki wrote:
> > On Fri, 22 May 2009 11:00:12 +0800
> > Li Zefan <lizf@cn.fujitsu.com> wrote:
> > 
> >> Now we have 'stat' file in both memory and cpuacct subsystems. If we
> >> mount these 2 subsystems with option 'noprefix', the creation of 'stat'
> >> file for cpuacct will fail, but without any notificatin to the user.
> >>
> >> With this patch, we fail the mount/remount in this case.
> >>
> > 
> > Hm, shouldn't we allow "noprefix" to be effective only agaisnt cpuset ?
> > I think it's just for backward-compatibility of cpuset.
> > (I don't like the option at all.)
> > 
> 
> Yes, this mount option was introduced for cpuset. But it has been here for
> a long time and people may use it when mounting other cgroup subsystems,
> then is it OK to change to restrict its use within cpuset only?

Asking libcgroup people may be appropriate...added CC.

Thanks,
-Kame

