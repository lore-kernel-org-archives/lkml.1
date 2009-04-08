Return-Path: <linux-kernel-owner+w=401wt.eu-S1751751AbZDHHg7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751751AbZDHHg7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Apr 2009 03:36:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932133AbZDHHgM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Apr 2009 03:36:12 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:40556 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761311AbZDHHgL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Apr 2009 03:36:11 -0400
Date: Wed, 8 Apr 2009 16:34:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Bharata B Rao <bharata.rao@gmail.com>
Cc: balbir@linux.vnet.ibm.com, "linux-mm@kvack.org" <linux-mm@kvack.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "lizf@cn.fujitsu.com" <lizf@cn.fujitsu.com>,
       Rik van Riel <riel@surriel.com>, Bharata B Rao <bharata.rao@in.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFI] Shared accounting for memory resource controller
Message-Id: <20090408163440.4442dc3c.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <344eb09a0904080031y4406c001n584725b87024755@mail.gmail.com>
References: <20090407063722.GQ7082@balbir.in.ibm.com>
	<20090407163331.8e577170.kamezawa.hiroyu@jp.fujitsu.com>
	<20090407080355.GS7082@balbir.in.ibm.com>
	<20090407172419.a5f318b9.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408052904.GY7082@balbir.in.ibm.com>
	<20090408151529.fd6626c2.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408070401.GC7082@balbir.in.ibm.com>
	<20090408160733.4813cb8d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090408071115.GD7082@balbir.in.ibm.com>
	<20090408161824.26f47077.kamezawa.hiroyu@jp.fujitsu.com>
	<344eb09a0904080031y4406c001n584725b87024755@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Apr 2009 13:01:15 +0530
Bharata B Rao <bharata.rao@gmail.com> wrote:

> On Wed, Apr 8, 2009 at 12:48 PM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> >
> > On Wed, 8 Apr 2009 12:41:15 +0530
> > Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> > > 3. Using the above, we can then try to (using an algorithm you
> > > proposed), try to do some work for figuring out the shared percentage.
> > >
> > This is the point. At last. Why "# of shared pages" is important ?
> >
> > I wonder it's better to add new stat file as memory.cacheinfo which helps
> > following kind of commands.
> >
> >  #cacheinfo /cgroups/memory/group01/
> >       /usr/lib/libc.so.1     30pages
> >       /var/log/messages      1 pages
> >       /tmp/xxxxxx            20 pages
> 
> Can I suggest that we don't add new files for additional stats and try
> as far as possible to include them in <controller>.stat file. Please
> note that we have APIs in libcgroup library which can return
> statistics from controllers associated with a cgroup and these APIs
> assume that stats are part of <controller>.stat file.
> 
Hmm ? Is there generic assumption as all cgroup has "stat" file ?
And libcgroup cause bug if the new entry is added to stat file ?
(IOW, libcgroup can't ignore new entry added ?)

Thanks,
-Kame

