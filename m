Return-Path: <linux-kernel-owner+w=401wt.eu-S1755536AbZBFGRY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbZBFGRY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Feb 2009 01:17:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752265AbZBFGRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Feb 2009 01:17:15 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:55103 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750990AbZBFGRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Feb 2009 01:17:14 -0500
Date: Fri, 6 Feb 2009 11:47:03 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Chris Friesen <cfriesen@nortel.com>,
       Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
       containers@lists.linux-foundation.org, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-ID: <20090206061703.GA26902@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20090202200013.GU3643@vespa.holoscopio.com> <1233606371.15779.32.camel@radis.liafa.jussieu.fr> <20090202205246.GA28593@glandium.org> <20090202214153.GV3643@vespa.holoscopio.com> <498779C2.2060908@nortel.com> <20090203121524.cdff11ae.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20090203121524.cdff11ae.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2009-02-03 12:15:24]:

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
> 
> or some.
> 

FYI for everyone

Please take a look at libcgroup (libcg.sf.net). Through the
configuration mechanism, we allow the controllers to be mounted at any
desired location and provide configuration persistence across machine
reboots. The configuration (as in created cgroups and controller mount
points) is controlled via a configuration file.

-- 
	Balbir
