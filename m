Return-Path: <linux-kernel-owner+w=401wt.eu-S1752461AbZBCDQt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752461AbZBCDQt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 22:16:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751248AbZBCDQj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 22:16:39 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48502 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751247AbZBCDQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 22:16:39 -0500
Date: Tue, 3 Feb 2009 12:15:24 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Chris Friesen" <cfriesen@nortel.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@minaslivre.org>,
       containers@lists.linux-foundation.org, debian-devel@lists.debian.org,
       linux-kernel@vger.kernel.org
Subject: Re: cgroup mount point
Message-Id: <20090203121524.cdff11ae.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <498779C2.2060908@nortel.com>
References: <20090202200013.GU3643@vespa.holoscopio.com>
	<1233606371.15779.32.camel@radis.liafa.jussieu.fr>
	<20090202205246.GA28593@glandium.org>
	<20090202214153.GV3643@vespa.holoscopio.com>
	<498779C2.2060908@nortel.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Feb 2009 16:54:58 -0600
"Chris Friesen" <cfriesen@nortel.com> wrote:

> Thadeu Lima de Souza Cascardo wrote:
> 
> > Linux Documentation is not consistent and have some funny options. In
> > Documentation/cgroups/*, we have:
> 
> > So, we have some more options now: /cgroups, /containers, /dev/cpuset,
> > /dev/cpuctl, /opt/cgroup, /opt/cpuset.
> > 
> > I am copying the container and the kernel guys. Perhaps, we can find an
> > agreement (if we want to find one at all) and change all that
> > Documentation to get consistent.
> 
> I'd vote for "cgroups" or "containers", mounted at / or /sys/.
> 
me, too.

But single mount point just assumes "all necessary subsystems are mounter at once"
So,
    /cgroup/<subsys>/       #this cannot handle multiple subsyses.
    or 
    /cgroup/some_nick_name  #just depends on users.

Hmm. Making documentation to use the same mount point is not so bad. But in real
usage, cgroup's mount point seems case-by-case. 
If libcgroup or libvirt shows some policy, it's good for users.

  /cgroup/<libcgroup's grouping nick name>/ ...

or some.

Thanks,
-Kame

> /opt feels more like where software should live, and /dev should be for 
> devices rather than capabilities/management.  "cpuctl" and "cpuset" are 
> subsets of the full capabilities of cgroups, so they're suboptimal as 
> far as naming.
> 
> Chris
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers
> 

