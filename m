Return-Path: <linux-kernel-owner+w=401wt.eu-S1752849AbZBCFHN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbZBCFHN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 00:07:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751046AbZBCFG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 00:06:59 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:38177 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbZBCFG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 00:06:58 -0500
Date: Mon, 2 Feb 2009 23:06:55 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
       containers@lists.linux-foundation.org, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090203050654.GA11598@us.ibm.com>
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <498779C2.2060908@nortel.com> <20090203121524.cdff11ae.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090203121524.cdff11ae.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting KAMEZAWA Hiroyuki (kamezawa.hiroyu@jp.fujitsu.com):
> On Mon, 02 Feb 2009 16:54:58 -0600
> "Chris Friesen" <cfriesen@nortel.com> wrote:
> 
> > Thadeu Lima de Souza Cascardo wrote:
> > 
> > > Linux Documentation is not consistent and have some funny options. In
> > > Documentation/cgroups/*, we have:
> > 
> > > So, we have some more options now: /cgroups, /containers, /dev/cpuset,
> > > /dev/cpuctl, /opt/cgroup, /opt/cpuset.
> > > 
> > > I am copying the container and the kernel guys. Perhaps, we can find an
> > > agreement (if we want to find one at all) and change all that
> > > Documentation to get consistent.
> > 
> > I'd vote for "cgroups" or "containers", mounted at / or /sys/.
> > 
> me, too.
> 
> But single mount point just assumes "all necessary subsystems are mounter at once"
> So,
>     /cgroup/<subsys>/       #this cannot handle multiple subsyses.
>     or 
>     /cgroup/some_nick_name  #just depends on users.
> 
> Hmm. Making documentation to use the same mount point is not so bad. But in real
> usage, cgroup's mount point seems case-by-case. 
> If libcgroup or libvirt shows some policy, it's good for users.
> 
>   /cgroup/<libcgroup's grouping nick name>/ ...

I'm lazy so I always use /cgroup or actually /cg.

I do the same thing with mounting /sys/kernel/security under /security,
so maybe /sys/cgroup actually makes sense :)

-serge
