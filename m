Return-Path: <linux-kernel-owner+w=401wt.eu-S1756999AbZKDQFb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756999AbZKDQFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:05:31 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZKDQFa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:05:30 -0500
Received: from e28smtp06.in.ibm.com ([59.145.155.6]:47618 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756839AbZKDQFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:05:30 -0500
Date: Wed, 4 Nov 2009 21:35:30 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
To: Jan Safranek <jsafrane@redhat.com>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
Message-ID: <20091104160530.GI3560@balbir.in.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
References: <20091104063005.GC3560@balbir.in.ibm.com>
 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>
 <20091104081618.GD3560@balbir.in.ibm.com>
 <1257348117.31972.4360.camel@nimitz>
 <4AF1A58E.1020003@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4AF1A58E.1020003@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Jan Safranek <jsafrane@redhat.com> [2009-11-04 17:02:22]:

> On 11/04/2009 04:21 PM, Dave Hansen wrote:
> >On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
> >>The reason I liked /dev/cgroup was because cpusets could be
> >>mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
> >>is that a ls "/" now becomes larger in size. But I'll take your vote
> >>for it as +1 for /cgroup.
> >
> >/dev/pts is a decent precedent for doing it under /dev, although it does
> >deal with actual devices.  cgroups do not.
> 
> There is also /dev/shm, but IMHO that's not reason to pollute /dev
> with filesystems that are not devices.
>

Yep, but hasn't the pollution already occured with /dev/cpuset today? 
sysfs would require work for changes to /sys, so do we go with Kame's
suggestion of /cgroup?

-- 
	Balbir
