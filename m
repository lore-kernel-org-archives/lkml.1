Return-Path: <linux-kernel-owner+w=401wt.eu-S1756994AbZKDQDP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756994AbZKDQDP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Nov 2009 11:03:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756926AbZKDQDN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Nov 2009 11:03:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24730 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756920AbZKDQDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Nov 2009 11:03:12 -0500
Message-ID: <4AF1A58E.1020003@redhat.com>
Date: Wed, 04 Nov 2009 17:02:22 +0100
From: Jan Safranek <jsafrane@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: balbir@linux.vnet.ibm.com,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       containers@lists.linux-foundation.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Bharata B Rao <bharata.rao@in.ibm.com>,
       libcg-devel <libcg-devel@lists.sourceforge.net>,
       "menage@google.com" <menage@google.com>
Subject: Re: [RFC] Mount point suggestions for cgroup
References: <20091104063005.GC3560@balbir.in.ibm.com>	 <20091104154024.0b8f6123.kamezawa.hiroyu@jp.fujitsu.com>	 <20091104081618.GD3560@balbir.in.ibm.com> <1257348117.31972.4360.camel@nimitz>
In-Reply-To: <1257348117.31972.4360.camel@nimitz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2009 04:21 PM, Dave Hansen wrote:
> On Wed, 2009-11-04 at 13:46 +0530, Balbir Singh wrote:
>> The reason I liked /dev/cgroup was because cpusets could be
>> mounted at /dev/cpuset or /dev/cgroup/cpuset. My concern with /cgroup
>> is that a ls "/" now becomes larger in size. But I'll take your vote
>> for it as +1 for /cgroup.
>
> /dev/pts is a decent precedent for doing it under /dev, although it does
> deal with actual devices.  cgroups do not.

There is also /dev/shm, but IMHO that's not reason to pollute /dev with 
filesystems that are not devices.

Jan
