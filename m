Return-Path: <linux-kernel-owner+w=401wt.eu-S1765637AbYCELt4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765637AbYCELt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 06:49:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761317AbYCELtq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 06:49:46 -0500
Received: from e28smtp03.in.ibm.com ([59.145.155.3]:45067 "EHLO
	e28esmtp03.in.ibm.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759681AbYCELtp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 06:49:45 -0500
Message-ID: <47CE8882.9020003@linux.vnet.ibm.com>
Date: Wed, 05 Mar 2008 17:18:18 +0530
From: Balbir Singh <balbir@linux.vnet.ibm.com>
Reply-To: balbir@linux.vnet.ibm.com
Organization: IBM
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Denis V. Lunev" <den@parallels.com>
CC: Paul Menage <menage@google.com>, Dhaval Giani <dhaval@linux.vnet.ibm.com>,
       fedora-devel-list@redhat.com, opensuse-packaging@opensuse.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       containers@lists.linux-foundation.org,
       Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
       lkml <linux-kernel@vger.kernel.org>,
       Sudhir Kumar <skumar@linux.vnet.ibm.com>
Subject: Re: [Devel] Re: [RFC] libcg: design and plans
References: <20080304152341.GB5659@linux.vnet.ibm.com> <6599ad830803042215n6aedb3eeub0c037e6a4e7bb34@mail.gmail.com> <1204701467.15157.3.camel@iris.sw.ru>
In-Reply-To: <1204701467.15157.3.camel@iris.sw.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis V. Lunev wrote:
> On Tue, 2008-03-04 at 22:15 -0800, Paul Menage wrote:
>> Hi Dhaval,
>>
>> On Tue, Mar 4, 2008 at 7:23 AM, Dhaval Giani <dhaval@linux.vnet.ibm.com> wrote:
>>> Hi,
>>>
>>>  We have been working on a library for control groups which would provide
>>>  simple APIs for programmers to utilize from userspace and make use of
>>>  control groups.
>>>
>>>  We are still designing the library and the APIs. I've attached the
>>>  design (as of now) to get some feedback from the community whether we
>>>  are heading in the correct direction and what else should be addressed.
>> There are a few things that it would be nice to include in such a
>> library, if you're going to develop one:
>>
>> - the ability to create abstract groups of processes, and resource
>> groups, and have the ability to tie these together arbitrarily. E.g
>> you might create abstract groups A, B and C, and be able to say that A
>> and B share memory with each other but not with C, and all three
>> groups are isolated from each other for CPU. Then libcg would mount
>> different resource types in different cgroup hierarchies (you would
>> probably tell it ahead of time which combinations of sharing you would
>> want, in order that it could minimize the number of mounted
>> hierarchies). When you tell libcg to move a process into abstract
>> group A, it would move it into the appropriate resource group in each
>> hierarchy.
> 
> There is one more important thing. In addition to the processes you must
> unite or provide a way to unite other objects like sockets. This is
> needed to create a group-based socket buffer management.
> 
> The mapping between socket and a process does not exists right now and,
> we can have (virtually), sockets from from different namespaces in one
> process.
> 

Not sure how any of this is related to the library design we are discussing.
Your talking about writing a controller that groups based on sockets, that is a
totally different thing.

-- 
	Warm Regards,
	Balbir Singh
	Linux Technology Center
	IBM, ISTL
