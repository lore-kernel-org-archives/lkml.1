Return-Path: <linux-kernel-owner+w=401wt.eu-S1757158AbZKDQSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158AbZKDQSd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756780AbZKDQSd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:18:33 -0500
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:54793 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756167AbZKDQSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:18:32 -0500
Date: Wed, 4 Nov 2009 21:48:32 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       Jan Safranek <jsafrane@redhat.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104161832.GJ3560@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
 <20091104081618.GD3560@balbir.in.ibm.com>
 <1257348117.31972.4360.camel@nimitz>
 <20091104161142.GA8825@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20091104161142.GA8825@us.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Serge E. Hallyn <serue@us.ibm.com> [2009-11-04 10:11:42]:

> Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> > On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
> > > The reason I liked /dev/cgroup was because cpusets could be
> > > mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
> > > is that a ls "/" now becomes larger in size. But I'll take your vote
> > > for it as +1 for /cgroup.
> > 
> > /dev/pts is a decent precedent for doing it under /dev, although it does
> > deal with actual devices.  cgroups do not.
> 
> Hmm, on whose behalf are you making this decision?
> 
> LSB people will want to avoid using /cgroup, but I think a lot of
> admins will likely prefer /cgroup (as I do).  On my systems I
> always use /cgroup, but would be more likely to use /mnt/cgroup
> over /dev/cgroup.
> 
> lxc (at lxc.sf.net) rightfully takes the cgroupfs from wherever it
> happens to be mounted.  Do you really need a mountpoint decided?
> 
> If you do, then while I DETEST the extra typing, I think
> /sys/kernel/cgroup makes most sense, since that's where you find
> debugfs and securityfs.
>

I would like to make this decision as a part of the tooling
development team for cgroups. So far we have

/cgroup +2
/sys    +1
/dev    +1

The concern with /sys/kernel/cgroup is that it would require creation
of sysfs directory that might not be backwards compatible way back to
2.6.24 when cgroups were first added. 

-- 
	Balbir
