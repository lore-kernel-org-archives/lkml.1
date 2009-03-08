Return-Path: <linux-kernel-owner+w=401wt.eu-S1753426AbZCHXrQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426AbZCHXrQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Mar 2009 19:47:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751589AbZCHXrA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Mar 2009 19:47:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55071 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbZCHXq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Mar 2009 19:46:59 -0400
Date: Mon, 9 Mar 2009 08:45:36 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Balbir Singh <balbir@linux.vnet.ibm.com>, linux-mm@kvack.org,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>,
       YAMAMOTO Takashi <yamamoto@valinux.co.jp>,
       Bharata B Rao <bharata@in.ibm.com>, Paul Menage <menage@google.com>,
       lizf@cn.fujitsu.com, linux-kernel@vger.kernel.org,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       David Rientjes <rientjes@google.com>,
       Pavel Emelianov <xemul@openvz.org>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC][PATCH 3/3] memcg documenation soft limit (Yet Another
 One)
Message-Id: <20090309084536.d5b1c110.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <49B153A3.8090906@oracle.com>
References: <20090306092323.21063.93169.sendpatchset@localhost.localdomain>
	<20090306185440.66b92ca3.kamezawa.hiroyu@jp.fujitsu.com>
	<20090306193438.8084837d.kamezawa.hiroyu@jp.fujitsu.com>
	<20090306193821.ca2fb628.kamezawa.hiroyu@jp.fujitsu.com>
	<49B153A3.8090906@oracle.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 06 Mar 2009 08:47:31 -0800
Randy Dunlap <randy.dunlap@oracle.com> wrote:
> > +	  Allowed priority level is 3-0 and 3 is the lowest.
> 
> 	Not very user friendly...
> 
Ok, then, 0(lowest) - 8(highest) in the next version.

-Kame

> > +	  If 0, this cgroup will not be target of softlimit.
> > +
> > +  At memory shortage of the system (or local node/zone), softlimit helps
> > +  kswapd(), a global memory recalim kernel thread, and inform victim cgroup
> 
>                                reclaim                    informs
> 
> > +  to be shrinked to kswapd.
> > +
> > +  Victim selection logic:
> > +  The kernel searches from the lowest priroty(3) up to the highest(1).
> 
>                                          priority                     0 ?? (from above)
> 
> > +  If it find a cgroup witch has memory larger than softlimit, steal memory
> 
>            finds         which
> 
> > +  from it.
> > +  If multiple cgroups are on the same priority, each cgroup wil be a
> 
>                                                                will
> 
> > +  victim in turn.
> >  
> >  6. Hierarchy support
> 
> 
> -- 
> ~Randy
> 
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
> 

