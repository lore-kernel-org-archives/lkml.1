Return-Path: <linux-kernel-owner+w=401wt.eu-S1757626AbXIZTyY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626AbXIZTyY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2007 15:54:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751376AbXIZTyP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Sep 2007 15:54:15 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:43218 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118AbXIZTyP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2007 15:54:15 -0400
Message-ID: <46FAB8E4.5070809@us.ibm.com>
Date: Wed, 26 Sep 2007 12:54:12 -0700
From: David Wilder <dwilder@us.ibm.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070301)
MIME-Version: 1.0
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, hch@infradead.org,
       mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH 0/3] A kernel tracing interface - (updated)
References: <1190830949.1232.11.camel@lc4eb748232119.ibm.com> <20070926114108.6ac77ce5.randy.dunlap@oracle.com>
In-Reply-To: <20070926114108.6ac77ce5.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap wrote:
> On Wed, 26 Sep 2007 11:22:29 -0700 David J. Wilder wrote:
> 
>> These patches provide a kernel tracing interface called "trace".
>>
>> (update) Moved the sample code to the new samples\ subdir
>>
>> The motivation for "trace" is to:
>> - Provide a simple set of tracing primitives that will utilize the high-
>>   performance and low-overhead of relayfs for passing traces data from
>>   kernel to user space.
>> - Provide a common user interface for managing kernel traces.
>> - Allow for binary as well as ascii trace data.
>> - Incorporate features from the systemtap runtime that are
>>   useful to others.
>>
>> Patches are against 2.6.23-rc6-mm1
>>
>> Summary of patches:
>> [patch 1/3]  Trace code and documentation
>> [patch 2/3]  Relay Reset Consumed
>> [patch 3/3]  Trace sample
>>
>> Note: Patches 1/3 and 2/3 must be applied together.
> 
> Patch 2 provides an interface that patch 1 needs, correct?
Yes.
> So yes, patches 1 & 2 need to be applied together (merged),
> or their order could be reversed, yes?  
2/3 should be applied at the same time as 1/3,  or 2/3 can be applied 
standalone.  The order they are applied makes no difference.  But trace 
will not build if the relay patch is not applied.

Can't the Relay patch
> be merged standalone without breaking anything?

Yes the relay patch can be applied standalone.



> 
> 
>> Note: The following patches must be applied with 3/3.
>> [patch 3/5] Add samples subdir
>> 	http://lkml.org/lkml/2007/9/25/157
>> [patch 4/5] Linux Kernel Markers - Samples
>> 	http://lkml.org/lkml/2007/9/25/166
> 
> 
> ---
> ~Randy
> Phaedrus says that Quality is about caring.
> 

