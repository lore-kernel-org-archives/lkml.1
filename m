Return-Path: <linux-kernel-owner+w=401wt.eu-S1757091AbZKDQLj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091AbZKDQLj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:11:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756977AbZKDQLj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:11:39 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:34564 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756927AbZKDQLi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:11:38 -0500
Date: Wed, 4 Nov 2009 10:11:42 -0600
From: "Serge E. Hallyn" <serue@us.ibm.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: balbir@linux.vnet.ibm.com, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>,
       Jan Safranek <jsafrane@redhat.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104161142.GA8825@us.ibm.com>
References: <20091104063005.GC3560@balbir.in.ibm.com> <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com> <20091104081618.GD3560@balbir.in.ibm.com> <1257348117.31972.4360.camel@nimitz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1257348117.31972.4360.camel@nimitz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dave Hansen (dave@linux.vnet.ibm.com):
> On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
> > The reason I liked /dev/cgroup was because cpusets could be
> > mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
> > is that a ls "/" now becomes larger in size. But I'll take your vote
> > for it as +1 for /cgroup.
> 
> /dev/pts is a decent precedent for doing it under /dev, although it does
> deal with actual devices.  cgroups do not.

Hmm, on whose behalf are you making this decision?

LSB people will want to avoid using /cgroup, but I think a lot of
admins will likely prefer /cgroup (as I do).  On my systems I
always use /cgroup, but would be more likely to use /mnt/cgroup
over /dev/cgroup.

lxc (at lxc.sf.net) rightfully takes the cgroupfs from wherever it
happens to be mounted.  Do you really need a mountpoint decided?

If you do, then while I DETEST the extra typing, I think
/sys/kernel/cgroup makes most sense, since that's where you find
debugfs and securityfs.

-serge
