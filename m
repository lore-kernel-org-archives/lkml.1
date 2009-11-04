Return-Path: <linux-kernel-owner+w=401wt.eu-S1757288AbZKDQl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757288AbZKDQl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:41:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757082AbZKDQl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:41:27 -0500
Received: from mx2.compro.net ([216.54.166.4]:32114 "EHLO mx2.compro.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756803AbZKDQl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:41:26 -0500
X-Greylist: delayed 857 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Nov 2009 11:41:26 EST
X-IronPort-AV: E=Sophos;i="4.44,680,1249272000"; 
   d="scan'208";a="4629729"
Message-ID: <4AF1AB60.7040108@compro.net>
Date: Wed, 04 Nov 2009 11:27:12 -0500
From: Mark Hounschell <markh@compro.net>
Reply-To: markh@compro.net
Organization: Compro Computer Svcs.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Dhaval Giani <dhaval@linux.vnet.ibm.com>
CC: Balbir Singh <balbir@linux.vnet.ibm.com>,
       Jan Safranek <jsafrane@redhat.com>,
       Dave Hansen <dave@linux.vnet.ibm.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
References: <20091104063005.GC3560@balbir.in.ibm.com> <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com> <20091104081618.GD3560@balbir.in.ibm.com> <1257348117.31972.4360.camel@nimitz> <4AF1A58E.1020003@redhat.com> <20091104160530.GI3560@balbir.in.ibm.com> <20091104160910.GN5495@linux.vnet.ibm.com>
In-Reply-To: <20091104160910.GN5495@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dhaval Giani wrote:
> On Wed, Nov 04, 2009 at 09:35:30PM +0530, Balbir Singh wrote:
>> * Jan Safranek <jsafrane@redhat.com> [2009-11-04 17:02:22]:
>>
>>> On 11/04/2009 04:21 PM, Dave Hansen wrote:
>>>> On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
>>>>> The reason I liked /dev/cgroup was because cpusets could be
>>>>> mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
>>>>> is that a ls "/" now becomes larger in size. But I'll take your vote
>>>>> for it as +1 for /cgroup.
>>>> /dev/pts is a decent precedent for doing it under /dev, although it does
>>>> deal with actual devices.  cgroups do not.
>>> There is also /dev/shm, but IMHO that's not reason to pollute /dev
>>> with filesystems that are not devices.
>>>
>> Yep, but hasn't the pollution already occured with /dev/cpuset today? 
>> sysfs would require work for changes to /sys, so do we go with Kame's
>> suggestion of /cgroup?
>>
> 
> I vote for /cgroup as well.
> 
> thanks,

If this is really a voting matter, I would vote for /sys even if it does require someone to do some work, and also
the /dev/cpuset stuff to also move to /sys.  IE /sys/cgroup/cpuset etc..  Leave /  and /dev alone. 

thanks
mark
